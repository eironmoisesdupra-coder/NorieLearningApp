import fs from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import { Document, NodeIO } from '@gltf-transform/core';
import { ALL_EXTENSIONS } from '@gltf-transform/extensions';
import { copyToDocument, getBounds, dedup, prune, unpartition, weld, meshopt, simplify } from '@gltf-transform/functions';
import { MeshoptEncoder, MeshoptDecoder, MeshoptSimplifier } from 'meshoptimizer';
import draco3d from 'draco3d';
import { VTKLoader } from 'three/addons/loaders/VTKLoader.js';
import { selectGlands, isEndocrineOrgan } from './source-selection.mjs';

const root = path.resolve(import.meta.dirname, '..');
const output = path.join(root, 'assets/anatomy');
const raw = path.join(root, 'build/anatomy-converted');
await fs.mkdir(output, { recursive: true });
await Promise.all([MeshoptEncoder.ready, MeshoptDecoder.ready, MeshoptSimplifier.ready]);
const io = new NodeIO().registerExtensions(ALL_EXTENSIONS).registerDependencies({
  'meshopt.encoder': MeshoptEncoder, 'meshopt.decoder': MeshoptDecoder,
  'draco3d.decoder': await draco3d.createDecoderModule(),
});
const catalog = {
  schemaVersion: 1,
  references: [
    { id: 'joints', label: 'Joints & ligaments · detail', description: 'Z-Anatomy joint capsules, ligaments, discs and matching optional bone context in source coordinates.' },
    { id: 'glands', label: 'Endocrine glands · detail', description: 'Thyroid, parathyroids, pituitary lobes, pineal, adrenals and pancreas. Gonads remain in the male and female body references.' },
    { id: 'male', label: 'Adult male · BodyParts3D', description: 'Full-body reference with separately modeled systems.' },
    { id: 'female', label: 'Adult female · Human Reference Atlas', description: 'Female organ reference including reproductive anatomy. Some whole-body systems have partial coverage.' },
    { id: 'lymphatic', label: 'Lymph nodes & organs · detail', description: 'Z-Anatomy lymph nodes and organs in their own source reference coordinates; lymph vessels are not included.' },
    { id: 'ear', label: 'Inner & middle ear · detail', description: 'SPL high-resolution ear reference, including the labyrinth, ossicles, membrane, nerves and vessels.' },
  ],
  assets: [], structures: JSON.parse(await fs.readFile(path.join(raw, 'body-catalog.json'), 'utf8')),
};

async function writeAsset(id, doc, reduce = false) {
  const entries = catalog.structures.filter(s => s.asset === id);
  const byName = new Map(entries.flatMap(s => s.meshes.map(name => [name, s.id])));
  for (const node of doc.getRoot().listNodes()) {
    if (byName.has(node.getName())) node.setExtras({ atlasStructure: byName.get(node.getName()) });
  }
  await doc.transform(dedup(), weld());
  if (reduce) await doc.transform(simplify({ simplifier: MeshoptSimplifier, ratio: .5, error: .0005 }));
  await doc.transform(prune(), unpartition(), meshopt({ encoder: MeshoptEncoder, level: 'high' }));
  const present = new Set(doc.getRoot().listNodes().filter(n => n.getMesh()?.listPrimitives().length)
    .map(n => n.getExtras().atlasStructure));
  catalog.structures = catalog.structures.filter(s => s.asset !== id || present.has(s.id));
  const bytes = await io.writeBinary(doc);
  await fs.writeFile(path.join(output, `${id}.glb`), bytes);
  catalog.assets.push({ id, file: `${id}.glb`, bytes: bytes.byteLength,
    sha256: crypto.createHash('sha256').update(bytes).digest('hex') });
  console.log(id, `${(bytes.byteLength / 1e6).toFixed(2)} MB`);
}

for (const file of (await fs.readdir(raw)).filter(x => x.endsWith('.glb')).sort()) {
  await writeAsset(file.slice(0, -4), await io.read(path.join(raw, file)));
}

