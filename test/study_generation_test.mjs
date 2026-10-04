import test from 'node:test';
import assert from 'node:assert/strict';
import { normalizeQuestions } from '../supabase/functions/generate-study-set/questions.mjs';

const sourceText = 'Water freezes into ice. Heating ice melts it into water.';
const question = {
  kind: 'single_select', prompt: 'What does water freeze into?',
  options: ['Ice', 'Sand', 'Wood', 'Metal'], correct_values: ['Ice'],
  explanation: 'Water becomes ice when it freezes.', source_excerpt: 'Water freezes into ice.',
};
const settings = { count: 5, mode: 'mixed', sourceText };

test('valid choice survives without ordered_items', () => {
  const result = normalizeQuestions([question], settings);
  assert.equal(result.length, 1);
  assert.deepEqual(result[0].ordered_items, []);
});
test('rejects malformed answers, duplicates, unsupported excerpts and wrong modes', () => {
  assert.equal(normalizeQuestions([question, question], settings).length, 1);
  for (const patch of [
    { correct_values: ['Rock'] }, { options: ['Ice', 'Ice', 'Wood', 'Metal'] },
    { explanation: '' }, { source_excerpt: 'Ice is blue.' }, { correct_values: ['Ice', 'Wood'] },
  ]) assert.equal(normalizeQuestions([{ ...question, ...patch }], settings).length, 0);
  assert.equal(normalizeQuestions([question], { ...settings, mode: 'flashcards' }).length, 0);
});
test('ordering requires a valid sequence matching its answer key', () => {
  const ordered = { ...question, kind: 'ordering', options: [],
    correct_values: ['Freeze', 'Heat', 'Melt'], ordered_items: ['Freeze', 'Heat', 'Melt'] };
  assert.equal(normalizeQuestions([ordered], settings).length, 1);
  assert.equal(normalizeQuestions([{ ...ordered, ordered_items: undefined }], settings).length, 0);
  assert.equal(normalizeQuestions([{ ...ordered, correct_values: ['Melt', 'Heat', 'Freeze'] }], settings).length, 0);
});
test('flashcards retain source evidence and count limits', () => {
  const card = { ...question, kind: 'flashcard', options: [] };
  assert.equal(normalizeQuestions([card], { ...settings, mode: 'flashcards' }).length, 1);
  assert.equal(normalizeQuestions([card, { ...card, prompt: 'Another question?' }], { ...settings, count: 1 }).length, 1);
});