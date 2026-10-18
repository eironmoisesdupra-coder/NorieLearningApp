import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import { MeshoptDecoder } from 'meshoptimizer';
import { AtlasState, isSelectionGesture, validPayload } from './state.mjs';
import { FrameScheduler } from './render_scheduler.mjs';
import { qualityPixelRatio } from './render_quality.mjs';
import { RenderMetrics } from './render_metrics.mjs';

export class AtlasScene {
  constructor(canvas, catalog, emit) {
    this.canvas = canvas;
    this.catalog = catalog;
    this.emit = emit;
    this.state = new AtlasState(catalog.structures);
    this.entries = new Map(catalog.structures.map(s => [s.id, s]));
    this.assets = new Map(catalog.assets.map(a => [a.id, a]));
    this.loaded = new Map();
    this.disposed = false;
    this.contextLost = false;
    this.document = canvas.ownerDocument;
    this.metrics = new RenderMetrics();
    // Preserve the existing DPR ceiling until the learner opts into a profile.
    this.qualityProfile = 'high';
    this.alpha = 1;
    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color('#0b1629');
    this.camera = new THREE.PerspectiveCamera(40, 1, .001, 100);
    this.camera.position.set(0, 1, 3);
    this.renderer = new THREE.WebGLRenderer({ canvas, antialias: true, powerPreference: 'high-performance' });
    this.renderer.setPixelRatio(qualityPixelRatio(this.qualityProfile, globalThis.devicePixelRatio));
    this.renderer.outputColorSpace = THREE.SRGBColorSpace;
    this.controls = new OrbitControls(this.camera, canvas);
    this.controls.enableDamping = true;
    this.controls.target.set(0, .9, 0);
    this.controls.minDistance = .005;
    this.controls.maxDistance = 8;
    this.scheduler = new FrameScheduler({
      update: () => {
        this.frameStarted = performance.now();
        return this.controls.update();
      },
      render: () => {
        this.renderer.render(this.scene, this.camera);
        this.metrics.frame(performance.now() - this.frameStarted, this.renderer.info);
      },
    });
    this.onControlsChange = () => this.scheduler.invalidate();
    this.onControlsStart = () => { this.controlInteracting = true; this.syncActivity(); };
    this.onControlsEnd = () => { this.controlInteracting = false; this.syncActivity(); };
    this.controls.addEventListener('change', this.onControlsChange);
    this.controls.addEventListener('start', this.onControlsStart);
    this.controls.addEventListener('end', this.onControlsEnd);
    this.scene.add(new THREE.HemisphereLight(0xddeeff, 0x4c4050, 2.1));
    for (const [x, y, z, intensity] of [[2, 3, 4, 2.8], [-3, 1, -2, 1.8]]) {
      const light = new THREE.DirectionalLight(0xffffff, intensity);
      light.position.set(x, y, z);
      this.scene.add(light);
    }
    this.loader = new GLTFLoader().setMeshoptDecoder(MeshoptDecoder);
    this.raycaster = new THREE.Raycaster();
    this.pointerCount = 0;
    this.onDown = event => {
      this.pointerCount++;
      this.syncActivity();
      if (this.pointerCount === 1) this.gesture = { x: event.clientX, y: event.clientY, pointers: 1 };
      else if (this.gesture) this.gesture.pointers = this.pointerCount;
    };
    this.onUp = event => {
      this.pointerCount = Math.max(0, this.pointerCount - 1);
      if (this.pointerCount === 0 && isSelectionGesture(this.gesture, { x: event.clientX, y: event.clientY })) this.pick(event);
      if (this.pointerCount === 0) this.gesture = null;
      this.syncActivity();
    };
    this.onCancel = () => { this.pointerCount = 0; this.gesture = null; this.syncActivity(); };
    this.onMove = event => {
      if (this.gesture && Math.hypot(event.clientX - this.gesture.x, event.clientY - this.gesture.y) > 6) this.gesture.moved = true;
      if (this.pointerCount) this.scheduler.invalidate();
    };
    canvas.addEventListener('pointerdown', this.onDown);
    canvas.addEventListener('pointerup', this.onUp);
    canvas.addEventListener('pointercancel', this.onCancel);
    canvas.addEventListener('pointermove', this.onMove);
    this.onVisibility = () => {
      if (this.document.hidden) {
        this.controlInteracting = false;
        this.onCancel();
      }
      this.scheduler.setVisible(!this.document.hidden);
    };
    this.onContextLost = event => {
      event.preventDefault();
      if (this.disposed) return;
      this.contextLost = true;
      this.scheduler.setPaused(true);
      this.emit('error', { message: 'The 3D graphics context was interrupted. Wait for recovery or retry this view.' });
    };
    this.onContextRestored = () => {
      if (this.disposed) return;
      this.contextLost = false;
      this.resize();
      this.scheduler.setPaused(false);
      if (this.lastLoaded?.generation === this.state.generation) {
        this.emit('loaded', { ...this.lastLoaded.payload, count: this.state.visibleIds().length });
      }
    };
    this.document.addEventListener('visibilitychange', this.onVisibility);
    canvas.addEventListener('webglcontextlost', this.onContextLost);
    canvas.addEventListener('webglcontextrestored', this.onContextRestored);
    this.onVisibility();
    this.resizeObserver = new ResizeObserver(() => this.resize());
    this.resizeObserver.observe(canvas);
    this.resize();
  }

