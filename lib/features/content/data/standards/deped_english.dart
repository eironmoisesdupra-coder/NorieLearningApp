import '../../domain/norie_content_models.dart';
import '../authored/authored_lesson_visual.dart';
import 'deped_english_g1.dart';
import 'deped_english_g2.dart';
import 'deped_english_g3.dart';
import 'deped_english_g4.dart';
import 'deped_english_g5.dart';
import 'deped_english_g6.dart';
import 'deped_english_g7.dart';
import 'deped_english_g8.dart';
import 'deped_english_g9.dart';
import 'deped_english_g10.dart';
import 'deped_english_unit.dart';

/// Six to eight original main-domain lessons per grade, not a complete course.
///
/// New titles intentionally create new semantic IDs. These lessons do not use
/// CoreEnglishLesson's legacy question-context table. No network is used at
/// runtime: URLs below are provenance, not lesson dependencies.
final Map<String, List<NorieTopicContent>> depedEnglish = Map.unmodifiable({
  for (final entry in _units.entries)
    entry.key: englishGrade(entry.key, entry.value),
});

final Map<String, AuthoredLessonVisual> depedEnglishVisuals = Map.unmodifiable({
  for (final entry in _units.entries)
    for (final unit in entry.value)
      depedEnglishVisualId(entry.key, unit): englishUnitVisual(unit),
});

const _units = <String, List<DepedEnglishUnit>>{
  'g1': depedEnglishG1,
  'g2': depedEnglishG2,
  'g3': depedEnglishG3,
  'g4': depedEnglishG4,
  'g5': depedEnglishG5,
  'g6': depedEnglishG6,
  'g7': depedEnglishG7,
  'g8': depedEnglishG8,
  'g9': depedEnglishG9,
  'g10': depedEnglishG10,
};

const _language =
    'https://www.deped.gov.ph/wp-content/uploads/MATATAG-Language-CG-Grade1.pdf';
const _matatag =
    'https://www.deped.gov.ph/wp-content/uploads/MATATAG-ENGLISH-CG-G4-and-7.pdf';
const _legacy =
    'https://www.deped.gov.ph/wp-content/uploads/2019/01/English-CG.pdf';

