/// Compact original givens travel with questions into shuffled/offline/server
/// banks. No question depends on a diagram or a previously displayed passage.
const coreEnglishContexts = <String, String>{
  'g2.5':
      'Original story: Mina put soil in a pot. Next she planted a seed. Then she watered it. Days later a shoot appeared.',
  'g3.4':
      'Original examples: The fragile cup was carried gently. Mina was exhausted after a long run and needed to rest. The room was dim, so we turned on a lamp.',
  'g3.5':
      'Original paragraph: Our class cares for a garden. We water the beds each morning, pull weeds on Fridays, and check young plants for damage.',
  'g4.4':
      'Original passage: Bees carry pollen between flowers. Some birds also move pollen while feeding. Wind carries pollen for many grasses.',
  'g5.4':
      'Original models: Heavy rain flooded the footpath, so the class used another entrance. Separately, a tap leaked, and a caretaker replaced a worn washer to stop the leak.',
  'g5.5':
      'Original proposal: Our class should add a shaded reading corner for more comfortable reading on hot days. A trial could use existing furniture to address cost.',
  'g6.3':
      'Original images: The pond was like a mirror. The classroom buzzed like a beehive. The wind whispered through the leaves. The tired door groaned when opened.',
  'g6.4':
      'Original passage: Arun checked the clock twice and tapped his foot. When the door opened, he stood quickly. Other examples: Mina grinned and held a letter above her head. Lila took an umbrella and looked at dark clouds.',
  'g6.5':
      'Model thesis: A school garden supports observation and shared responsibility. Example 1: recording plant height each week. Example 2: assigning a watering roster.',
  'g7.1':
      'Model: Mina checked the map. Arun packed water. The path was steep, so the group slowed. These events can be combined with different clause structures.',
  'g7.3':
      'Original examples: The current carried leaves downstream. The cottage was cozy. The crowd pressed against the narrow exit. A different description calls the room cramped.',
  'g7.4':
      'Original story: At the village dock after sunset, Lila found an unclaimed bag. She wanted to hurry home, but took it to the caretaker. A traveler returned and thanked her.',
  'g7.5':
      'Classroom model: An open container catches rain. An observer reads its measurement marks at a consistent time, records the water depth, and empties the container for the next interval. Placement and design affect the measurements.',
  'g8.3':
      'Original school-council speech: We need a reading space. We need a quiet place. We need a chance to learn together. Will we leave these doors closed? No listener response is reported.',
  'g8.4':
      'Invented proposal: The library should trial later opening. Thirty recorded requests asked for later access this month. A one-evening trial could test demand and cost. Another invented claim says ten volunteers liked a timetable, so all pupils prefer it.',
  'g8.5':
      'Invented proposal: Trial a bottle-refill station near the courtyard. Recorded queues may indicate limited access. A second station may reduce waiting. Maintenance costs and staff time should be monitored. These observations are illustrative, not real school records.',
  'g9.2':
      'Vocabulary model: Observe means record or notice evidence; infer means interpret it; evaluate means judge using criteria. An invented report says a pattern suggests increased use, without establishing a cause.',
  'g9.3':
      'Original passage: The empty bench waited beneath the station clock. Mina touched the folded ticket but did not unfold it. When the train arrived, she stepped back. Her reason is not stated.',
  'g9.4':
      'Invented teaching source: Lira (2024), School Reading Trial, page 3: Twelve of twenty volunteers visited the reading corner twice. This is not a real publication or dataset. The author-year-page form is an illustration, not a universal citation rule.',
  'g9.5':
      'Original station scene: A bench waited beneath a clock. Mina held a folded ticket, did not unfold it, and stepped back when the train arrived. Model thesis: Time imagery and withheld actions create hesitation; her precise motive is unstated.',
  'g10.1':
      'Original style examples: After three checks, Mina crossed. Mina crossed after three checks. The limited sample suggests an uncertain result. Revisions must preserve the intended meaning and qualifications.',
  'g10.2':
      'Invented research model: Investigate how recorded library visits changed during four extra evening sessions at one school, compared with an earlier period. Check counting methods and possible timetable changes. Real research requires authentic records, not these illustrative givens.',
  'g10.3':
      'Invented report: Extra evening library sessions began, and visits rose; the report says opening alone caused the rise. Its heading is A Perfect Success. A separate advertisement says nine selected users praised a tool, so it works for everyone. No further methods are given.',
  'g10.4':
      'Original invented council appeal: As the librarian who logs requests, I have seen pupils ask for later access. Our log lists thirty requests. Imagine a quiet place to finish a project. Let us trial one evening and publish the cost. No vote is reported.',
  'g10.5':
      'Invented research model: Four extra evening library sessions had more recorded visits. Door-entry counts are the measured outcome. Learning gains were not measured, and timetable changes remain a possible explanation. Real reports require authentic evidence.',
  'g11.1':
      'Invented abstract: A four-week trial recorded more library entries during extra evening sessions. Entries counted visits, not unique readers. The report suggests increased use but does not measure learning outcomes.',
  'g11.2':
      'Original invented council speech: As the librarian who logs requests, I know thirty requests asked for later access. Will we keep the doors closed? A one-evening trial with a published budget lets us test the idea. Request methods and listener reactions are not reported.',
  'g11.3':
      'Invented Source A: A dated librarian log documenting local visits and its counting method. Invented Source B: An anonymous advertisement claiming every pupil benefits, without an outcome or sampling method. Neither supplies a measured learning outcome.',
  'g11.4':
      'Invented logic model: If the library opens, its hall light is on. The light could also be on for maintenance. Separate example: If a form is incomplete, it is rejected. Assume stated premises are true when testing validity.',
  'g11.5':
      'Invented empirical paper: A bounded evening-library trial records visits. Door-entry counting belongs in methods; visit totals in results; timetable alternatives in discussion. A humanities paper may instead organize interpretive claims. Real papers need authentic sources.',
  'g12.1':
      'Editing model: A limited sample supports a cautious interpretation. Compare visit counts before a trial with visit counts during it. The researcher uses the records. Preserve these relationships when editing.',
  'g12.2':
      'Invented report: A school added evening library hours and recorded more visits. Its authors claim learning improved, but no learning outcome was measured. A new project deadline or timetable change could affect visits.',
  'g12.3':
      'Invented sources: A reports support from 12 of 20 volunteers (60%). B reports support from 80 of 200 randomly selected pupils (40%). These samples and selection methods differ; neither is real research.',
  'g12.4':
      'Invented trial model: Recorded visits increased, but learning outcomes were not measured. The researcher recorded visits. Scope is this trial, not every reader or institution.',
  'g12.5':
      'Invented three-minute council talk: Propose a four-session evening-library trial with cost reporting. Present visit evidence and acknowledge that grades were not measured. End with a specific request. No actual council decision is reported.',
  'college.1':
      'Invented report model: A team recorded increased visits during a limited trial. This may indicate an access benefit, but learning outcomes were not measured. Define utilization here as recorded visits rather than every educational benefit.',
  'college.2':
      'Invented argument: Evening opening increased recorded visits. Therefore it caused learning gains, and every school should adopt it. Only visits were measured; learning outcomes, alternative influences and all-school feasibility remain untested.',
  'college.3':
      'Invented teaching source: Orin (2024), Access Trial Notes, page 7: Attendance increased during four evening sessions; learning outcomes were not assessed. The source is fictional and cannot serve as real scholarly evidence.',
  'college.4':
      'Invented proposal: Test evening-library access at one school for one term. Documented requests may suggest unmet local demand, but attendance feasibility and staff workload need checking. Real arguments require authentic records.',
  'college.5':
      'Original invented email: Subject: Review revised timetable by Friday. Team, the room booking moved from Monday to Tuesday. Please check the attached timetable and send corrections by Friday noon. Mina will consolidate responses. No email is actually sent.',
};
