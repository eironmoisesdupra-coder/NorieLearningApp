import '../domain/norie_content_models.dart';
import 'norie_grade1_materials_questions.dart';

/// Approved Lesson 5 prose. Author-only visual directions are implemented by
/// NorieGrade1MaterialsVisual instead of being shown to learners.
final norieGrade1MaterialsTopic = NorieTopicContent(
  id: 'science.g1.materials-around-us',
  subject: 'Science',
  category: 'Grade 1',
  gradeLevel: 'g1',
  title: 'Materials Around Us 🪵🧱',
  subtitle:
      'Learn about common materials, their properties, and why different materials are used to make different objects.',
  order: 5,
  accent: 'green',
  visualType: 'g1-science',
  prerequisiteTopicId: 'science.g1.weather',
  lesson: const NorieLessonContent(
    heading: 'Materials Around Us 🪵🧱',
    introduction:
        'Learn about common materials, their properties, and why different materials are used to make different objects.\n20–25 minutes',
    keyConceptTitle: '',
    keyConceptBody: '',
    sections: [
      NorieLessonSection(
          title: "LEARNING GOALS 🎯",
          symbol: "",
          points: [],
          body:
              "By the end of this lesson, the learner should be able to:\n\n• Name common materials such as wood, metal, plastic, glass, paper, fabric, and rubber.\n• Describe simple properties of materials.\n• Compare materials using words such as hard, soft, smooth, rough, flexible, and waterproof.\n• Explain that objects can be made from different materials.\n• Choose a suitable material for a simple purpose.\n• Understand that some materials can be reused or recycled.",
          reveal: false),
      NorieLessonSection(
          title: "OPENING — WHAT ARE THINGS MADE OF? 👀",
          symbol: "",
          points: [],
          body:
              "Look around you.\n\nYou may see:\n\n🪑 a chair;\n\n✏️ a pencil;\n\n🥤 a cup;\n\n📘 a book;\n\n👕 a shirt;\n\n🪟 a window;\n\n🧸 a toy.\n\nThese objects are made from different materials.\n\nA material is what an object is made from.\n\nFor example:\n\nA wooden table may be made from wood. 🪵\n\nA spoon may be made from metal. 🥄\n\nA raincoat may be made from waterproof fabric or plastic-like material. 🧥\n\nA window may be made from glass. 🪟\n\nDifferent materials have different properties.\n\nThese properties help us decide which material is useful for a certain job.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 1 — WHAT IS A MATERIAL? 🧱",
          symbol: "",
          points: [],
          body:
              "A material is a substance used to make an object.\n\nOne object can be made from one material.\n\nAnother object can be made from several materials.\n\nFor example:\n\nA pencil may contain:\n\n🪵 wood;\n\n✏️ graphite;\n\n🎨 paint;\n\nand sometimes a rubber eraser.\n\nA shoe may contain:\n\n👟 fabric;\n\nrubber;\n\nfoam;\n\nand other materials.\n\nSo when we study an object, we can ask:\n\n\"What is it made of?\"",
          reveal: false),
      NorieLessonSection(
          title: "VISUAL 1 — OBJECT AND MATERIAL",
          symbol: "",
          points: [],
          visualType: "science-5-1",
          visualCaption: "Objects are made from different materials."),
      NorieLessonSection(
          title: "SECTION 2 — WOOD 🪵",
          symbol: "",
          points: [],
          body:
              "Wood comes from trees.\n\nWood can be used to make many objects.\n\nExamples:\n\n🪑 chairs;\n\n🚪 doors;\n\n📚 shelves;\n\n✏️ pencils;\n\n🧸 some toys.\n\nWood is often:\n\n• hard;\n• strong;\n• easy to shape into useful objects.\n\nDifferent kinds of wood can feel and look different.\n\nSome wood is smooth.\n\nSome wood feels rough.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 3 — METAL 🔩",
          symbol: "",
          points: [],
          body:
              "Metal is used in many everyday objects.\n\nExamples:\n\n🥄 spoons;\n\n🍴 forks;\n\n🔑 keys;\n\n🚲 bicycles;\n\n🔧 tools.\n\nMany metals are:\n\n• hard;\n• strong;\n• durable.\n\nSome metals can also be shiny.\n\nSome metals can bend when enough force is used.\n\n💡 REMEMBER:\n\nNot every metal object looks the same.\n\nDifferent metals can have different properties.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 4 — PLASTIC 🧴",
          symbol: "",
          points: [],
          body:
              "Plastic is used to make many objects.\n\nExamples:\n\n🧴 bottles;\n\n🧸 toys;\n\n📦 containers;\n\n🪣 buckets.\n\nPlastic can be made in many forms.\n\nSome plastic is:\n\n• hard;\n\nwhile other plastic is:\n\n• flexible.\n\nPlastic can also be:\n\n• lightweight;\n• waterproof;\n• easy to shape.\n\nBecause plastic lasts a long time, we should use and dispose of it carefully.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 5 — GLASS 🪟",
          symbol: "",
          points: [],
          body:
              "Glass is often used when we want light to pass through an object.\n\nExamples:\n\n🪟 windows;\n\n🥛 drinking glasses;\n\n🫙 jars.\n\nMany types of glass are:\n\n• hard;\n• smooth;\n• transparent.\n\nTransparent means light can pass through so we can see through it.\n\nBut glass can break.\n\nBroken glass can be sharp and dangerous.\n\n⚠️ SAFETY:\n\nDo not pick up broken glass.\n\nTell a trusted adult.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 6 — PAPER 📄",
          symbol: "",
          points: [],
          body:
              "Paper is used for:\n\n📚 books;\n\n📝 notebooks;\n\n📰 newspapers;\n\n🎁 wrapping;\n\n🎨 artwork.\n\nPaper is often:\n\n• light;\n• thin;\n• easy to fold;\n• easy to write or draw on.\n\nPaper is not usually a good material for holding water because it can become wet and weak.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 7 — FABRIC 👕",
          symbol: "",
          points: [],
          body:
              "Fabric is used to make many things we wear and use.\n\nExamples:\n\n👕 shirts;\n\n👖 pants;\n\n🛏️ blankets;\n\n🧦 socks;\n\n🎒 some bags.\n\nDifferent fabrics can have different properties.\n\nSome are:\n\n• soft;\n• smooth;\n• thick;\n• thin;\n• stretchy.\n\nThe type of fabric depends on what the object needs to do.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 8 — RUBBER 🟠",
          symbol: "",
          points: [],
          body:
              "Rubber is used in objects that may need to bend, stretch, grip, or bounce.\n\nExamples:\n\n🏀 balls;\n\n🚲 tires;\n\n✏️ erasers;\n\n🧤 rubber gloves;\n\n👢 some boots.\n\nRubber can be:\n\n• flexible;\n• stretchy;\n• waterproof;\n• grippy.\n\nThese properties make rubber useful for many jobs.",
          reveal: false),
      NorieLessonSection(
          title: "VISUAL 2 — COMMON MATERIALS",
          symbol: "",
          points: [],
          visualType: "science-5-2",
          visualCaption:
              "Different materials are useful for different objects."),
      NorieLessonSection(
          title: "SECTION 9 — WHAT IS A PROPERTY? 🔍",
          symbol: "",
          points: [],
          body:
              "A property is something we can observe or describe about a material.\n\nWe can use our senses carefully to learn about materials.\n\nWe might ask:\n\nIs it hard or soft?\n\nIs it smooth or rough?\n\nIs it stiff or flexible?\n\nCan we see through it?\n\nDoes it soak up water?\n\nCan it stretch?\n\nThese observations help us compare materials.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 10 — HARD AND SOFT 🧱🧸",
          symbol: "",
          points: [],
          body:
              "Some materials feel hard.\n\nExamples:\n\n🔩 metal;\n\n🪵 wood;\n\n🪟 glass.\n\nOther materials can feel soft.\n\nExamples:\n\n🧸 soft fabric;\n\n🛏️ a blanket;\n\n🧽 foam.\n\nEXAMPLE\n\nA metal spoon is hard.\n\nA soft blanket is soft.\n\nHard and soft are properties we can use to describe materials.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 11 — SMOOTH AND ROUGH ✋",
          symbol: "",
          points: [],
          body:
              "Some surfaces feel smooth.\n\nOthers feel rough.\n\nA glass window may feel smooth.\n\nA rough piece of wood may feel uneven.\n\nTouch can help us notice texture.\n\nTexture means how a surface feels.\n\n⚠️ SAFETY:\n\nOnly touch objects that are safe to handle.\n\nDo not touch sharp, hot, or broken materials.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 12 — FLEXIBLE AND STIFF ↪️",
          symbol: "",
          points: [],
          body:
              "A flexible material can bend without breaking easily.\n\nA stiff material does not bend easily.\n\nExamples:\n\nA rubber band is flexible.\n\nA metal spoon is usually much stiffer.\n\nFabric can also be flexible.\n\nSome plastic can bend too.\n\nDifferent objects need different amounts of flexibility.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 13 — WATERPROOF AND ABSORBENT 💧",
          symbol: "",
          points: [],
          body:
              "Some materials resist water.\n\nWe call these waterproof or water-resistant materials.\n\nExamples can include:\n\n🧴 some plastics;\n\n🟠 rubber;\n\n🧥 waterproof fabric.\n\nOther materials absorb water.\n\nAbsorb means to take in liquid.\n\nExamples:\n\n🧽 sponge;\n\n🧻 paper towel;\n\nsome fabrics.\n\nEXAMPLE\n\nImagine making an umbrella.\n\nWould paper be a good material?\n\nProbably not.\n\nPaper can absorb water and become weak.\n\nA waterproof material is a better choice.",
          reveal: false),
      NorieLessonSection(
          title: "VISUAL 3 — MATERIAL PROPERTIES",
          symbol: "",
          points: [],
          visualType: "science-5-3",
          visualCaption: "Properties help us describe and compare materials."),
      NorieLessonSection(
          title: "SECTION 14 — TRANSPARENT AND OPAQUE 👀",
          symbol: "",
          points: [],
          body:
              "Some materials let light pass through.\n\nIf we can see through a material clearly, we call it transparent.\n\nGlass used in many windows is transparent.\n\nOther materials block our view.\n\nWe can call these opaque.\n\nWood is usually opaque.\n\nMetal is usually opaque.\n\nPaper is usually opaque.\n\nEXAMPLE\n\nWhy is clear glass useful for a window?\n\nBecause we can see through it and light can pass through.",
          reveal: false),
      NorieLessonSection(
          title: "TRANSPARENT AND OPAQUE — LIGHT AND VIEW",
          symbol: "",
          points: [],
          visualType: "science-5-5",
          visualCaption:
              "Clear glass lets light and our view pass through. Wood blocks our view."),
      NorieLessonSection(
          title: "SECTION 15 — ONE OBJECT, DIFFERENT MATERIALS 🔄",
          symbol: "",
          points: [],
          body:
              "The same type of object can sometimes be made from different materials.\n\nThink about a chair.\n\nA chair can be made from:\n\n🪵 wood;\n\n🔩 metal;\n\n🧴 plastic.\n\nThe material may change how the chair feels, looks, weighs, or how long it lasts.\n\nThink about a cup.\n\nA cup may be made from:\n\n🪟 glass;\n\n🧴 plastic;\n\n🔩 metal;\n\nor other safe materials.\n\nThis shows us that there can be more than one suitable material for an object.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 16 — ONE OBJECT CAN USE MANY MATERIALS 🧩",
          symbol: "",
          points: [],
          body:
              "Some objects are made from several materials.\n\nThink about a bicycle. 🚲\n\nIt may have:\n\n🔩 a metal frame;\n\n🟠 rubber tires;\n\n🧴 plastic parts;\n\n🪑 fabric or foam on the seat.\n\nEach material is chosen because it has useful properties.\n\nThis is called choosing materials for a purpose.",
          reveal: false),
      NorieLessonSection(
          title: "ONE BICYCLE, MANY MATERIALS",
          symbol: "",
          points: [],
          visualType: "science-5-6",
          visualCaption: "Each part uses materials with useful properties."),
      NorieLessonSection(
          title: "WORKED EXAMPLE — WHAT SHOULD A RAINCOAT BE MADE FROM? 🌧️",
          symbol: "",
          points: [],
          body:
              "Imagine we want to make a raincoat.\n\nWhat property do we need most?\n\nSTEP 1:\n\nThink about what a raincoat must do.\n\nIt should help keep water away from the person wearing it.\n\nSTEP 2:\n\nCompare materials.\n\nPaper:\ncan absorb water and become weak.\n\nWood:\nhard and uncomfortable to wear.\n\nGlass:\nhard and breakable.\n\nWaterproof fabric:\nflexible and resists water.\n\nSTEP 3:\n\nChoose the material that fits the job.\n\nCONCLUSION:\n\n🧥 A flexible waterproof material is a good choice for a raincoat.",
          reveal: false),
      NorieLessonSection(
          title: "GUIDED EXAMPLE — WHAT SHOULD A WINDOW BE MADE FROM? 🪟",
          symbol: "",
          points: [],
          body:
              "A window should let us see outside and allow light to pass through.\n\nWhich property is useful?\n\nTransparent.\n\nWhich material is commonly transparent and suitable for windows?\n\nGlass.\n\nSo:\n\n🪟 Glass is useful for many windows because it can be transparent.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 17 — CHOOSING THE RIGHT MATERIAL 🎯",
          symbol: "",
          points: [],
          body:
              "We choose materials based on what an object needs to do.\n\nUMBRELLA ☔\n\nUseful property:\n\nWaterproof\n\nBLANKET 🛏️\n\nUseful property:\n\nSoft\n\nWINDOW 🪟\n\nUseful property:\n\nTransparent\n\nBICYCLE TIRE 🚲\n\nUseful properties:\n\nFlexible and grippy\n\nSPOON 🥄\n\nUseful properties:\n\nHard and strong\n\nThe \"best\" material depends on the job.",
          reveal: false),
      NorieLessonSection(
          title: "CHOOSING A MATERIAL FOR A PURPOSE",
          symbol: "",
          points: [],
          visualType: "science-5-7",
          visualCaption: "Choose a material whose properties fit the job."),
      NorieLessonSection(
          title: "SECTION 18 — CHANGING MATERIALS ✂️",
          symbol: "",
          points: [],
          body:
              "Materials can sometimes be changed.\n\nPaper can be:\n\nfolded;\n\ncut;\n\ntorn.\n\nClay can be:\n\npressed;\n\nrolled;\n\nshaped.\n\nFabric can be:\n\ncut;\n\nfolded;\n\nsewn.\n\nMetal can be shaped using special tools.\n\nChanging the shape of a material does not always create a new material.\n\nA folded sheet of paper is still paper.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 19 — REUSE ♻️",
          symbol: "",
          points: [],
          body:
              "Some objects can be used again instead of being thrown away.\n\nThis is called reuse.\n\nExamples:\n\n🫙 A clean jar may be reused for storage.\n\n📦 A box may be reused to hold objects.\n\n🎨 Clean safe materials may be reused for art projects.\n\nReusing objects can help reduce waste.\n\nAlways make sure reused objects are clean and safe.",
          reveal: false),
      NorieLessonSection(
          title: "SECTION 20 — RECYCLING ♻️",
          symbol: "",
          points: [],
          body:
              "Some materials can be collected and processed so they can be used again.\n\nThis is called recycling.\n\nMaterials that may be recyclable in some places include:\n\n📄 paper;\n\n🧴 some plastics;\n\n🔩 some metals;\n\n🪟 some glass.\n\nRecycling rules are different in different places.\n\nAlways follow local recycling instructions and adult guidance.\n\nFor Grade 1, remember:\n\n♻️ Recycling can help turn some used materials into useful materials again.",
          reveal: false),
      NorieLessonSection(
          title: "VISUAL 4 — REDUCE, REUSE, RECYCLE",
          symbol: "",
          points: [],
          visualType: "science-5-4",
          visualCaption:
              "We can make careful choices about the materials we use."),
      NorieLessonSection(
          title: "SECTION 21 — MATERIAL SAFETY ⚠️",
          symbol: "",
          points: [],
          body:
              "Science means observing carefully.\n\nIt also means staying safe.\n\nDo not:\n\n❌ touch broken glass;\n\n❌ touch sharp metal;\n\n❌ touch very hot objects;\n\n❌ taste unknown materials;\n\n❌ put unknown materials in your mouth.\n\nIf an object looks dangerous, ask a trusted adult for help.",
          reveal: false),
      NorieLessonSection(
          title: "ACTIVITY — WHAT MATERIAL IS IT? 🔎",
          symbol: "",
          points: [],
          body:
              "Look at these objects.\n\n\nWOODEN TABLE 🪵\n\nMaterial:\nWood\n\n\nMETAL SPOON 🥄\n\nMaterial:\nMetal\n\n\nGLASS WINDOW 🪟\n\nMaterial:\nGlass\n\n\nPAPER NOTEBOOK 📘\n\nMaterial:\nPaper\n\n\nCOTTON SHIRT 👕\n\nMaterial:\nFabric\n\n\nRUBBER BALL 🏀\n\nMaterial:\nRubber",
          reveal: false),
      NorieLessonSection(
          title: "MATERIAL SORTING ACTIVITY",
          symbol: "",
          points: [],
          visualType: "science-5-8",
          visualCaption: "Match each pictured object to its material."),
      NorieLessonSection(
          title: "ACTIVITY — WHICH PROPERTY? 🧠",
          symbol: "",
          points: [],
          body:
              "A BLANKET\n\nUseful property:\nSoft 🧸\n\n\nA WINDOW\n\nUseful property:\nTransparent 👀\n\n\nA RAINCOAT\n\nUseful property:\nWaterproof 💧\n\n\nA RUBBER BAND\n\nUseful property:\nFlexible ↪️\n\n\nA METAL TOOL\n\nUseful property:\nStrong 🔩",
          reveal: false),
      NorieLessonSection(
          title: "ACTIVITY — CHOOSE THE BETTER MATERIAL 🎯",
          symbol: "",
          points: [],
          body:
              "You want to make something that keeps rain off your head.\n\nWhich is better?\n\nPaper or waterproof material?\n\nBetter choice:\nWaterproof material 💧\n\n\nYou want to make a clear window.\n\nWhich is better?\n\nTransparent glass or wood?\n\nBetter choice:\nTransparent glass 🪟\n\n\nYou want a soft blanket.\n\nWhich is better?\n\nSoft fabric or hard metal?\n\nBetter choice:\nSoft fabric 🛏️",
          reveal: false),
      NorieLessonSection(
          title: "COMMON MISTAKES ⚠️",
          symbol: "",
          points: [],
          body:
              "MISTAKE 1:\n\n\"Every object is made from only one material.\"\n\n❌ Not true.\n\nMany objects contain several materials.\n\n\nMISTAKE 2:\n\n\"Every plastic object has the same properties.\"\n\n❌ Not true.\n\nSome plastics are hard.\n\nOthers are flexible.\n\n\nMISTAKE 3:\n\n\"Glass is always the best material for everything.\"\n\n❌ Not true.\n\nGlass is useful for some purposes, but it can break.\n\nDifferent jobs need different materials.\n\n\nMISTAKE 4:\n\n\"Soft materials are weak and useless.\"\n\n❌ Not true.\n\nSoft materials are useful for things such as clothing, blankets, cushions, and other objects.\n\n\nMISTAKE 5:\n\n\"Any material can be used safely for any job.\"\n\n❌ Not true.\n\nMaterials are chosen because their properties fit the purpose.",
          reveal: false),
      NorieLessonSection(
          title: "QUICK CHECK 🧠",
          symbol: "",
          points: [],
          body:
              "1. WHAT MATERIAL IS A METAL SPOON MADE FROM?\n\nAnswer:\nMetal 🔩\n\nWhy?\nMetal is hard and strong, making it useful for many utensils.\n\n\n2. WHICH PROPERTY IS USEFUL FOR A WINDOW?\n\nAnswer:\nTransparent 👀\n\nWhy?\nA transparent material lets us see through it.\n\n\n3. WHICH MATERIAL IS OFTEN FLEXIBLE AND USED FOR TIRES?\n\nAnswer:\nRubber 🟠\n\nWhy?\nRubber can bend and provide grip.\n\n\n4. WHY IS PAPER NOT A GOOD MATERIAL FOR AN UMBRELLA?\n\nAnswer:\nIt can absorb water. 💧\n\nWhy?\nWet paper can become weak.\n\n\n5. CAN ONE OBJECT BE MADE FROM MORE THAN ONE MATERIAL?\n\nAnswer:\nYes ✅\n\nWhy?\nMany objects combine different materials for different jobs.",
          reveal: true),
      NorieLessonSection(
          title: "KEY CONCEPT ⭐",
          symbol: "",
          points: [],
          body:
              "TITLE:\n\nDifferent materials have different properties.\n\nBODY:\n\nObjects are made from materials such as wood, metal, plastic, glass, paper, fabric, and rubber.\n\nMaterials can be hard, soft, smooth, rough, flexible, waterproof, absorbent, transparent, or opaque.\n\nWe choose materials based on what we need an object to do.",
          reveal: false),
      NorieLessonSection(
          title: "FINAL RECAP 🌟",
          symbol: "",
          points: [],
          body:
              "Remember:\n\n🪵 Wood is used for many strong objects.\n\n🔩 Metal is often hard and strong.\n\n🧴 Plastic can be light, waterproof, hard, or flexible.\n\n🪟 Glass can be transparent but can break.\n\n📄 Paper is light and easy to fold.\n\n👕 Fabric can be soft and flexible.\n\n🟠 Rubber can be flexible and grippy.\n\n🔎 Properties help us compare materials.\n\n🎯 We choose materials based on their purpose.\n\n♻️ Some objects and materials can be reused or recycled.\n\n⚠️ Always handle materials safely.",
          reveal: false),
    ],
  ),
  quiz: NorieQuizContent(questions: materialsQuestions(mastery: false)),
  challenge: NorieChallengeContent(
    title: 'Materials Around Us 🪵🧱 Mastery',
    description: 'Use what you learned in three new situations.',
    rounds: materialsQuestions(mastery: true),
  ),
);
