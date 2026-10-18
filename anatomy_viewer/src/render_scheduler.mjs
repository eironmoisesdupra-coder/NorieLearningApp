// A single RAF chain while dirty, interacting or damping. No idle polling.
export class FrameScheduler {
  constructor({ update, render, request = callback => globalThis.requestAnimationFrame(callback),
    cancel = id => globalThis.cancelAnimationFrame(id) }) {
    Object.assign(this, { update, render, request, cancel });
    this.pending = null;
    this.dirty = false;
    this.active = false;
    this.visible = true;
    this.paused = false;
    this.disposed = false;
    this.running = false;
  }
  invalidate() {
    if (this.disposed) return;
    this.dirty = true;
    this.schedule();
  }
  schedule() {
    if (this.disposed || !this.visible || this.paused || this.running || this.pending !== null) return;
    this.pending = this.request(() => this.frame());
  }
  frame() {
    this.pending = null;
    if (this.disposed || !this.visible || this.paused) return;
    this.running = true;
    try {
      const changed = this.update() === true;
      // OrbitControls.update emits change synchronously. This frame already
      // paints that change; retaining its invalidation would never go idle.
      this.dirty = false;
      this.render();
      this.dirty ||= changed;
    } finally { this.running = false; }
    if (this.dirty || this.active) this.schedule();
  }
  setActive(active) {
    if (this.disposed) return;
    this.active = active;
    this.invalidate();
  }
  setVisible(visible) {
    if (this.disposed) return;
    this.visible = visible;
    this.refresh();
  }
  setPaused(paused) {
    if (this.disposed) return;
    this.paused = paused;
    this.refresh();
  }
  refresh() {
    if (!this.visible || this.paused) {
      if (this.pending !== null) this.cancel(this.pending);
      this.pending = null;
    } else this.invalidate();
  }
  dispose() {
    if (this.disposed) return;
    this.disposed = true;
    if (this.pending !== null) this.cancel(this.pending);
    this.pending = null;
  }
}
