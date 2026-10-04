const kinds = new Set(['single_select', 'true_false', 'identification', 'matching', 'drag_drop', 'ordering', 'fill_blank', 'flashcard']);
const modeKinds = {
  multiple_choice: 'single_select', true_false: 'true_false',
  identification: 'identification', matching: 'matching', drag_drop: 'drag_drop',
  ordering: 'ordering', fill_blank: 'fill_blank', flashcards: 'flashcard',
};
const strings = value => Array.isArray(value)
  ? value.filter(item => typeof item === 'string').map(item => item.trim()).filter(Boolean)
  : [];
const normalize = value => value.toLowerCase().replace(/\s+/g, ' ').trim();

export function normalizeQuestions(input, { count, mode, sourceText = '', topicTag = '' }) {
  if (!Array.isArray(input)) return [];
  const questions = [];
  const seen = new Set();
  for (const candidate of input) {
    if (!candidate || typeof candidate !== 'object') continue;
    const kind = candidate.kind;
    const prompt = typeof candidate.prompt === 'string' ? candidate.prompt.trim() : '';
    const explanation = typeof candidate.explanation === 'string' ? candidate.explanation.trim() : '';
    const excerpt = typeof candidate.source_excerpt === 'string' ? candidate.source_excerpt.trim() : '';
    const options = strings(candidate.options);
    const answers = strings(candidate.correct_values);
    const orderedItems = strings(candidate.ordered_items);
    if (!kinds.has(kind) || (mode !== 'mixed' && modeKinds[mode] !== kind)) continue;
    if (!prompt || !explanation || !excerpt || !answers.length || seen.has(normalize(prompt))) continue;
    if (excerpt.split(/\s+/).length > 25) continue;
    if (sourceText && !normalize(sourceText).includes(normalize(excerpt))) continue;
    const choice = ['single_select', 'true_false', 'matching', 'drag_drop'].includes(kind);
    if (choice) {
      const expectedCount = kind === 'true_false' ? 2 : 4;
      if (options.length !== expectedCount || new Set(options.map(normalize)).size !== expectedCount) continue;
      if (answers.length !== 1 || !options.includes(answers[0])) continue;
      if (kind === 'true_false' && (!options.includes('True') || !options.includes('False'))) continue;
    } else if (options.length) continue;
    if (kind === 'ordering') {
      if (orderedItems.length < 3 || orderedItems.length > 6 || new Set(orderedItems).size !== orderedItems.length) continue;
      if (JSON.stringify(answers) !== JSON.stringify(orderedItems)) continue;
    }
    seen.add(normalize(prompt));
    questions.push({
      position: questions.length, kind, prompt, options, correct_values: answers,
      ordered_items: kind === 'ordering' ? orderedItems : [], explanation,
      source_excerpt: excerpt,
      topic_tag: typeof candidate.topic_tag === 'string' ? candidate.topic_tag.trim().slice(0, 100) : topicTag || null,
      difficulty: ['foundation', 'intermediate', 'advanced'].includes(candidate.difficulty) ? candidate.difficulty : 'foundation',
    });
    if (questions.length >= count) break;
  }
  return questions;
}