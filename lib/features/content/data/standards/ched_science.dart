import 'standards_lesson.dart';

const chedScienceLessons = <StandardsLesson>[
  StandardsLesson(
    title: 'Science, Technology, and Philippine Society',
    objectives: [
      'Distinguish scientific explanation from technological design.',
      'Explain how social priorities shape research and invention.',
      'Evaluate a technology using benefits, costs, and affected groups.',
    ],
    explanation:
        'Science develops explanations supported by evidence; technology applies knowledge and practical skills '
        'to design processes and tools. Society influences which questions receive funding, which tools are built, '
        'and who can use them. A flood-warning system combines rainfall measurements, scientific models, '
        'communication equipment, and local decisions. More accurate sensors alone cannot ensure safety if '
        'messages are inaccessible or evacuation routes exclude people with limited mobility. '
        'Philippine local and Indigenous knowledge includes careful observations of environments and useful '
        'practices. Such knowledge deserves attribution, consent, and respectful evaluation; calling a practice '
        'traditional neither proves nor disproves a scientific claim. A responsible analysis considers evidence, '
        'history, cultural context, distribution of benefits, and unintended effects.',
    model: {
      'Science: explain flood risk':
          'Measure rainfall and river levels, then test relationships and predictions.',
      'Technology: design an alert':
          'Combine sensors, power, messages, and accessible warning devices.',
      'Society: decide who is protected':
          'Include remote households, language access, maintenance, and evacuation support.',
    },
    worked: 'A barangay proposes text-only flood alerts. '
        '1. Identify the aim: timely evacuation. 2. Identify constraints: mobile signal, phone access, language, and disability access. '
        '3. Compare text alerts with radio, sirens, and trained local messengers. '
        '4. Recommend a tested combination and a maintenance plan rather than assuming one device reaches everyone.',
    guided:
        'A solar-powered water pump reduces fuel use but requires expensive repairs. What evidence should a community examine before purchasing it?',
    solution:
        'Compare lifetime costs, seasonal water demand, repair skills, spare parts, environmental effects, and access for different households. Consult users and test whether the design meets the actual need.',
    mistake:
        'Newer does not automatically mean better, and a technology is not socially neutral merely because it has a scientific component.',
    recap:
        'Analyze science, design, and social choices together; include people who receive fewer benefits or bear larger risks.',
    questions: [
      [
        'Which activity primarily develops a scientific explanation?',
        'Testing how rainfall relates to river rise',
        'Choosing a phone color',
        'Printing a sales slogan',
        'Naming a product',
        'The activity investigates an evidence-based relationship.'
      ],
      [
        'Which is a technological design decision in a flood system?',
        'Selecting how alerts reach residents',
        'Proving all floods identical',
        'Ignoring maintenance',
        'Assuming every home has a phone',
        'Design selects tools and processes to meet a need.'
      ],
      [
        'Why may text-only alerts exclude some residents?',
        'Not everyone has reliable phone access or signal',
        'All residents prefer identical devices',
        'Texts eliminate every access barrier',
        'Rainfall cannot be measured',
        'Access depends on infrastructure and user circumstances.'
      ],
      [
        'What should a technology evaluation include?',
        'Benefits, costs, risks, and affected groups',
        'Only novelty',
        'Only the advertisement',
        'Only the purchase price',
        'A social evaluation examines more than initial cost.'
      ],
      [
        'How should local knowledge be treated?',
        'With attribution, consent, and evidence-sensitive respect',
        'As automatically false',
        'As automatically scientifically proven',
        'As free of any ownership concerns',
        'Respect for knowledge holders and evaluation of claims can coexist.'
      ],
      [
        'Which is an ongoing cost of a warning system?',
        'Sensor maintenance and repairs',
        'Only the first purchase',
        'The product name',
        'The color of a poster',
        'Systems require continued upkeep to remain reliable.'
      ],
      [
        'Who should help evaluate an evacuation alert?',
        'Residents including people with access needs',
        'Only the vendor',
        'Only phone manufacturers',
        'No actual users',
        'Affected users reveal requirements that designers can miss.'
      ],
      [
        'Which is evidence of successful alert delivery?',
        'A drill showing residents received and understood the warning',
        'A large advertising budget',
        'A bright logo',
        'A claim that testing is unnecessary',
        'A drill tests the actual communication objective.'
      ],
      [
        'A solar pump has low fuel costs but high repair costs. What comparison is needed?',
        'Total costs and benefits over its useful life',
        'Only fuel cost',
        'Only its first-day output',
        'Only its brand popularity',
        'Lifetime evaluation includes operating and repair expenses.'
      ],
      [
        'Can more accurate sensors alone guarantee safe evacuation?',
        'No; communication and accessible response also matter',
        'Yes, in all communities',
        'Yes, even with no messages',
        'Only if no one maintains them',
        'Risk reduction is a whole-system problem.'
      ],
      [
        'What is an unintended effect worth investigating?',
        'Water access becoming less affordable for poorer households',
        'The stated purpose on the box',
        'The spelling of the device name',
        'A diagram title',
        'Distributional harms can occur even when the device works technically.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Scientific Revolutions and Evidence',
    objectives: [
      'Explain how new evidence can challenge established explanations.',
      'Distinguish a scientific model from an untested assertion.',
      'Use examples of intellectual change without treating science as infallible.',
    ],
    explanation:
        'Scientific knowledge changes through evidence, criticism, and improved methods. The Copernican model '
        'placed Earth and other planets in motion around the Sun, challenging an Earth-centered arrangement. '
        'Later observations and models, including Kepler\'s elliptical orbits, improved the account; Copernicus '
        'did not already possess every detail of modern astronomy. Darwin and Wallace developed explanations '
        'of evolution by natural selection: heritable variation can affect survival and reproduction, changing '
        'populations across generations. Evolution does not say that an individual changes because it needs to. '
        'Intellectual movements in psychology also changed discussion of human behavior, but historical influence '
        'is not the same as present empirical support for every claim. Evaluate each claim with appropriate '
        'evidence, alternatives, testability, and limitations.',
    model: {
      'Established explanation':
          'A model organizes observations but can contain errors.',
      'New observations and criticism':
          'Compare predictions, methods, and competing explanations.',
      'Revised explanation':
          'Retain what evidence supports; revise what evidence contradicts.',
    },
    worked:
        'A population of insects varies in resistance before exposure to an insecticide. '
        '1. Some variation is heritable. 2. Susceptible insects are more likely to die during exposure. '
        '3. Resistant survivors can leave more offspring. 4. Resistance becomes more common over generations; '
        'the insects did not consciously choose to evolve.',
    guided:
        'A new observation disagrees with a familiar astronomical model. Should a researcher discard the observation immediately or examine the measurement and competing explanations?',
    solution:
        'Check the instrument, methods, uncertainty, and reproducibility. If the discrepancy persists, compare revised models and their predictions. Neither popularity nor novelty alone decides the issue.',
    mistake:
        'Do not describe natural selection as purposeful improvement toward perfection, or assume an influential historical idea is beyond further testing.',
    recap:
        'Scientific change is evidence-guided revision, not a contest between famous names.',
    questions: [
      [
        'What did the Copernican model challenge?',
        'An Earth-centered arrangement of planetary motion',
        'The existence of measurements',
        'The use of mathematical models',
        'All forms of observation',
        'It placed Earth among planets orbiting the Sun.'
      ],
      [
        'Which later improvement is associated with Kepler?',
        'Elliptical planetary orbits',
        'Every orbit being a perfect square',
        'Planets having no motion',
        'The Sun orbiting every insect',
        'Elliptical orbits improved planetary predictions.'
      ],
      [
        'What is required for natural selection to change a population?',
        'Heritable variation related to reproductive success',
        'Every organism deciding to change',
        'No variation among organisms',
        'A single individual becoming a new population',
        'Selection changes the frequency of heritable traits across generations.'
      ],
      [
        'In the insect example, when can resistance variation already exist?',
        'Before insecticide exposure',
        'Only after every insect dies',
        'Only after a conscious decision',
        'Only after the insect is named',
        'Selection can act on pre-existing heritable variation.'
      ],
      [
        'Does natural selection require organisms to want a trait?',
        'No',
        'Yes, always',
        'Only in plants',
        'Only in bacteria',
        'It depends on variation and differential reproduction, not intention.'
      ],
      [
        'What should be done with an unexpected measurement?',
        'Check methods and compare explanations',
        'Erase it because it is surprising',
        'Accept it without checking',
        'Judge it only by popularity',
        'Reliable revision requires scrutiny of both evidence and models.'
      ],
      [
        'What distinguishes historical influence from current scientific support?',
        'Influence concerns impact; support depends on evidence for particular claims',
        'They are exactly identical',
        'Every old idea is false',
        'Every famous idea is untestable',
        'A theory can influence history without all of its claims remaining accepted.'
      ],
      [
        'What is a useful scientific model expected to do?',
        'Explain evidence and produce testable predictions within limits',
        'Avoid every possible test',
        'Guarantee complete certainty forever',
        'Replace observation with authority',
        'Models can be evaluated against observations.'
      ],
      [
        'Resistance becomes more common across many insect generations. What has changed?',
        'The population distribution of traits',
        'Every survivor\'s conscious goal',
        'The date of exposure only',
        'The definition of a planet',
        'Evolution concerns heritable changes in populations.'
      ],
      [
        'Why does science revise explanations?',
        'New reliable evidence or better models can reveal limitations',
        'Revision proves evidence is useless',
        'Only fashion determines facts',
        'All old measurements must be discarded',
        'Revisability is a strength of evidence-based inquiry.'
      ],
      [
        'Which statement avoids a misconception about evolution?',
        'Traits advantageous in one environment can be costly in another',
        'Every trait is perfect',
        'All evolution has a fixed goal',
        'Individuals evolve because they try hard',
        'Fitness depends on context and trade-offs.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Human Flourishing, Ethics, and Technology',
    objectives: [
      'Compare benefits and burdens of a proposed technology.',
      'Apply autonomy, fairness, and harm prevention to a case.',
      'Distinguish informed consent from merely obtaining a signature.',
    ],
    explanation:
        'Human flourishing involves more than efficiency or the number of devices owned. Technologies should be '
        'evaluated in relation to dignity, health, participation, relationships, and environmental conditions. '
        'An ethical assessment asks who benefits, who bears risk, whether alternatives exist, and whether '
        'affected people have a meaningful voice. In research, informed consent requires understandable '
        'information, voluntary choice, and the ability to decline or withdraw under the stated conditions. '
        'A signature alone does not establish understanding or freedom from pressure. Fairness may require '
        'additional support for excluded groups rather than identical treatment regardless of need. '
        'Risk cannot always be reduced to zero, but uncertainty must be disclosed rather than hidden behind '
        'claims that a technology is perfectly safe.',
    model: {
      'Benefit': 'An online service saves travel time for many users.',
      'Burden': 'People without internet access may lose service access.',
      'Ethical response':
          'Keep accessible alternatives and involve affected users in evaluation.',
    },
    worked: 'A university wants mandatory facial recognition for attendance. '
        '1. Identify the goal and less intrusive alternatives. 2. Examine data security, error rates, and unequal effects. '
        '3. Consult students and staff, including those harmed by errors. '
        '4. Decide whether necessity and benefits justify the risks, with appeal and deletion procedures.',
    guided:
        'A research participant signs a form they cannot understand because it is written in an unfamiliar language. Is the signature enough?',
    solution:
        'No. The researcher must provide understandable information, check understanding, and ensure the choice is voluntary. Translation or an appropriate explanation may be needed.',
    mistake:
        'Do not equate consent with a signature, fairness with ignoring different needs, or technical feasibility with ethical acceptability.',
    recap:
        'Assess dignity, consent, distribution of harms, meaningful participation, and less harmful alternatives.',
    questions: [
      [
        'Which question belongs in an ethical technology assessment?',
        'Who benefits and who bears the risks?',
        'Only how new the device is',
        'Only how expensive the logo is',
        'Only whether it can be built',
        'Ethical evaluation considers affected people and consequences.'
      ],
      [
        'What is required for informed consent?',
        'Understandable information and voluntary choice',
        'Only a signature',
        'Pressure from a supervisor',
        'No opportunity for questions',
        'Consent requires understanding and freedom to decide.'
      ],
      [
        'A participant cannot read the consent form. What should happen?',
        'Provide an understandable explanation and check understanding',
        'Assume the signature proves understanding',
        'Hide the risks',
        'Prevent questions',
        'Accessibility is part of meaningful informed consent.'
      ],
      [
        'What is a less intrusive alternative to facial recognition attendance?',
        'A suitable non-biometric attendance process',
        'Collecting more unrelated biometric data',
        'Removing every appeal route',
        'Publishing all face records',
        'Compare effective methods that collect less sensitive data.'
      ],
      [
        'Why examine error rates across user groups?',
        'Errors may burden groups unequally',
        'All systems always fail equally',
        'Fairness excludes measurement',
        'Only average accuracy can matter',
        'An overall average may hide unequal harms.'
      ],
      [
        'Which supports participation?',
        'Consulting affected users before and during implementation',
        'Only consulting the vendor',
        'Banning complaints',
        'Declaring all concerns irrational',
        'Users can identify harms and needs otherwise overlooked.'
      ],
      [
        'What does human flourishing include beyond efficiency?',
        'Dignity, health, relationships, and participation',
        'Only device ownership',
        'Only screen time',
        'Only corporate income',
        'Well-being has multiple social and personal dimensions.'
      ],
      [
        'Does technical feasibility alone establish ethical acceptability?',
        'No',
        'Yes, always',
        'Only if the device is expensive',
        'Only if an advertisement says so',
        'Being able to build a system does not settle whether it should be used.'
      ],
      [
        'Which feature helps people harmed by an automated error?',
        'An accessible appeal and correction process',
        'No human review',
        'Permanent uncorrectable records',
        'Hidden decision rules with no contact route',
        'People need a meaningful way to challenge and correct errors.'
      ],
      [
        'What should be said about important uncertainty?',
        'Disclose it and explain how risks will be monitored',
        'Promise perfect safety',
        'Suppress all discussion',
        'Treat uncertainty as proof of no risk',
        'Responsible decisions acknowledge evidence limits.'
      ],
      [
        'When might identical treatment be unfair?',
        'When differing access needs require different support',
        'Whenever everyone receives water',
        'Only when nobody uses technology',
        'Never under any circumstances',
        'Equal dignity can require accommodations rather than identical procedures.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Biodiversity, Biotechnology, and Public Decisions',
    objectives: [
      'Distinguish genetic, species, and ecosystem diversity.',
      'Explain how biodiversity supports human communities.',
      'Evaluate a biotechnology claim case by case using evidence and trade-offs.',
    ],
    explanation:
        'Biodiversity includes variation within species, among species, and among ecosystems. '
        'A mangrove area can support fish nurseries, store carbon, and reduce some coastal wave impacts, '
        'but it is not an unlimited shield against every storm. Loss of habitat, overuse, invasive species, '
        'pollution, and climate change can reduce biodiversity. Conservation decisions involve local livelihoods '
        'as well as ecological evidence. Biotechnology uses organisms or biological processes; examples include '
        'fermentation, tissue culture, and genetic engineering. These methods are not interchangeable. '
        'A genetically engineered crop should be evaluated by its particular trait, environmental setting, '
        'food-safety evidence, monitoring, and socioeconomic effects. The labels "natural" and "modified" alone '
        'do not establish safety, harm, or suitability.',
    model: {
      'Genetic diversity':
          'Different inherited variants within a crop species.',
      'Species diversity': 'Different species in a mangrove community.',
      'Ecosystem diversity':
          'Mangroves, seagrass beds, reefs, and forests across a landscape.',
    },
    worked:
        'A coastal area proposes replacing mixed mangroves with a single fast-growing species. '
        '1. Identify the goal and current species. 2. Examine habitat, survival, hydrology, and local uses. '
        '3. Compare mixed restoration with monoculture. 4. Monitor outcomes rather than judging success only by seedlings planted.',
    guided:
        'A crop advertisement says "genetically modified, therefore always safe." What information is missing?',
    solution:
        'The exact trait and use, relevant safety studies, environmental exposure, alternatives, regulatory assessment, and impacts on farmers are needed. A method label is not a complete risk assessment.',
    mistake:
        'Do not count planted seedlings as surviving forest, confuse all biotechnology with genetic engineering, or assume natural products are automatically harmless.',
    recap:
        'Specify the level of diversity and the actual intervention; assess ecological and social consequences with evidence.',
    questions: [
      [
        'Variation among inherited traits within one crop species is what?',
        'Genetic diversity',
        'Only ecosystem diversity',
        'Only species richness',
        'No biological diversity',
        'Genetic diversity concerns inherited variation within a species.'
      ],
      [
        'Mangroves, reefs, and forests in a region illustrate what?',
        'Ecosystem diversity',
        'One genetic variant',
        'A single organism',
        'An interest rate',
        'They are different ecological systems.'
      ],
      [
        'Which is a possible benefit of mangroves?',
        'Nursery habitat for some fish and coastal wave reduction',
        'Guaranteed prevention of every storm impact',
        'Unlimited protection without habitat health',
        'Elimination of all sea-level rise',
        'Benefits are real but depend on conditions and have limits.'
      ],
      [
        'Which can threaten biodiversity?',
        'Habitat loss',
        'Protecting diverse habitats',
        'Monitoring species recovery',
        'Reducing pollution',
        'Removing habitats can eliminate resources and populations.'
      ],
      [
        'Which is biotechnology but not necessarily genetic engineering?',
        'Fermentation',
        'Drawing a weather map',
        'Measuring a road',
        'Calculating a fare',
        'Fermentation uses biological processes.'
      ],
      [
        'What is needed to evaluate a genetically engineered crop?',
        'Evidence about its particular trait and context',
        'Only the word modified',
        'Only a slogan',
        'Only the package color',
        'Different traits and environments create different benefits and risks.'
      ],
      [
        'Why is seedling count alone a weak restoration measure?',
        'It does not show survival or ecosystem recovery',
        'Every planted seedling always survives',
        'Species never matter',
        'Hydrology has no effect',
        'Restoration requires sustained ecological function, not just planting.'
      ],
      [
        'Does natural automatically mean safe?',
        'No',
        'Yes, without exception',
        'Only if expensive',
        'Only if unnamed',
        'Natural substances and organisms can also cause harm.'
      ],
      [
        'Who should be included in coastal restoration decisions?',
        'Local communities and relevant ecological specialists',
        'Only a marketing team',
        'No resource users',
        'Only people living far away',
        'Decisions affect livelihoods and ecosystems.'
      ],
      [
        'Why may a mixed-species restoration be preferable to monoculture?',
        'Different species can support different functions and resilience',
        'Every species has identical needs',
        'Monoculture always contains more species',
        'Diversity prevents every possible loss',
        'Diversity can support complementary functions without guaranteeing immunity to harm.'
      ],
      [
        'Which evaluation is most defensible?',
        'Compare measured benefits, risks, alternatives, and affected livelihoods',
        'Choose only by whether a method sounds modern',
        'Assume all crop traits have identical risks',
        'Ignore monitoring after approval',
        'Public decisions need context-specific evidence and follow-up.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Climate Change, Energy, and Shared Responsibility',
    objectives: [
      'Explain the greenhouse effect and distinguish weather from climate.',
      'Compare mitigation with adaptation using Philippine examples.',
      'Evaluate energy choices using emissions, reliability, and access.',
    ],
    explanation:
        'Weather describes conditions over short periods; climate describes patterns over longer periods. '
        'Greenhouse gases absorb and emit infrared radiation, affecting Earth\'s energy balance. '
        'Human activities, including burning fossil fuels and changing land use, increase greenhouse-gas concentrations '
        'and drive current long-term warming. A single cool day does not overturn a long-term trend. '
        'Mitigation reduces the causes, such as emissions; adaptation reduces exposure or vulnerability to impacts. '
        'Insulating a building may reduce energy demand, while improving flood drainage can reduce flood risk. '
        'Solar and wind generation have low operational emissions but vary with conditions; planning can combine '
        'storage, transmission, demand management, and other resources. An energy comparison should consider '
        'lifecycle impacts, affordability, reliability, and who bears environmental burdens.',
    model: {
      'Mitigation':
          'Reduce emissions through efficiency and lower-emission energy.',
      'Adaptation':
          'Improve heat plans, flood resilience, and water management.',
      'Just transition':
          'Consider workers, affordability, access, and affected communities.',
    },
    worked: 'A campus proposes rooftop solar and a heat-response plan. '
        '1. Solar can reduce fossil-fuel electricity demand when it displaces it. '
        '2. The heat plan reduces health risk during extreme heat. '
        '3. These address mitigation and adaptation respectively. '
        '4. Measure energy output and access to cooling support instead of claiming all climate risk is removed.',
    guided:
        'A week is unusually cool. Does this disprove long-term warming? Explain which evidence is relevant.',
    solution:
        'No. A short local weather event cannot establish or reverse a global long-term trend. Compare long-term measurements, spatial coverage, and uncertainty.',
    mistake:
        'Do not confuse ozone depletion with the greenhouse effect, treat one storm as the entire climate record, or claim any energy source has zero lifecycle impact.',
    recap:
        'Use long-term evidence, distinguish mitigation from adaptation, and compare energy systems across environmental and social criteria.',
    questions: [
      [
        'Which describes climate rather than a single weather event?',
        'Long-term patterns of temperature and rainfall',
        'Rain at noon today',
        'This morning\'s wind gust',
        'One afternoon thunderstorm',
        'Climate concerns distributions and trends over longer periods.'
      ],
      [
        'What radiation do greenhouse gases absorb and emit?',
        'Infrared radiation',
        'Only sound waves',
        'Only mechanical vibration',
        'No radiation',
        'Their infrared interactions affect Earth\'s energy balance.'
      ],
      [
        'Which activity increases atmospheric carbon dioxide?',
        'Burning fossil fuels',
        'Measuring temperature',
        'Drawing a graph',
        'Sorting survey answers',
        'Combustion transfers fossil carbon to the atmosphere.'
      ],
      [
        'Which is mitigation?',
        'Reducing emissions from energy use',
        'Only building a flood shelter',
        'Only distributing emergency water',
        'Only relocating a heat clinic',
        'Mitigation addresses the causes of climate change.'
      ],
      [
        'Which is adaptation?',
        'Improving heat-health response plans',
        'Only calculating annual emissions',
        'Only changing a graph title',
        'Ignoring flood exposure',
        'Adaptation reduces vulnerability to impacts.'
      ],
      [
        'Does one cool week disprove long-term global warming?',
        'No',
        'Yes, conclusively',
        'Only if it rains',
        'Only if it is in November',
        'Short local variability and long-term global trends are different scales.'
      ],
      [
        'What challenge must solar electricity planning consider?',
        'Variation with sunlight and system needs',
        'Sunlight being identical all hours',
        'No need for electrical safety',
        'Guaranteed output at night without storage',
        'Output varies; system design must manage supply and demand.'
      ],
      [
        'Which is relevant to a just energy transition?',
        'Worker livelihoods and affordable access',
        'Only the color of panels',
        'Only a slogan',
        'Excluding nearby communities',
        'Fairness includes how costs and benefits are distributed.'
      ],
      [
        'Why examine lifecycle impacts?',
        'Manufacturing, operation, and disposal can all affect the environment',
        'Only the first second of use matters',
        'All materials have no impacts',
        'A label removes environmental costs',
        'A complete comparison follows the whole system.'
      ],
      [
        'Which evidence best evaluates a warming trend?',
        'Quality-controlled measurements over many years and locations',
        'One photograph of a cloudy day',
        'One person feeling cold',
        'A single uncalibrated reading',
        'Trends require reliable temporal and spatial evidence.'
      ],
      [
        'Can mitigation and adaptation be used together?',
        'Yes; they address different but related needs',
        'No; only one is logically possible',
        'Only if all weather stops',
        'Only outside the Philippines',
        'Reducing causes and reducing vulnerability are complementary.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Information, Emerging Technology, and Public Evidence',
    objectives: [
      'Assess a scientific claim using sources, methods, and uncertainty.',
      'Distinguish personal data, consent, and responsible data handling.',
      'Evaluate benefits and limitations of AI and other emerging technologies.',
    ],
    explanation:
        'The information age changes how knowledge is produced, shared, and contested. A scientific claim should '
        'be traced to its original study or official record where possible. Ask who made it, what evidence supports '
        'it, how the study was conducted, and whether independent evidence agrees. A testimonial is not equivalent '
        'to a controlled comparison. Artificial intelligence can identify patterns and generate useful drafts, '
        'but outputs can contain errors, biased associations, or fabricated citations. Human accountability '
        'and verification remain necessary. Digital systems also collect personal information. Responsible '
        'practice uses a legitimate purpose, appropriate consent or other lawful basis, minimal necessary data, '
        'secure storage, and clear retention rules. Access to information is valuable, but public availability '
        'does not automatically justify every reuse of a person\'s data.',
    model: {
      'Claim': 'A post says an AI system is accurate for every patient.',
      'Evidence questions':
          'Which population, comparison, error types, and independent validation?',
      'Governance questions':
          'Who is accountable, which data are needed, and how can errors be corrected?',
    },
    worked:
        'An online post claims a device improves memory because 3 buyers liked it. '
        '1. Identify the evidence as a small testimonial sample. '
        '2. Check for a comparison group, measurement method, and conflicts of interest. '
        '3. Seek stronger independent studies. 4. Report uncertainty rather than treating popularity as proof.',
    guided:
        'An AI response lists a journal article that cannot be found. What should a student do before citing it?',
    solution:
        'Verify the title, authors, journal, and identifier against reliable records. If unverified, do not cite it as a real source; seek an authentic source and disclose relevant tool use.',
    mistake:
        'Do not assume fluent writing proves truth, an official-looking logo proves authenticity, or publicly visible personal information is unrestricted.',
    recap:
        'Trace evidence, check methods, protect data, and retain human responsibility for technological decisions.',
    questions: [
      [
        'What is a first step when checking a viral scientific claim?',
        'Trace it to an original study or reliable official record',
        'Count emojis only',
        'Trust the longest headline',
        'Assume every repost independently verifies it',
        'Original evidence helps assess what was actually studied.'
      ],
      [
        'Three satisfied buyers are what kind of evidence?',
        'A small set of testimonials',
        'A guaranteed randomized trial',
        'A complete population census',
        'Proof for all users',
        'Testimonials have selection and comparison limitations.'
      ],
      [
        'Can AI generate a nonexistent citation?',
        'Yes',
        'No, never',
        'Only when offline',
        'Only if the article is old',
        'Generated text can include plausible but fabricated references.'
      ],
      [
        'What should be done before citing an AI-provided article?',
        'Verify it in reliable publication records',
        'Cite it because it sounds formal',
        'Invent a page number',
        'Assume the author approved it',
        'Citation details must correspond to an actual source.'
      ],
      [
        'What is data minimization?',
        'Collecting only data necessary for a stated legitimate purpose',
        'Collecting all available data forever',
        'Removing all security controls',
        'Publishing everyone\'s records',
        'Minimization limits unnecessary collection and exposure.'
      ],
      [
        'Why examine a study\'s comparison group?',
        'It helps distinguish an intervention effect from alternatives',
        'It replaces measurement',
        'It guarantees no bias of any kind',
        'It makes consent unnecessary',
        'A comparison can reveal changes that would happen without the intervention.'
      ],
      [
        'What is a conflict of interest worth checking?',
        'The study sponsor profits from a positive result',
        'The study has a title',
        'The report uses punctuation',
        'The data have units',
        'Financial interests can affect study design or interpretation and should be disclosed.'
      ],
      [
        'Who remains accountable for using an AI recommendation?',
        'The responsible people and institutions',
        'No one',
        'Only the keyboard',
        'Only a fictional author',
        'Using a tool does not remove human and institutional responsibility.'
      ],
      [
        'Does public visibility of personal data automatically justify every reuse?',
        'No',
        'Yes, always',
        'Only if copied quickly',
        'Only if many people repost it',
        'Purpose, rights, and applicable law still matter.'
      ],
      [
        'An AI system has high average accuracy. What else should be examined?',
        'Error types, affected groups, and deployment conditions',
        'Only its logo',
        'Only its number of users',
        'Nothing else',
        'An average can hide harmful errors or poor performance in some contexts.'
      ],
      [
        'Which supports a responsible conclusion?',
        'State what the evidence supports and what remains uncertain',
        'Promise certainty from weak evidence',
        'Hide contradictory results',
        'Replace methods with testimonials',
        'Transparent limitations improve scientific and public reasoning.'
      ],
    ],
  ),
];
