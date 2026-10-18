// These are CPU-side JS durations and WebGL resource counts, not GPU timings
// or memory bytes. Keep histories bounded even over a long-lived atlas view.
export class RenderMetrics {
  constructor(limit = 120) {
    this.limit = Math.max(1, Math.min(600, Math.floor(limit) || 120));
    this.renderedFrames = 0;
    this.frameJsMs = [];
    this.loadMs = [];
    this.drawCalls = this.triangles = this.geometries = this.textures = 0;
  }
  record(history, milliseconds) {
    if (!Number.isFinite(milliseconds) || milliseconds < 0) return;
    history.push(milliseconds);
    if (history.length > this.limit) history.shift();
  }
  frame(milliseconds, info) {
    this.renderedFrames++;
    this.record(this.frameJsMs, milliseconds);
    this.drawCalls = info.render.calls;
    this.triangles = info.render.triangles;
    this.geometries = info.memory.geometries;
    this.textures = info.memory.textures;
  }
  load(milliseconds) { this.record(this.loadMs, milliseconds); }
  snapshot() {
    return { renderedFrames: this.renderedFrames, frameJsMs: [...this.frameJsMs], loadMs: [...this.loadMs],
      drawCalls: this.drawCalls, triangles: this.triangles, geometries: this.geometries, textures: this.textures,
      peakMemoryBytes: null, memoryStatus: 'unavailable: WebGL resource counts do not measure total CPU/GPU memory' };
  }
}
