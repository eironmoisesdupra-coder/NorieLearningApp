// Exact reviewed node names from the pinned Z-Anatomy visceral export.
// Never copy this mixed-license document wholesale: kidney geometry is excluded.
export const glandNames = Object.freeze([
  'Adenohypophysis', 'Neurohypophysis', 'Pineal gland', 'Thyroid gland',
  'Inferior parathyroid gland.l', 'Inferior parathyroid gland.r',
  'Superior parathyroid gland.l', 'Superior parathyroid gland.r',
  'Suprarenal gland.l', 'Suprarenal gland.r', 'Pancreas',
]);

export function selectGlands(nodes) {
  const selected = nodes.filter(n => n.getMesh() && glandNames.includes(n.getExtras().za_name));
  for (const name of glandNames) {
    if (selected.filter(n => n.getExtras().za_name === name).length !== 1) {
      throw new Error(`Reviewed gland missing or duplicated: ${name}`);
    }
  }
  return selected;
}

// Source labels, not ancestor membership: vessels, ducts and supporting
// ligaments must not become endocrine organs just because they serve one.
export function isEndocrineOrgan(label) {
  if (/duct|ligament|arter|vein|nerve|ampulla/i.test(label)) return false;
  return /\b(pineal|pituitary|adrenal|suprarenal|parathyroid|thyroid|thymus|pancreas|ovary|testis)\b/i.test(label);
}
