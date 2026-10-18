# Anatomy renderer measurement

Same offline Edge fixture, 800 x 800, male skeletal + muscular, 640 selectable parts, two loaded assets, DPR 1. Raw before/after reports are adjacent JSON files. During two idle seconds, rendered frames fell from 106 to 1; after a named-camera action, 128 to 1. Load time was essentially unchanged (1010.2 vs 1011.3 ms); geometry and draw calls did not change (640 calls, 2,658,030 triangles).

This demonstrates reduced idle rendering, not a general FPS or loading-speed improvement. The after-run cold idle render took 234.9 ms; its camera-action render took 14.9 ms. Browser metrics are bounded CPU-side observations, not GPU-completion, peak-memory or battery measurements. Physical Android/Windows touch, lifecycle and performance validation remains pending.

Independent Node tests and real offline browser checks cover picking after idle, orbit/damping, visibility suspension, quality/resize invalidation, actual WebGL context loss/recovery, load retry and repeated disposal. Quality caps pixel ratio at 1/1.5/2 for Low/Balanced/High and keeps every model part available.