const female = await io.read(path.join(root, 'build/anatomy-research/hra-female.glb'));
const groups = new Map();
const systemNames = {
  integumentary: 'integumentary', nervous: 'nervous', muscular: 'muscular',
  reproductive: 'reproductive', digestive: 'digestive', urinary: 'urinary',
  circulatory: 'cardiovascular', respiratory: 'respiratory', lymphatic: 'lymphatic', skeletal: 'skeletal',
};
function systemFor(node, parents) {
  const names = [...parents, node.getName()].join(' ').toLowerCase();
  const name = node.getName().toLowerCase();
  if (/eye|eyeball|retina|cornea|lens|iris/.test(names)) return 'sensory';
  if (/blood_vasculature/.test(names)) {
    if (/vein|venous|vena|sinus/.test(names)) return 'venous';
    if (/arter|aorta/.test(names)) return 'arterial';
    return null; // Do not guess arterial/venous identity for unlabeled branches.
  }
  if (/intervertebral|cartilage|meniscus|ligament.*knee/.test(names)) return 'articular';
  for (const [term, id] of Object.entries(systemNames)) {
    if (names.includes(`${term}_system`)) return id;
  }
  return null;
}
function walk(node, parents = []) {
  if ([...parents, node.getName()].some(name => /placenta|umbilical/i.test(name))) return;
  if (node.getMesh()) {
    const system = systemFor(node, parents);
    if (system) {
      if (!groups.has(system)) groups.set(system, []);
      groups.get(system).push(node);
    }
  }
  for (const child of node.listChildren()) walk(child, [...parents, node.getName()]);
}
for (const scene of female.getRoot().listScenes()) for (const node of scene.listChildren()) walk(node);
for (const [system, nodes] of groups) {
  const doc = new Document();
  const scene = doc.createScene();
  const meshes = [...new Set(nodes.map(n => n.getMesh()))];
  const copied = copyToDocument(doc, female, meshes);
  for (const node of nodes) {
    const name = node.getName();
    const target = doc.createNode(name).setMesh(copied.get(node.getMesh())).setMatrix(node.getWorldMatrix());
    scene.addChild(target);
    const bounds = getBounds(target);
    const extras = node.getExtras();
    const label = typeof extras.label === 'string' && extras.label !== '-' ? extras.label : name.replace(/^VH_F_/, '').replaceAll('_', ' ');
    const systems = [system];
    if (isEndocrineOrgan(label) && system !== 'endocrine') systems.push('endocrine');
    catalog.structures.push({ id: `hra-${name}`, name: label, ontology: extras.ontologyid ?? '',
      systems, reference: 'female', asset: `female-${system}`, meshes: [name],
      bounds: [bounds.min, bounds.max], source: 'hra-female' });
  }
  await writeAsset(`female-${system}`, doc, true);
}
const lymphSource = await io.read(path.join(root, 'build/anatomy-research/z-lymphatic.glb'));
const lymph = new Document();
const lymphScene = lymph.createScene();
const lymphNodes = lymphSource.getRoot().listNodes().filter(n => n.getMesh());
const lymphMeshes = copyToDocument(lymph, lymphSource, [...new Set(lymphNodes.map(n => n.getMesh()))]);
for (const [index, node] of lymphNodes.entries()) {
  const meshName = `lymph-${index}`;
  const target = lymph.createNode(meshName).setMesh(lymphMeshes.get(node.getMesh())).setMatrix(node.getWorldMatrix());
  lymphScene.addChild(target);
  const bounds = getBounds(target);
  const original = node.getExtras().za_name || node.getName();
  catalog.structures.push({ id: `za-lymph-${index}`, name: original.replace(/\.l\b/g, ' (left)').replace(/\.r\b/g, ' (right)'),
    ontology: '', systems: ['lymphatic'], reference: 'lymphatic', asset: 'detail-lymphatic',
    meshes: [meshName], bounds: [bounds.min, bounds.max], source: 'z-lymphatic' });
}
for (const extension of lymph.getRoot().listExtensionsUsed()) {
  if (extension.extensionName === 'KHR_draco_mesh_compression') extension.dispose();
}
await writeAsset('detail-lymphatic', lymph);

