# Grade 4 Science pack: sources and review

This local, authored pack preserves the five Grade 4 titles and prerequisite order. It teaches ecosystem interactions beyond Grade 2 habitat needs, introductory cooperating human systems, observable energy transfers, rock composition and formation, and Earth–Moon–Sun motions. More detailed food webs, cells, circuits and astronomy remain for later grades.

Each lesson contains four objectives, substantive explanations, three local diagrams, a worked example, guided example with reveal, safe observation, misconception corrections, quick check with reveal, recap and key concept. Each bank has 20 practice items (7 foundation / 7 intermediate / 6 application) and three separate mastery items. All items are individually authored and limited to taught content.

## Scientific references

- [NIH/NIDDK: Your Digestive System & How It Works](https://www.niddk.nih.gov/health-information/digestive-diseases/digestive-system-how-it-works): mouth/esophagus/stomach/intestine route, digestion and nutrient absorption, and the large intestine's water absorption. This Grade 4 explanation omits finer absorption pathways without claiming all nutrients go directly into blood.
- [NASA Science: Moon Phases](https://science.nasa.gov/moon/moon-phases/): a sunlit hemisphere, changing Earth viewpoints, approximately 29½-day phase cycle, and the distinction between a quarter phase and a half-lit visible disk.
- [NASA Science: Eclipses and the Moon](https://science.nasa.gov/moon/eclipses/): special shadow alignment and orbit tilt; ordinary Moon phases are not Earth's shadow.
- [USGS: Collecting Rocks](https://pubs.usgs.gov/gip/collect1/collectgip.html): minerals as rock components, common rock groups and identification properties. Metamorphism is explicitly solid-rock change without melting; cooling a melt gives an igneous route.
- [USGS: The Rock Cycle](https://pubs.usgs.gov/of/1994/0636/report.pdf): sediments can undergo repeated erosion/deposition before compaction/cementation; the cycle offers multiple routes, rather than one mandatory order.

References are authoring evidence only; lessons and diagrams work offline. No remote images, data or network calls are needed at runtime. Diagram geometry and explanations are original. Prior third-party attributions and licenses remain untouched.

## Diagram decisions and limitations

The separate `Grade4SciencePicture` module supplies `g4-body`, `g4-rock` and `g4-moon`. Body geometry places the heart between lungs, slightly on the person's left (viewer's right). The diagram is a simplified overlapping-organ model, not a medical chart. Granite grain colors are a model key, not a promise of actual sample colors. The Moon picture separates the space view, with sunlight consistently from the left, from Earth-view disks. It explicitly omits scale and orbital tilt; alignment in this flat illustration does not imply monthly eclipses. Legends are scalable Flutter text; painter text is never used. The numbered markers are navigation aids, with complete accessible descriptions and legends.

Shared comparison/process/cycle/bar primitives describe ecosystem interactions and material recycling, food routes, cooperating systems, energy pathways, a fair ramp comparison, rock formation, sediment transport, and astronomical motion timescales. The ecosystem material cycle explicitly differs from energy transfer. The ramp bars measure centimetres of pin movement, rather than claiming to measure energy or a universal proportional law.

## Review and validation handoff

Independent factual review checked all 115 answer keys and explanations. Section-body word counts before final refinements were Ecosystems 787, Human Body Systems 830, Energy 867, Rocks & Minerals 821, and Earth, Moon & Sun 891. Sixty weak distractor sets were revised to use plausible role, mechanism and timing misconceptions. The reviewer rechecked those revised banks for ambiguity. Picture rendering and final automated checks are run by the coordinating agent to avoid concurrent Flutter processes in the shared worktree. `test/science_grade4_picture_test.dart` exercises all three pictures at 244 px width and 1.3 text scale, with accessible semantics.
