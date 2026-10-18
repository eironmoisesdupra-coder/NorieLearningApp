# Phase C — #31 Advanced 3D Interaction

- Toggle visibility and opacity by anatomical system, with unambiguous isolate/hide/reset state. Maintain global opacity behavior for compatibility.
- Compare structures in the same reference: side-by-side detail and/or interactive before/after toggles; never overlay separate references in unrelated coordinate frames.
- Saved structure bookmarks and deterministic camera presets scoped to learner and reference; provide delete/reset/export policy.
- Selection outlines / labels must remain legible on mobile without obscuring scene.
- Optional layer ordering, focus and reversible history where efficient.
- Measurement tool only after verifying scene scale/unit metadata; label uncalibrated references as unsuitable for measurement, never show invented cm/mm accuracy.
- Renderer bridge validates command payloads, handles delayed async requests, listener teardown and disposed scenes, and avoids leaking WebGL resources.
- Tests: switching refs, pan/zoom/touch/pick, isolation state across changes, background/foreground, screen rotation, focus and asset caching; physical test required before device certification.