/// Official guides actually read. Page references are PDF pages (1-based).
///
/// MATATAG rollout does not establish that a legacy competency table is the
/// current table. For grades without a verified current subject guide, these
/// lessons explicitly use May 2016 legacy skill references. Quarter labels in
/// those lessons are an authored broad-domain sequence, not invented codes or
/// a claim of exact current quarter/week correspondence.
const Map<String, List<String>> depedEnglishSources = {
  'g1': [
    '$_language | MATATAG Language Grade 1, PDF pp.30–31, Q1: self/family, oral interaction and familiar vocabulary; Lina Says Hello and Our Red Bag.',
    '$_language | MATATAG Language Grade 1, PDF pp.32–33, Q2: school, symbols, simple sentences and oral stories; A Sign at School and The Lost Class Ball.',
    '$_language | MATATAG Language Grade 1, PDF pp.34–35, Q3: community language, retelling and social expressions; At the Fruit Stall.',
    '$_language | MATATAG Language Grade 1, PDF pp.36–37, Q4: environment, information and inference; Rain at the Gate. L1 oracy area, NOT standalone English or the separate Reading and Literacy guide.',
  ],
  'g2': [
    '$_legacy | LEGACY May 2016 English Grade 2, PDF pp.27–52, Q1–Q2 oracy tables: oral language, listening, sound awareness, vocabulary and story comprehension; first four authored units select these domains.',
    '$_legacy | LEGACY May 2016 English Grade 2, PDF pp.27–52, Q3–Q4 beginning reading/writing strand: word recognition, print, grammar, messages and comprehension; note/sign lessons are representative, not a complete phonics progression.',
  ],
  'g3': [
    '$_legacy | LEGACY May 2016 English Grade 3, PDF pp.53–78, Q1–Q2 continuation of beginning literacy: word study, vocabulary, grammar and narrative comprehension; shell, bench and kite units.',
    '$_legacy | LEGACY May 2016 English Grade 3, PDF pp.53–78, Q3–Q4: informational comprehension, connected writing and conventions; procedure, comparison and garden-recount units. Authored quarter placement is broad, not a current competency-code mapping.',
  ],
  'g4': [
    '$_matatag | MATATAG English Grade 4, PDF pp.36–38, Q1: literary/informational comprehension, vocabulary, grammar and narrative composition; lantern and creek units.',
    '$_matatag | MATATAG English Grade 4, PDF pp.39–41, Q2: enumeration-description and chronological/procedural exposition; garden-visitors and rain-gauge units.',
    '$_matatag | MATATAG English Grade 4, PDF pp.42–44, Q3: time order, procedure and recount with literal/inferential comprehension; book-swap recount.',
    '$_matatag | MATATAG English Grade 4, PDF pp.45–47, Q4: recount, context/audience, visual meaning and verbal/nonverbal communication; cleanup poster and report.',
  ],
  'g5': [
    '$_legacy | LEGACY May 2016 English Grade 5, PDF pp.101–105, Q1: narrative comprehension, vocabulary and communication; spare-paddle and word-parts units.',
    '$_legacy | LEGACY May 2016 English Grade 5, PDF pp.106–109, Q2: critical listening to news, factual/opinion information and language conventions; news and lost-keys units.',
    '$_legacy | LEGACY May 2016 English Grade 5, PDF pp.110–114, Q3: text comprehension, figurative language and expression; original morning-poem unit selects these skills.',
    '$_legacy | LEGACY May 2016 English Grade 5, PDF pp.115–119, Q4: organizing/communicating information and writing conventions; library-notice revision. Not the full grade skill inventory.',
  ],
  'g6': [
    '$_legacy | LEGACY May 2016 English Grade 6, PDF pp.125–130, Q1: narrative/inferential comprehension, grammar and meaningful communication; bridge and museum units.',
    '$_legacy | LEGACY May 2016 English Grade 6, PDF pp.131–135, Q2: information/media interpretation and connected texts; advertisement and two water notes.',
    '$_legacy | LEGACY May 2016 English Grade 6, PDF pp.136–139, Q3: persuasive expression, evidence and oral communication; shade-speech unit.',
    '$_legacy | LEGACY May 2016 English Grade 6, PDF pp.140–144, Q4: informational organization and writing/research skills; mini inquiry report. This is a selected skill sequence, not current MATATAG certification.',
  ],
  'g7': [
    '$_matatag | MATATAG English Grade 7, PDF pp.56–57, Q1: evaluating/creating Philippine poetry for meaning, purpose, audience and identity; jeepney-stop and river-poem units.',
    '$_matatag | MATATAG English Grade 7, PDF pp.58–59, Q2: Philippine prose, structure, characterization and original composition; notebook story. Novel-length reading and a full published prose project are not supplied.',
    '$_matatag | MATATAG English Grade 7, PDF pp.60–62, Q3: expository and journalistic texts, including news, press releases and features; ferry news/feature comparison. Full press-release production is not supplied.',
    '$_matatag | MATATAG English Grade 7, PDF pp.63–65, Q4: academic expository essay and transactional letter of request; shared-books essay and reading-corner request.',
  ],
  'g8': [
    '$_legacy | LEGACY May 2016 English Grade 8, PDF pp.176–179, Q1: Afro-Asian literary study, informative speech, outline, cohesion and parallel structure; courtyard and archive-speech skill exercises.',
    '$_legacy | LEGACY May 2016 English Grade 8, PDF pp.180–183, Q2: East Asian literature, sensory/verbal signals, descriptive/narrative interpretation and grammatical signals; clinic unit selects inference/cohesion only. No contextualized East Asian literary work or complete related performance is supplied.',
    '$_legacy | LEGACY May 2016 English Grade 8, PDF pp.184–186, Q3: propaganda, target audience, persuasive language and information; club-poster unit.',
    '$_legacy | LEGACY May 2016 English Grade 8, PDF pp.187–189, Q4: South/West Asian literature, information sources, active/passive voice, direct/reported speech, perfect tense and journalistic writing; source-evaluation, clock report and journal-to-report units select language/information skills, not the regional literature corpus. Current MATATAG grade table unverified here.',
  ],
  'g9': [
    '$_legacy | LEGACY May 2016 English Grade 9, PDF pp.202–204, Q1: British-American including Philippine literary study, self-discovery, word order and conventions; workshop scene and poetic-inversion exercises.',
    '$_legacy | LEGACY May 2016 English Grade 9, PDF pp.205–208, Q2: interpreting literary/dramatic texts, expression and context; rehearsal drama. Actual British-American and Philippine literary works need additional contextualized reading.',
    '$_legacy | LEGACY May 2016 English Grade 9, PDF pp.209–211, Q3: one-act play analysis/performance and verbals, plus processing persuasive information; print-room scene and quiet-corner proposal. A short script is not a complete staged performance.',
    '$_legacy | LEGACY May 2016 English Grade 9, PDF pp.212–215, Q4: full-length play, consistent tense, modals, voice/reported speech and evaluation of reasoning/bias; three-act outline, performance reviews and supplementary calendar essay plan. Full-length script/performance not supplied; these are legacy skill selections, not current MATATAG quarter certification.',
  ],
  'g10': [
    '$_legacy | LEGACY May 2016 English Grade 10, PDF pp.223–225, Q1: world-literary elements, persuasive text, public-speaking ethics, reflexive/intensive pronouns; translator and ethical-speech exercises.',
    '$_legacy | LEGACY May 2016 English Grade 10, PDF pp.226–228, Q2: persuasive/argumentative language, claims and evidence; accessible-stage argument.',
    '$_legacy | LEGACY May 2016 English Grade 10, PDF pp.229–231, Q3: literary criticism including structural/formalist and social perspectives, special-occasion speech and structures of modification; locked-garden two-lens exercise and new-readers welcome speech.',
    '$_legacy | LEGACY May 2016 English Grade 10, PDF pp.232–234, Q4: research and composition, source use, evidence and limitations; travel-study and library-synthesis units. Full world-literature corpus, research project and current MATATAG table are not supplied.',
  ],
};