  syncActivity() { this.scheduler.setActive(this.pointerCount > 0 || this.controlInteracting === true); }

  resize() {
    if (this.disposed) return;
    const width = Math.max(1, this.canvas.clientWidth), height = Math.max(1, this.canvas.clientHeight);
    this.camera.aspect = width / height;
    this.camera.updateProjectionMatrix();
    const ratio = qualityPixelRatio(this.qualityProfile, globalThis.devicePixelRatio);
    if (this.renderer.getPixelRatio() !== ratio) this.renderer.setPixelRatio(ratio);
    this.renderer.setSize(width, height, false);
    this.scheduler.invalidate();
  }

  async configure(payload) {
    if (this.disposed) return false;
    if (!validPayload('configure', payload)) throw Error('Invalid atlas selection');
    const loadStarted = performance.now();
    const { reference, systems, target = null, quiz = false, requestId = 0 } = payload;
    const knownSystems = new Set(this.catalog.structures.flatMap(s => s.systems));
    if (!this.catalog.references.some(r => r.id === reference) || !systems.every(s => knownSystems.has(s)) ||
        (target && !this.catalog.structures.some(s => s.id === target && s.reference === reference && s.systems.some(x => systems.includes(x))))) {
      throw Error('Invalid atlas selection');
    }
    const generation = this.state.configure(reference, systems);
    this.quiz = quiz === true;
    this.alpha = 1;
    const wanted = new Set(this.state.eligible().map(s => s.asset));
    for (const [id, value] of this.loaded) {
      if (!wanted.has(id)) { this.release(value); this.loaded.delete(id); }
    }
    this.updateVisibility();
    if (!wanted.size) { this.emit('error', { requestId, message: 'This reference has no modeled structures for the selected systems.' }); return; }
    this.emit('loading', { requestId, completed: 0, total: wanted.size });
    let completed = 0;
    for (const id of wanted) {
      if (this.disposed || !this.state.accepts(generation)) return;
      if (!this.loaded.has(id)) {
        const asset = this.assets.get(id);
        if (!asset || !/^[\w-]+\.glb$/.test(asset.file)) throw Error('Invalid local anatomy asset');
        let gltf;
        try { gltf = await this.loader.loadAsync(new URL(asset.file, location.href).href); }
        catch (error) { if (!this.state.accepts(generation) || this.disposed) return; throw error; }
        if (this.disposed || !this.state.accepts(generation)) { this.release(gltf.scene); return; }
        const originalMaterials = new Set();
        gltf.scene.traverse(object => {
          if (!object.isMesh) return;
          let parent = object;
          while (parent && !parent.userData.atlasStructure) parent = parent.parent;
          object.userData.structureId = parent?.userData.atlasStructure;
          if (!object.geometry.attributes.normal) object.geometry.computeVertexNormals();
          const material = Array.isArray(object.material) ? object.material[0] : object.material;
          for (const original of Array.isArray(object.material) ? object.material : [object.material]) originalMaterials.add(original);
          object.material = material.clone();
          object.material.side = THREE.DoubleSide;
          object.userData.baseColor = object.material.color.clone();
        });
        for (const material of originalMaterials) material.dispose();
        this.loaded.set(id, gltf.scene);
        this.scene.add(gltf.scene);
        this.scheduler?.invalidate();
      }
      this.emit('loading', { requestId, completed: ++completed, total: wanted.size });
    }
    if (this.disposed || !this.state.accepts(generation)) return;
    this.updateVisibility();
    if (target && this.state.select(target)) {
      if (this.quiz) this.state.isolate(target);
      this.updateVisibility(); this.focus(target);
    }
    else if (this.state.selected) this.focus(this.state.selected);
    else this.frame();
    this.metrics?.load(performance.now() - loadStarted);
    this.lastLoaded = { generation, payload: { requestId, count: this.state.visibleIds().length } };
    if (!this.contextLost) this.emit('loaded', this.lastLoaded.payload);
  }