// Copy selected meshes into a fresh document, never the full visceral scene.
// Flatten world transforms exactly as in the other detail references.
async function addZDetail(sourceId, asset, reference, system, select = nodes => nodes) {
  const source = await io.read(path.join(root, `build/anatomy-research/${sourceId}.glb`));
  const nodes = select(source.getRoot().listNodes().filter(n => n.getMesh()));
  const doc = new Document(), scene = doc.createScene();
  const copied = copyToDocument(doc, source, [...new Set(nodes.map(n => n.getMesh()))]);
  for (const [index, node] of nodes.entries()) {
    const original = node.getExtras().za_name || node.getName();
    const meshName = `${asset}-${index}`;
    const target = doc.createNode(meshName).setMesh(copied.get(node.getMesh())).setMatrix(node.getWorldMatrix());
    scene.addChild(target);
    const bounds = getBounds(target);
    catalog.structures.push({ id: `za-${asset}-${index}`,
      name: original.replace(/\.l\b/g, ' (left)').replace(/\.r\b/g, ' (right)'),
      ontology: '', systems: [system], reference, asset, meshes: [meshName],
      bounds: [bounds.min, bounds.max], source: sourceId, sourceName: original });
  }
  for (const extension of doc.getRoot().listExtensionsUsed()) {
    if (extension.extensionName === 'KHR_draco_mesh_compression') extension.dispose();
  }
  await writeAsset(asset, doc);
}
await addZDetail('z-joints', 'detail-joints', 'joints', 'articular');
await addZDetail('z-skeletal', 'detail-joint-bones', 'joints', 'skeletal');
await addZDetail('z-visceral', 'detail-glands', 'glands', 'endocrine', selectGlands);

const earData = JSON.parse(await fs.readFile(path.join(root, 'build/anatomy-research/ear-atlas.json'), 'utf8'));
const earSources = new Map(earData.filter(x => x['@type'] === 'DataSource').map(x => [x['@id'], x]));
const ear = new Document(), earScene = ear.createScene(), earBuffer = ear.createBuffer();
for (const item of earData.filter(x => x['@type'] === 'Structure')) {
  const selector = item.sourceSelector?.find(x => x['@type'].includes('GeometrySelector'));
  const source = earSources.get(selector?.dataSource);
  if (!source?.source.endsWith('.vtk')) continue;
  const bytes = await fs.readFile(path.join(root, 'build/anatomy-research', 'ear-' + path.basename(source.source)));
  const geometry = new VTKLoader().parse(bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength));
  // Source Slicer RAS millimeters -> atlas [-R, S, A] meters/Y-up,
  // with anterior facing the renderer's +Z front camera. Preserve a separate
  // reference scene rather than pretending it is registered to either body.
  geometry.rotateZ(Math.PI).rotateX(-Math.PI / 2);
  geometry.scale(.001, .001, .001);
  geometry.computeVertexNormals();
  const name = item['@id'].slice(1);
  const position = ear.createAccessor().setType('VEC3').setArray(geometry.attributes.position.array).setBuffer(earBuffer);
  const normal = ear.createAccessor().setType('VEC3').setArray(geometry.attributes.normal.array).setBuffer(earBuffer);
  const colors = (item.renderOption?.color?.match(/\d+/g) ?? ['180', '190', '220']).map(v => Number(v) / 255);
  const material = ear.createMaterial().setBaseColorFactor([...colors, 1]).setMetallicFactor(0).setRoughnessFactor(.8).setDoubleSided(true);
  const primitive = ear.createPrimitive().setAttribute('POSITION', position).setAttribute('NORMAL', normal).setMaterial(material);
  if (geometry.index) primitive.setIndices(ear.createAccessor().setType('SCALAR').setArray(geometry.index.array).setBuffer(earBuffer));
  const node = ear.createNode(name).setMesh(ear.createMesh(name).addPrimitive(primitive));
  earScene.addChild(node);
  const bounds = getBounds(node);
  catalog.structures.push({ id: `spl-ear-${name}`, name: item.annotation.name, ontology: '', systems: ['sensory'],
    reference: 'ear', asset: 'detail-ear', meshes: [name], bounds: [bounds.min, bounds.max], source: 'spl-ear' });
  geometry.dispose();
}
await writeAsset('detail-ear', ear);
await fs.writeFile(path.join(output, 'atlas-catalog.json'), JSON.stringify(catalog));
console.log('Catalog:', catalog.structures.length, 'structures');
