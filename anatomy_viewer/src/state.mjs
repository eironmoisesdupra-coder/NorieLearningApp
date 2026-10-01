const commands = new Set(['configure', 'select', 'focus', 'hide', 'isolate', 'restore', 'opacity', 'camera', 'dispose']);

export function validCommand(value, session) {
  return value !== null && typeof value === 'object' && value.version === 1 &&
    value.session === session && commands.has(value.type);
}

export function isSelectionGesture(start, end) {
  return start?.pointers === 1 && !start.moved && Math.hypot(end.x - start.x, end.y - start.y) <= 6;
}

export class AtlasState {
  constructor(structures) {
    this.structures = structures;
    this.generation = 0;
    this.reference = '';
    this.systems = new Set();
    this.hidden = new Set();
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
    return this.eligible().filter(s => !this.hidden.has(s.id) && (!this.isolated || this.isolated === s.id)).map(s => s.id);
  }
  select(id) {
    if (!this.visibleIds().includes(id)) return false;
    this.selected = id;
    return true;
  }
  reveal(id) {
    if (!this.eligible().some(s => s.id === id)) return false;
    this.hidden.delete(id);
    this.isolated = null;
    this.selected = id;
    return true;
  }
  hide(id) {
    this.hidden.add(id);
    if (this.selected === id) this.selected = null;
  }
  isolate(id) {
    if (this.eligible().some(s => s.id === id)) {
      this.hidden.delete(id);
      this.isolated = id;
      this.selected = id;
    }
  }
  restore() { this.hidden.clear(); this.isolated = null; }
}
