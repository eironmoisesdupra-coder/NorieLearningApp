import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import { MeshoptDecoder } from 'meshoptimizer';
import { AtlasState, isSelectionGesture } from './state.mjs';

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
    this.alpha = 1;
    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color('#0b1629');
    this.camera = new THREE.PerspectiveCamera(40, 1, .001, 100);
    this.camera.position.set(0, 1, 3);
    this.renderer = new THREE.WebGLRenderer({ canvas, antialias: true, powerPreference: 'high-performance' });
    this.renderer.setPixelRatio(Math.min(devicePixelRatio, 2));
    this.renderer.outputColorSpace = THREE.SRGBColorSpace;
    this.controls = new OrbitControls(this.camera, canvas);
    this.controls.enableDamping = true;
    this.controls.target.set(0, .9, 0);
    this.controls.minDistance = .005;
    this.controls.maxDistance = 8;
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
      if (this.pointerCount === 1) this.gesture = { x: event.clientX, y: event.clientY, pointers: 1 };
      else if (this.gesture) this.gesture.pointers = this.pointerCount;
    };
    this.onUp = event => {
      this.pointerCount = Math.max(0, this.pointerCount - 1);
      if (this.pointerCount === 0 && isSelectionGesture(this.gesture, { x: event.clientX, y: event.clientY })) this.pick(event);
      if (this.pointerCount === 0) this.gesture = null;
    };
    this.onCancel = () => { this.pointerCount = 0; this.gesture = null; };
    this.onMove = event => {
      if (this.gesture && Math.hypot(event.clientX - this.gesture.x, event.clientY - this.gesture.y) > 6) this.gesture.moved = true;
    };
    canvas.addEventListener('pointerdown', this.onDown);
    canvas.addEventListener('pointerup', this.onUp);
    canvas.addEventListener('pointercancel', this.onCancel);
    canvas.addEventListener('pointermove', this.onMove);
    this.resizeObserver = new ResizeObserver(() => this.resize());
    this.resizeObserver.observe(canvas);
    this.resize();
    this.renderer.setAnimationLoop(() => {
      this.controls.update();
      this.renderer.render(this.scene, this.camera);
    });
  }

  resize() {
    const width = Math.max(1, this.canvas.clientWidth), height = Math.max(1, this.canvas.clientHeight);
    this.camera.aspect = width / height;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(width, height, false);
  }

  async configure({ reference, systems, target = null, quiz = false, requestId = 0 }) {
    if (!this.catalog.references.some(r => r.id === reference) || !Array.isArray(systems)) throw Error('Invalid atlas selection');
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
      }
      this.emit('loading', { requestId, completed: ++completed, total: wanted.size });
    }
    if (!this.state.accepts(generation)) return;
    this.updateVisibility();
    if (target && this.state.select(target)) {
      if (this.quiz) this.state.isolate(target);
      this.updateVisibility(); this.focus(target);
    }
    else if (this.state.selected) this.focus(this.state.selected);
    else this.frame();
    this.emit('loaded', { requestId, count: this.state.visibleIds().length });
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
      const selected = this.state.selected === id;
      mesh.material.color.copy(selected ? new THREE.Color('#42e8e0') : mesh.userData.baseColor);
      mesh.material.emissive.set(selected ? '#104d53' : '#000000');
      mesh.material.transparent = this.alpha < 1;
      mesh.material.opacity = this.alpha;
      mesh.material.depthWrite = this.alpha >= 1;
    }
  }
  pick(event) {
    if (this.quiz) return;
    const rect = this.canvas.getBoundingClientRect();
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
    const box = this.box(id);
    if (box.isEmpty()) return;
    const center = box.getCenter(new THREE.Vector3());
    const size = box.getSize(new THREE.Vector3());
    const distance = Math.max(size.y, size.x / this.camera.aspect, size.z) / (2 * Math.tan(THREE.MathUtils.degToRad(20))) * 1.25;
    const offset = direction ?? this.camera.position.clone().sub(this.controls.target).normalize();
    this.controls.target.copy(center);
    this.camera.position.copy(center).addScaledVector(offset, Math.max(distance, .02));
    this.controls.update();
  }
  focus(id) { this.frame(id); }
  command(type, payload = {}) {
    if (this.disposed) return;
    if (type === 'configure') return this.configure(payload);
    if (type === 'dispose') return this.dispose();
    if (type === 'select') this.state.reveal(payload.id);
    if (type === 'focus') this.focus(payload.id);
    if (type === 'hide') this.state.hide(payload.id);
    if (type === 'isolate') { this.state.isolate(payload.id); this.updateVisibility(); this.focus(payload.id); }
    if (type === 'restore') { this.state.restore(); this.alpha = 1; }
    if (type === 'opacity' && Number.isFinite(payload.value)) this.alpha = THREE.MathUtils.clamp(payload.value, .15, 1);
    if (type === 'camera') {
      // Reference axes are +X patient-left, +Y superior, +Z anterior.
      const directions = { front: [0, 0, 1], back: [0, 0, -1], left: [1, 0, 0], right: [-1, 0, 0], top: [0, 1, .001] };
      if (directions[payload.view]) this.frame(null, new THREE.Vector3(...directions[payload.view]).normalize());
      if (payload.view === 'reset') this.frame(null, new THREE.Vector3(0, 0, 1));
    }
    this.updateVisibility();
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
    this.disposed = true;
    this.state.generation++;
    this.renderer.setAnimationLoop(null);
    this.resizeObserver.disconnect();
    this.controls.dispose();
    for (const root of this.loaded.values()) this.release(root);
    this.loaded.clear();
    this.canvas.removeEventListener('pointerdown', this.onDown);
    this.canvas.removeEventListener('pointerup', this.onUp);
    this.canvas.removeEventListener('pointercancel', this.onCancel);
    this.canvas.removeEventListener('pointermove', this.onMove);
    this.renderer.dispose();
  }
}
