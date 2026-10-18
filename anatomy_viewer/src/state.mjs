const record = value => value !== null && typeof value === 'object' && !Array.isArray(value) &&
  [Object.prototype, null].includes(Object.getPrototypeOf(value));
const identifier = value => typeof value === 'string' && value.length > 0 && value.length <= 256 &&
  value.trim() === value && !/[\u0000-\u001f\u007f]/.test(value);
const only = (value, keys) => Object.keys(value).every(key => keys.includes(key));
const opacity = (value, minimum = 0) => Number.isFinite(value) && value >= minimum && value <= 1;
const cameraViews = new Set(['front', 'back', 'left', 'right', 'top', 'reset']);

export function validPayload(type, payload = {}) {
  if (!record(payload)) return false;
  switch (type) {
    case 'configure':
      return only(payload, ['reference', 'systems', 'target', 'quiz', 'requestId']) && identifier(payload.reference) &&
        Array.isArray(payload.systems) && payload.systems.length <= 64 && payload.systems.every(identifier) &&
        new Set(payload.systems).size === payload.systems.length &&
        (payload.target === undefined || payload.target === null || identifier(payload.target)) &&
        (payload.quiz === undefined || typeof payload.quiz === 'boolean') &&
        (payload.requestId === undefined || (Number.isSafeInteger(payload.requestId) && payload.requestId >= 0));
    case 'select': case 'focus': case 'hide': case 'isolate':
      return only(payload, ['id']) && identifier(payload.id);
    case 'systemLayer':
      return only(payload, ['system', 'visible', 'opacity']) && identifier(payload.system) &&
        (payload.visible !== undefined || payload.opacity !== undefined) &&
        (payload.visible === undefined || typeof payload.visible === 'boolean') &&
        (payload.opacity === undefined || opacity(payload.opacity));
    case 'compare':
      return only(payload, ['ids']) && Array.isArray(payload.ids) &&
        (payload.ids.length === 0 || (payload.ids.length === 2 && payload.ids.every(identifier) && payload.ids[0] !== payload.ids[1]));
    case 'opacity': return only(payload, ['value']) && opacity(payload.value, .15);
    case 'camera': return only(payload, ['view']) && cameraViews.has(payload.view);
    case 'quality': return only(payload, ['profile']) && ['low', 'balanced', 'high'].includes(payload.profile);
    case 'restore': case 'dispose': return Object.keys(payload).length === 0;
    default: return false;
  }
}

export function validCommand(value, session) {
  return record(value) && only(value, ['version', 'session', 'type', 'payload']) && value.version === 1 &&
    value.session === session && validPayload(value.type, value.payload);
}

export function isSelectionGesture(start, end) {
  return start?.pointers === 1 && !start.moved && Math.hypot(end.x - start.x, end.y - start.y) <= 6;
}

export class AtlasState {
  constructor(structures) {
    this.structures = structures;
    this.entries = new Map(structures.map(s => [s.id, s]));
    this.generation = 0;
    this.reference = '';
    this.systems = new Set();
    this.hidden = new Set();
    this.layerOverrides = new Map();
    this.compareIds = [];
    this.isolated = null;
    this.selected = null;
  }
  configure(reference, systems) {
    this.reference = reference;
    this.systems = new Set(systems);
    this.restore();
    this.selected = null;
    return ++this.generation;
  }
  accepts(generation) { return generation === this.generation; }
  eligible() {
    return this.structures.filter(s => s.reference === this.reference && s.systems.some(x => this.systems.has(x)));
  }
  visibleIds() {
    return this.eligible().filter(s => !this.hidden.has(s.id) && (!this.isolated || this.isolated === s.id) &&
      this.effectiveOpacity(s.id) > 0).map(s => s.id);
  }
  effectiveOpacity(id, global = 1) {
    const structure = this.entries.get(id);
    if (!structure || structure.reference !== this.reference || !opacity(global)) return 0;
    // Shared structures stay visible through any visible configured membership.
    const layers = structure.systems.filter(system => this.systems.has(system) && this.layerOverrides.get(system)?.visible !== false);
    return global * Math.max(0, ...layers.map(system => this.layerOverrides.get(system)?.opacity ?? 1));
  }
  systemLayer(payload) {
    if (!validPayload('systemLayer', payload) || !this.systems.has(payload.system) ||
        !this.eligible().some(s => s.systems.includes(payload.system))) return false;
    this.layerOverrides.set(payload.system, { ...this.layerOverrides.get(payload.system), ...payload });
    this.reconcileVisibility();
    return true;
  }
  compare(ids) {
    if (!validPayload('compare', { ids })) return false;
    const visible = new Set(this.visibleIds());
    if (!ids.every(id => visible.has(id))) return false;
    this.compareIds = [...ids];
    return true;
  }
  reconcileVisibility() {
    const visible = new Set(this.visibleIds());
    if (!visible.has(this.selected)) this.selected = null;
    if (!this.compareIds.every(id => visible.has(id))) this.compareIds = [];
  }
  select(id) {
    if (!this.visibleIds().includes(id)) return false;
    this.selected = id;
    return true;
  }
  reveal(id) {
    if (!this.eligible().some(s => s.id === id) || this.effectiveOpacity(id) <= 0) return false;
    this.hidden.delete(id);
    this.isolated = null;
    this.selected = id;
    return true;
  }
  hide(id) {
    if (!this.eligible().some(s => s.id === id)) return false;
    this.hidden.add(id);
    this.reconcileVisibility();
    return true;
  }
  isolate(id) {
    if (this.eligible().some(s => s.id === id) && this.effectiveOpacity(id) > 0) {
      this.hidden.delete(id);
      this.isolated = id;
      this.selected = id;
      this.reconcileVisibility();
      return true;
    }
    return false;
  }
  restore() {
    this.hidden.clear();
    this.isolated = null;
    this.layerOverrides.clear();
    this.compareIds = [];
  }
}