  meshes() {
    const meshes = [];
    for (const root of this.loaded.values()) root.traverse(o => { if (o.isMesh) meshes.push(o); });
    return meshes;
  }
  updateVisibility() {
    const visible = new Set(this.state.visibleIds());
    for (const mesh of this.meshes()) {
      const id = mesh.userData.structureId;
      mesh.visible = visible.has(id);
      const selected = !this.quiz && this.state.selected === id;
      const compared = !this.quiz ? this.state.compareIds.indexOf(id) : -1;
      const color = selected ? '#42e8e0' : compared === 0 ? '#70c8ff' : compared === 1 ? '#ffc477' : null;
      mesh.material.color.copy(color ? new THREE.Color(color) : mesh.userData.baseColor);
      mesh.material.emissive.set(color ? '#104d53' : '#000000');
      const alpha = this.state.effectiveOpacity(id, this.alpha);
      mesh.material.transparent = alpha < 1;
      mesh.material.opacity = alpha;
      mesh.material.depthWrite = alpha >= 1;
    }
    this.scheduler?.invalidate();
  }
  pick(event) {
    if (this.disposed || this.quiz) return;
    const rect = this.canvas.getBoundingClientRect();
    if (rect.width <= 0 || rect.height <= 0) return;
    this.raycaster.setFromCamera(new THREE.Vector2((event.clientX - rect.left) / rect.width * 2 - 1,
      -(event.clientY - rect.top) / rect.height * 2 + 1), this.camera);
    const hit = this.raycaster.intersectObjects(this.meshes().filter(m => m.visible), false)[0];
    if (hit && this.state.select(hit.object.userData.structureId)) {
      this.updateVisibility();
      this.emit('selected', { id: this.state.selected });
    }
  }
  box(id = null) {
    const box = new THREE.Box3();
    this.scene.updateMatrixWorld(true);
    for (const mesh of this.meshes()) if (mesh.visible && (!id || mesh.userData.structureId === id)) box.expandByObject(mesh);
    return box;
  }
  frame(id = null, direction = null) {
    if (this.disposed) return;
    const box = this.box(id);
    if (box.isEmpty() || ![...box.min, ...box.max].every(Number.isFinite)) return;
    const center = box.getCenter(new THREE.Vector3());
    const size = box.getSize(new THREE.Vector3());
    const distance = Math.max(size.y, size.x / this.camera.aspect, size.z) / (2 * Math.tan(THREE.MathUtils.degToRad(20))) * 1.25;
    const offset = direction ?? this.camera.position.clone().sub(this.controls.target).normalize();
    this.controls.target.copy(center);
    this.camera.position.copy(center).addScaledVector(offset, Math.max(distance, .02));
    this.controls.update();
    this.scheduler?.invalidate();
  }
  focus(id) { this.frame(id); }
  command(type, payload = {}) {
    if (this.disposed || !validPayload(type, payload)) return false;
    if (type === 'configure') return this.configure(payload);
    if (type === 'dispose') return this.dispose();
    if (type === 'quality') {
      this.qualityProfile = payload.profile;
      this.resize();
      return true;
    }
    if (type === 'select' && !this.state.reveal(payload.id)) return false;
    if (type === 'focus') {
      if (!this.state.visibleIds().includes(payload.id)) return false;
      this.focus(payload.id);
    }
    if (type === 'hide' && !this.state.hide(payload.id)) return false;
    if (type === 'isolate') {
      if (!this.state.isolate(payload.id)) return false;
      this.updateVisibility(); this.focus(payload.id);
    }
    if (type === 'systemLayer' && !this.state.systemLayer(payload)) return false;
    if (type === 'compare' && !this.state.compare(payload.ids)) return false;
    if (type === 'restore') { this.state.restore(); this.alpha = 1; }
    if (type === 'opacity') this.alpha = payload.value;
    if (type === 'camera') {
      // Reference axes are +X patient-left, +Y superior, +Z anterior.
      const directions = { front: [0, 0, 1], back: [0, 0, -1], left: [1, 0, 0], right: [-1, 0, 0], top: [0, 1, .001] };
      if (directions[payload.view]) this.frame(null, new THREE.Vector3(...directions[payload.view]).normalize());
      if (payload.view === 'reset') this.frame(null, new THREE.Vector3(0, 0, 1));
    }
    this.updateVisibility();
    return true;
  }
  release(root) {
    root.removeFromParent();
    const geometries = new Set(), materials = new Set(), textures = new Set();
    root.traverse(o => {
      if (!o.isMesh) return;
      geometries.add(o.geometry);
      for (const m of Array.isArray(o.material) ? o.material : [o.material]) {
        materials.add(m);
        for (const value of Object.values(m)) if (value?.isTexture) textures.add(value);
      }
    });
    for (const resource of [...geometries, ...materials, ...textures]) resource.dispose();
  }
  dispose() {
    if (this.disposed) return;
    this.disposed = true;
    this.state.generation++;
    this.scheduler?.dispose();
    this.resizeObserver.disconnect();
    this.controls.removeEventListener?.('change', this.onControlsChange);
    this.controls.removeEventListener?.('start', this.onControlsStart);
    this.controls.removeEventListener?.('end', this.onControlsEnd);
    this.controls.dispose();
    for (const root of this.loaded.values()) this.release(root);
    this.loaded.clear();
    this.canvas.removeEventListener('pointerdown', this.onDown);
    this.canvas.removeEventListener('pointerup', this.onUp);
    this.canvas.removeEventListener('pointercancel', this.onCancel);
    this.canvas.removeEventListener('pointermove', this.onMove);
    this.canvas.removeEventListener('webglcontextlost', this.onContextLost);
    this.canvas.removeEventListener('webglcontextrestored', this.onContextRestored);
    this.document?.removeEventListener('visibilitychange', this.onVisibility);
    this.renderer.dispose();
  }
}