/// Explicit publication limits, suitable for an offline provenance panel.
const Map<String, String> depedEnglishCoverageNotes = {
  'g1': 'English-language support for MATATAG Language L1 oracy only. '
      'Use a familiar language and a helper where appropriate. Not standalone '
      'Grade 1 English, not a complete Reading and Literacy or phonics course. '
      'Recorded listening, pronunciation assessment and real oral interaction '
      'are not replaced by the multiple-choice checks.',
  'g2': 'May 2016 legacy English skill reference; current MATATAG subject '
      'competencies unverified. Six representative units across four authored '
      'quarters, not a complete beginning-literacy or oral-assessment program.',
  'g3': 'May 2016 legacy English skill reference; current MATATAG subject '
      'competencies unverified. Six representative units; not an exhaustive '
      'word-reading sequence or a scored independent writing program.',
  'g4': 'Verified MATATAG G4 quarter text foci and language domains; six '
      'representative lessons, not every competency/week. Oral performance, '
      'extended composition and culturally varied text sets need further work.',
  'g5': 'May 2016 legacy English skill reference, not a verified current '
      'MATATAG G5 mapping. Six selected-domain lessons do not assess all '
      'listening, viewing, oral performance or independent composition skills.',
  'g6': 'May 2016 legacy English skill reference, not a verified current '
      'MATATAG G6 mapping. Inquiry and speech lessons are worked models; '
      'a learner-run inquiry and assessed oral presentation remain needed.',
  'g7': 'Verified MATATAG G7 quarter genres. Original Philippine-context '
      'poetry/prose and expository/journalistic/transactional models; not a '
      'complete literature corpus. Novel reading, press-release production, '
      'extended original prose, actual multimodal publication and live '
      'performance remain outside this six-lesson path.',
  'g8': 'May 2016 legacy skill reference, not a verified current MATATAG G8 '
      'mapping. Original exercises do not replace contextualized Afro-Asian '
      'works, sustained literary study, public performance or a full report.',
  'g9': 'May 2016 legacy skill reference, not a verified current MATATAG G9 '
      'mapping. Original exercises do not replace British-American/Philippine '
      'literary works, historical context, full theater production or essays.',
  'g10': 'May 2016 legacy skill reference, not a verified current MATATAG G10 '
      'mapping. Original exercises do not replace a world-literature corpus, '
      'all critical approaches, sustained argument, oral performance or an '
      'independently conducted and fully referenced research project.',
};
