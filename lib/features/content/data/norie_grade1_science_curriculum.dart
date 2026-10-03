import '../domain/norie_content_models.dart';
import 'norie_grade1_science_questions.dart';
import 'norie_grade1_materials_lesson.dart';

abstract final class NorieGrade1ScienceCurriculum {
  static NorieTopicContent topic(int order) => topics[order - 1];
  static final topics = <NorieTopicContent>[
    NorieTopicContent(
        id: "science.g1.living-nonliving-things",
        subject: "Science",
        category: "Grade 1",
        gradeLevel: "g1",
        title: "Living & Nonliving Things 🌱",
        subtitle:
            "Learn how to tell whether something is living or nonliving by looking for signs of life.",
        order: 1,
        accent: "green",
        visualType: "g1-science",
        prerequisiteTopicId: null,
        lesson: const NorieLessonContent(
            heading: "Living & Nonliving Things 🌱",
            introduction:
                "Learn how to tell whether something is living or nonliving by looking for signs of life.\n20–25 minutes",
            keyConceptTitle: "",
            keyConceptBody: "",
            sections: [
              NorieLessonSection(
                  title: "LEARNING GOALS 🎯",
                  symbol: "",
                  points: [],
                  body:
                      "By the end of this lesson, the learner should be able to:\n\n• Identify common living and nonliving things.\n• Describe simple signs that show something is living.\n• Explain that living things need resources such as water and energy.\n• Recognize that living things grow and change.\n• Use evidence to decide whether something is living or nonliving.",
                  reveal: false),
              NorieLessonSection(
                  title: "OPENING — LOOK AROUND YOU 👀",
                  symbol: "",
                  points: [],
                  body:
                      "Look around you.\n\nYou might see a person, a plant, a pet, a chair, a pencil, a rock, or a toy.\n\nSome of these are living things.\nOthers are nonliving things.\n\nA dog is living. 🐕\nA tree is living. 🌳\nYou are living. 🧒\n\nA rock is nonliving. 🪨\nA chair is nonliving. 🪑\nA toy car is nonliving. 🚗\n\nSometimes the answer seems easy.\n\nBut what about a seed that is not moving?\nWhat about a robot that can walk?\nWhat about a wooden table that came from a tree?\n\nTo answer correctly, we need to look for signs of life.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 1 — WHAT IS A LIVING THING? 🌱",
                  symbol: "",
                  points: [],
                  body:
                      "A living thing is something that carries out the processes of life.\n\nPeople, animals, and plants are living things.\n\nLiving things have several important characteristics.\n\nLiving things:\n\n💧 need resources such as water;\n⚡ need energy;\n🌱 grow and change;\n👀 respond to things around them;\n🐣 come from other living things of their kind.\n\nWe should not use only one clue.\n\nInstead, we look for several signs of life together.\n\nEXAMPLE: A PUPPY 🐶\n\nThink about a puppy.\n\nA puppy drinks water.\n\nIt eats food to get energy.\n\nIt grows bigger.\n\nIt reacts when it hears a sound.\n\nIt grows into an adult dog.\n\nThese are signs that the puppy is living.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 1 — LIVING OR NONLIVING?",
                  symbol: "",
                  points: [],
                  visualType: "science-1-1",
                  visualCaption:
                      "Living things show signs of life. Nonliving things do not."),
              NorieLessonSection(
                  title: "SECTION 2 — LIVING THINGS NEED RESOURCES 💧",
                  symbol: "",
                  points: [],
                  body:
                      "Living things need things from their surroundings in order to live.\n\nDifferent living things have different needs, but many need water, air, energy, and a suitable place to live.\n\nWATER 💧\n\nPeople need water.\n\nAnimals need water.\n\nPlants need water too.\n\nWithout enough water, living things may not stay healthy.\n\nAIR 🌬️\n\nPeople and many animals take oxygen from the air.\n\nPlants also exchange gases with their surroundings.\n\nAir is part of the environment that supports life.\n\nENERGY ⚡\n\nLiving things need energy.\n\nAnimals get energy from food. 🍎\n\nPlants use light energy to make sugars they can use. ☀️🌱\n\nFor Grade 1, remember:\n\n\"Animals eat food. Plants use light to help make their food.\"\n\nA PLACE TO LIVE 🏡\n\nLiving things need a place where their needs can be met.\n\nA fish lives in water. 🐟\n\nA bird may live in a nest. 🐦\n\nA cactus can live in a dry place. 🌵\n\nDifferent living things can live in different environments.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 2 — WHAT LIVING THINGS NEED",
                  symbol: "",
                  points: [],
                  visualType: "science-1-2",
                  visualCaption:
                      "Living things depend on resources from their environment."),
              NorieLessonSection(
                  title: "SECTION 3 — LIVING THINGS GROW AND CHANGE 🌱➡️🌻",
                  symbol: "",
                  points: [],
                  body:
                      "Living things do not stay exactly the same throughout their lives.\n\nThey grow and develop.\n\nThink about a plant.\n\nIt may begin as a seed.\n\nSTEP 1:\nA seed begins to germinate when conditions are suitable.\n\nSTEP 2:\nA tiny root and shoot begin to grow.\n\nSTEP 3:\nLeaves begin to develop.\n\nSTEP 4:\nThe plant becomes larger and more mature.\n\nA living thing grows because of processes happening inside its body.\n\nA PERSON GROWS TOO 🧒➡️🧑\n\nA baby grows into a child.\n\nA child grows into an adult.\n\nThe person remains the same living organism while growing and developing.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 3 — PLANT GROWTH SEQUENCE",
                  symbol: "",
                  points: [],
                  visualType: "science-1-3",
                  visualCaption:
                      "Living things grow and change during their lives."),
              NorieLessonSection(
                  title: "SECTION 4 — LIVING THINGS RESPOND 👂👀",
                  symbol: "",
                  points: [],
                  body:
                      "Living things can respond to changes around them.\n\nThis means they can react to their environment.\n\nANIMALS 🐕\n\nA dog may turn its head when it hears its name.\n\nA bird may fly away when it senses danger.\n\nA person may pull a hand away from something very hot.\n\nThese are responses.\n\nPLANTS 🌻\n\nPlants respond too.\n\nTheir responses may be slower than an animal's movements.\n\nFor example, many plant shoots grow toward light.\n\nPlants do not need to walk or run to be alive.\n\n💡 REMEMBER:\n\n\"Not all living things move from place to place.\"",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 5 — MOVEMENT DOES NOT ALWAYS MEAN LIFE 🚗",
                  symbol: "",
                  points: [],
                  body:
                      "This is an important idea.\n\nA car can move.\n\nA fan can spin.\n\nA robot can walk.\n\nA cloud can move through the sky.\n\nBut these things are not living just because they move.\n\nA toy car moves because a motor or a person makes it move.\n\nA real dog moves because it is a living organism.\n\nSo this rule is wrong:\n\n❌ \"If it moves, it is alive.\"\n\nA better rule is:\n\n✅ \"Look for several signs of life.\"",
                  reveal: false),
              NorieLessonSection(
                  title: "WORKED EXAMPLE — IS A TOY ROBOT ALIVE? 🤖",
                  symbol: "",
                  points: [],
                  body:
                      "A toy robot can walk and make sounds.\n\nDoes that make it alive?\n\nLet's check.\n\nSTEP 1:\nDoes the robot grow through biological growth?\n\nNo.\n\nSTEP 2:\nDoes the robot need food and water because it is alive?\n\nNo.\n\nSTEP 3:\nDoes it carry out life processes by itself?\n\nNo.\n\nSTEP 4:\nWhy does it move?\n\nIts machine parts, battery, or motor make it move.\n\nCONCLUSION:\n\nThe robot is nonliving.\n\n⭐ Movement alone does not prove that something is alive.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 6 — SOME LIVING THINGS LOOK STILL 🌰",
                  symbol: "",
                  points: [],
                  body:
                      "Something does not have to be moving all the time to be alive.\n\nThink about a sleeping cat. 🐈💤\n\nThe cat may look very still.\n\nBut it is still breathing and using energy.\n\nIt is still alive.\n\nNow think about a seed. 🌰\n\nA seed may look dry and still.\n\nBut under suitable conditions, it can germinate and grow into a plant.\n\nSo this rule is also wrong:\n\n❌ \"If it is not moving, it is not alive.\"",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 7 — WHAT IS NONLIVING? 🪨",
                  symbol: "",
                  points: [],
                  body:
                      "A nonliving thing does not carry out the processes of life.\n\nExamples include:\n\n🪨 rocks\n💧 water\n🌬️ air\n🪑 chairs\n✏️ pencils\n🧸 toys\n🥤 cups\n🚲 bicycles\n\nNonliving things can still change.\n\nIce can melt. 🧊➡️💧\n\nA rock can break.\n\nMetal can rust.\n\nA balloon can get bigger when air is blown into it. 🎈\n\nBut these changes are not biological growth.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 8 — THINGS THAT WERE ONCE LIVING 🌳➡️🪑",
                  symbol: "",
                  points: [],
                  body:
                      "Some nonliving things are made from materials that once came from living things.\n\nThink about wood.\n\nA tree is living. 🌳\n\nA wooden table is not living. 🪑\n\nThe wood came from a living tree, but the table does not carry out life processes.\n\nPaper is another example.\n\nPaper can be made from plant material.\n\nA sheet of paper is nonliving now. 📄\n\nFor this lesson, remember:\n\nLIVING:\nalive now\n\nONCE LIVING:\ncame from something that was alive\n\nNEVER LIVING:\nwas never an organism\n\nBoth once-living and never-living objects are nonliving now.",
                  reveal: false),
              NorieLessonSection(
                  title: "GUIDED EXAMPLE — IS A TREE LIVING? 🌳",
                  symbol: "",
                  points: [],
                  body:
                      "Let's investigate.\n\nQUESTION 1:\nDoes a tree need resources?\n\nYes. ✅\n\nIt needs water, gases from the air, light, and nutrients.\n\nQUESTION 2:\nDoes a tree grow?\n\nYes. ✅\n\nA young tree can grow taller and develop more branches.\n\nQUESTION 3:\nDoes it respond to its surroundings?\n\nYes. ✅\n\nPlants respond to environmental conditions such as light.\n\nQUESTION 4:\nDoes it have a life cycle?\n\nYes. ✅\n\nNew plants can develop from seeds or through other reproductive processes.\n\nCONCLUSION:\n\n🌳 A tree is a living thing.",
                  reveal: false),
              NorieLessonSection(
                  title: "ACTIVITY — SORT THE OBJECTS 🧠",
                  symbol: "",
                  points: [],
                  body:
                      "Look at these objects:\n\n🐈 Cat\n🌻 Sunflower\n🪨 Rock\n🚲 Bicycle\n🐟 Fish\n🧸 Teddy bear\n\nSort them.\n\nLIVING 🌱\n\n🐈 Cat\n🌻 Sunflower\n🐟 Fish\n\nNONLIVING 📦\n\n🪨 Rock\n🚲 Bicycle\n🧸 Teddy bear\n\nNow ask:\n\n\"What evidence helped you decide?\"\n\nA strong answer should mention signs of life such as:\n\n• growth;\n• needing resources;\n• responding to surroundings;\n• having a life cycle.\n\nDo not use only:\n\n\"It moves.\"",
                  reveal: false),
              NorieLessonSection(
                  title: "Picture guide",
                  symbol: "",
                  points: [],
                  visualType: "science-1-sort"),
              NorieLessonSection(
                  title: "COMMON MISTAKES ⚠️",
                  symbol: "",
                  points: [],
                  body:
                      "MISTAKE 1:\n\n\"If something moves, it must be living.\"\n\n❌ Not true.\n\nCars, fans, and robots can move but are nonliving.\n\n\nMISTAKE 2:\n\n\"Plants are not living because they cannot walk.\"\n\n❌ Not true.\n\nPlants grow, use resources, respond to their surroundings, and have life cycles.\n\n\nMISTAKE 3:\n\n\"If something gets bigger, it must be growing.\"\n\n❌ Not always.\n\nA balloon gets bigger when air is added.\n\nThat is not biological growth.\n\n\nMISTAKE 4:\n\n\"If something is still, it is nonliving.\"\n\n❌ Not true.\n\nA sleeping animal is still alive.\n\nA seed may also be alive even when it looks inactive.",
                  reveal: false),
              NorieLessonSection(
                  title: "QUICK CHECK 🧠",
                  symbol: "",
                  points: [],
                  body:
                      "Think about each item before revealing the answer.\n\n1. DOG 🐕\nLiving or nonliving?\n\nAnswer:\nLiving\n\nWhy?\nIt grows, needs resources, responds, and has a life cycle.\n\n\n2. ROCK 🪨\nLiving or nonliving?\n\nAnswer:\nNonliving\n\nWhy?\nIt does not carry out life processes.\n\n\n3. PLANT 🌱\nLiving or nonliving?\n\nAnswer:\nLiving\n\nWhy?\nIt grows, needs resources, and responds to its environment.\n\n\n4. TOY CAR 🚗\nLiving or nonliving?\n\nAnswer:\nNonliving\n\nWhy?\nMovement from a motor does not make it alive.",
                  reveal: true),
              NorieLessonSection(
                  title: "KEY CONCEPT ⭐",
                  symbol: "",
                  points: [],
                  body:
                      "TITLE:\n\nLiving things show signs of life.\n\nBODY:\n\nLiving things need resources, grow and develop, respond to their surroundings, and have life cycles.\n\nDo not decide whether something is living by using only one clue.\n\nLook for several signs of life together.",
                  reveal: false),
              NorieLessonSection(
                  title: "FINAL RECAP 🌟",
                  symbol: "",
                  points: [],
                  body:
                      "Before leaving the lesson, remember:\n\n🌱 Plants and animals are living things.\n\n💧 Living things need resources.\n\n📈 Living things grow and change.\n\n👀 Living things respond to their surroundings.\n\n🚗 Something can move and still be nonliving.\n\n💤 Something can look still and still be alive.\n\n🧠 Use several clues before deciding.",
                  reveal: false),
            ]),
        quiz: NorieQuizContent(questions: scienceQuestions(1, mastery: false)),
        challenge: NorieChallengeContent(
            title: "Living & Nonliving Things 🌱 Mastery",
            description: "Use what you learned in three new situations.",
            rounds: scienceQuestions(1, mastery: true))),
    NorieTopicContent(
        id: "science.g1.plants-animals",
        subject: "Science",
        category: "Grade 1",
        gradeLevel: "g1",
        title: "Plants & Animals 🌿🐾",
        subtitle:
            "Discover how plants and animals are alike, how they are different, and what they need to live.",
        order: 2,
        accent: "green",
        visualType: "g1-science",
        prerequisiteTopicId: "science.g1.living-nonliving-things",
        lesson: const NorieLessonContent(
            heading: "Plants & Animals 🌿🐾",
            introduction:
                "Discover how plants and animals are alike, how they are different, and what they need to live.\n20–25 minutes",
            keyConceptTitle: "",
            keyConceptBody: "",
            sections: [
              NorieLessonSection(
                  title: "LEARNING GOALS 🎯",
                  symbol: "",
                  points: [],
                  body:
                      "By the end of this lesson, the learner should be able to:\n\n• Identify plants and animals as living things.\n• Describe basic needs shared by plants and animals.\n• Recognize important parts of common plants and animals.\n• Explain simple differences between plants and animals.\n• Match plants and animals to places where they can live.",
                  reveal: false),
              NorieLessonSection(
                  title: "OPENING — TWO KINDS OF LIVING THINGS 🌱🐕",
                  symbol: "",
                  points: [],
                  body:
                      "In Lesson 1, we learned that living things grow, need resources, respond to their surroundings, and have life cycles.\n\nNow let's look more closely at two important groups of living things:\n\n🌿 Plants\n\nand\n\n🐾 Animals\n\nPlants and animals can look very different.\n\nA sunflower does not look like a puppy.\n\nA fish does not look like a tree.\n\nBut plants and animals are both living things.\n\nThey both need resources from their environment.\n\nThey both grow and change.\n\nThey both have parts that help them live.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 1 — WHAT IS A PLANT? 🌱",
                  symbol: "",
                  points: [],
                  body:
                      "A plant is a living thing.\n\nPlants come in many shapes and sizes.\n\nSome are tiny.\n\nSome grow into very tall trees. 🌳\n\nExamples of plants include:\n\n🌻 Sunflowers\n🌳 Trees\n🌵 Cacti\n🌾 Grass\n🌿 Ferns\n🌹 Roses\n\nMost plants stay rooted in one place.\n\nBut staying in one place does NOT mean they are nonliving.\n\nPlants grow, use resources, respond to their surroundings, and have life cycles.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 1 — MANY KINDS OF PLANTS",
                  symbol: "",
                  points: [],
                  visualType: "science-2-1",
                  visualCaption:
                      "Plants can look different, but they are all living things."),
              NorieLessonSection(
                  title: "SECTION 2 — BASIC PARTS OF A PLANT 🌱",
                  symbol: "",
                  points: [],
                  body:
                      "Plants have parts that help them survive.\n\nLet's learn four important parts.\n\nROOTS\n\nRoots are usually found under the ground.\n\nRoots help:\n\n• hold the plant in place;\n• take in water;\n• take in minerals from the soil.\n\nThink of roots as the plant's underground support system.\n\nSTEM\n\nThe stem helps hold the plant upright.\n\nIt also helps move water and other materials through the plant.\n\nSome stems are soft and green.\n\nTree trunks are also stems.\n\nLEAVES 🍃\n\nLeaves help the plant make food using light energy.\n\nMany leaves are green.\n\nLeaves also exchange gases with the air.\n\nFLOWERS 🌸\n\nMany plants produce flowers.\n\nFlowers can help plants make seeds.\n\nNot every plant has obvious flowers, but many familiar plants do.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 2 — PARTS OF A PLANT",
                  symbol: "",
                  points: [],
                  visualType: "science-2-2",
                  visualCaption: "Different plant parts have different jobs."),
              NorieLessonSection(
                  title: "SECTION 3 — WHAT DO PLANTS NEED? ☀️💧",
                  symbol: "",
                  points: [],
                  body:
                      "Plants need resources to live and grow.\n\nMany plants need:\n\n☀️ light\n\n💧 water\n\n🌬️ air\n\n🌱 nutrients\n\n🏡 enough space and a suitable place to grow\n\nPlants use light energy to help make sugars they can use for energy and growth.\n\nRoots take in water and minerals.\n\nLeaves help the plant capture light.\n\nEXAMPLE 🌻\n\nImagine a sunflower growing outside.\n\nIt receives light from the Sun.\n\nIts roots take in water.\n\nIts leaves capture light.\n\nIts stem supports the plant.\n\nTogether, these parts help the sunflower live and grow.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 4 — WHAT IS AN ANIMAL? 🐾",
                  symbol: "",
                  points: [],
                  body:
                      "An animal is also a living thing.\n\nAnimals come in many shapes and sizes.\n\nExamples include:\n\n🐕 Dog\n🐈 Cat\n🐦 Bird\n🐟 Fish\n🦋 Butterfly\n🐘 Elephant\n🐸 Frog\n\nAnimals usually move from place to place during at least part of their lives.\n\nAnimals get energy by eating food.\n\nDifferent animals eat different things.\n\nSome eat plants.\n\nSome eat other animals.\n\nSome eat both.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 3 — MANY KINDS OF ANIMALS",
                  symbol: "",
                  points: [],
                  visualType: "science-2-3",
                  visualCaption:
                      "Animals can look very different, but they are all living things."),
              NorieLessonSection(
                  title: "SECTION 5 — ANIMAL BODY PARTS 🐕",
                  symbol: "",
                  points: [],
                  body:
                      "Animals have body parts that help them survive.\n\nDifferent animals have different parts.\n\nLEGS 🐾\n\nMany animals use legs to:\n\n• walk;\n• run;\n• jump;\n• climb.\n\nDogs, cats, frogs, and many other animals have legs.\n\nWINGS 🪽\n\nMany birds and insects have wings.\n\nWings can help some animals fly.\n\nFINS 🐟\n\nFish use fins to help them move and steer through water.\n\nEYES 👀\n\nEyes help many animals see their surroundings.\n\nEARS 👂\n\nEars help many animals detect sounds.\n\nNot every animal has ears that look like ours.\n\nMOUTHS OR BEAKS\n\nAnimals use mouths or beaks to take in food.\n\nA bird may use its beak.\n\nA dog uses its mouth.",
                  reveal: false),
              NorieLessonSection(
                  title:
                      "SECTION 6 — DIFFERENT PARTS FOR DIFFERENT ANIMALS 🐟🦅🐸",
                  symbol: "",
                  points: [],
                  body:
                      "Animal bodies are not all the same.\n\nDifferent body parts can help animals live in different places.\n\nA fish has fins that help it swim. 🐟\n\nA bird has wings that may help it fly. 🐦\n\nA frog has strong back legs that help it jump. 🐸\n\nA duck has webbed feet that help it move through water. 🦆\n\n💡 IMPORTANT:\n\nAnimals do not need to have the same body parts to be animals.\n\nDifferent animals have different structures that help them survive.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 4 — ANIMAL PARTS AND THEIR JOBS",
                  symbol: "",
                  points: [],
                  visualType: "science-2-4",
                  visualCaption:
                      "Animal body parts help animals move and survive."),
              NorieLessonSection(
                  title: "SECTION 7 — WHAT DO ANIMALS NEED? 💧🍎",
                  symbol: "",
                  points: [],
                  body:
                      "Animals need resources too.\n\nMost animals need:\n\n💧 water\n\n🌬️ air\n\n🍎 food\n\n🏡 shelter or a safe place\n\n🌿 enough space to live\n\nDifferent animals need different kinds of food and habitats.\n\nA rabbit may eat plants. 🐇\n\nA lion eats other animals. 🦁\n\nA bear may eat both plants and animals. 🐻\n\nFor Grade 1, remember:\n\n\"Animals get energy by eating food.\"",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 8 — PLANTS AND ANIMALS ARE ALIKE 🤝",
                  symbol: "",
                  points: [],
                  body:
                      "Plants and animals are different, but they also have things in common.\n\nBoth are living things.\n\nBoth:\n\n💧 need water;\n\n⚡ need energy;\n\n🌱 grow and change;\n\n🌬️ interact with their environment;\n\n🐣 have life cycles.\n\nThis means a tree and a dog may look very different, but both show signs of life.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 5 — PLANTS AND ANIMALS: WHAT THEY SHARE",
                  symbol: "",
                  points: [],
                  visualType: "science-2-5",
                  visualCaption: ""),
              NorieLessonSection(
                  title:
                      "SECTION 9 — HOW ARE PLANTS AND ANIMALS DIFFERENT? 🌿 VS 🐕",
                  symbol: "",
                  points: [],
                  body:
                      "Plants and animals have some important differences.\n\nPLANTS\n\nMost plants stay rooted in one place.\n\nPlants use light energy to help make their own food.\n\nPlants often have:\n\n🌿 roots\n🌱 stems\n🍃 leaves\n🌸 flowers\n\nANIMALS\n\nAnimals get energy by eating food.\n\nMany animals can move from place to place.\n\nAnimals can have:\n\n🐾 legs\n🪽 wings\n🐟 fins\n👀 eyes\n👂 ears\n🦷 teeth or beaks\n\nDifferent animals may have different body parts.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 10 — WHERE DO PLANTS AND ANIMALS LIVE? 🏡",
                  symbol: "",
                  points: [],
                  body:
                      "A habitat is a place where a living thing lives and gets what it needs.\n\nDifferent living things live in different habitats.\n\nFOREST 🌳\n\nForests may contain:\n\n🌳 trees\n🐦 birds\n🦌 deer\n🐿️ squirrels\n\nPOND OR LAKE 💧\n\nFreshwater habitats may contain:\n\n🐟 fish\n🐸 frogs\n🌿 water plants\n\nGRASSLAND 🌾\n\nGrasslands may contain:\n\n🌾 grasses\n🐇 rabbits\n🦋 insects\n🐦 birds\n\nGARDEN 🌻\n\nGardens may contain:\n\n🌻 flowers\n🌿 vegetables\n🐝 bees\n🦋 butterflies\n\nA habitat provides resources that living things need.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 6 — MATCH THE HABITAT",
                  symbol: "",
                  points: [],
                  visualType: "science-2-6",
                  visualCaption:
                      "Living things live where they can find the resources they need."),
              NorieLessonSection(
                  title:
                      "SECTION 11 — STEP-BY-STEP: IS IT A PLANT OR AN ANIMAL? 🧠",
                  symbol: "",
                  points: [],
                  body:
                      "Suppose we see a sunflower.\n\nHow can we classify it?\n\nSTEP 1:\nLook at its parts.\n\nIt has roots, a stem, leaves, and a flower.\n\nSTEP 2:\nAsk how it gets energy.\n\nIt uses light energy to help make food.\n\nSTEP 3:\nAsk whether it is rooted in place.\n\nYes.\n\nCONCLUSION:\n\n🌻 A sunflower is a plant.\n\n\nNow think about a rabbit.\n\nSTEP 1:\nLook at its body.\n\nIt has legs, eyes, ears, and a mouth.\n\nSTEP 2:\nAsk how it gets energy.\n\nIt eats food.\n\nSTEP 3:\nAsk how it moves.\n\nIt can hop and move from place to place.\n\nCONCLUSION:\n\n🐇 A rabbit is an animal.",
                  reveal: false),
              NorieLessonSection(
                  title: "WORKED EXAMPLE — PLANT OR ANIMAL? 🦋",
                  symbol: "",
                  points: [],
                  body:
                      "We see a butterfly.\n\nLet's investigate.\n\nSTEP 1:\nDoes it have roots and leaves?\n\nNo.\n\nSTEP 2:\nDoes it eat or take in food?\n\nYes.\n\nSTEP 3:\nCan it move from place to place?\n\nYes.\n\nSTEP 4:\nDoes it have animal body parts?\n\nYes.\n\nIt has wings, legs, eyes, and other animal structures.\n\nCONCLUSION:\n\n🦋 A butterfly is an animal.",
                  reveal: false),
              NorieLessonSection(
                  title: "GUIDED EXAMPLE — WHAT DOES THIS PLANT PART DO? 🍃",
                  symbol: "",
                  points: [],
                  body:
                      "Suppose we look at a leaf.\n\nWhat is one important job of a leaf?\n\nA leaf helps the plant capture light.\n\nPlants use light energy to help make food.\n\nSo:\n\n🍃 Leaf → helps capture light for the plant.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 12 — BABY AND ADULT ANIMALS 🐣➡️🐔",
                  symbol: "",
                  points: [],
                  body:
                      "Animals grow and change during their lives.\n\nA baby animal may look similar to its adult form.\n\nA puppy grows into an adult dog. 🐶➡️🐕\n\nA kitten grows into an adult cat. 🐱➡️🐈\n\nSome animals change more dramatically.\n\nA caterpillar can become a butterfly. 🐛➡️🦋\n\nA tadpole can grow into a frog. 🐸\n\nThese changes are part of an animal's life cycle.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 13 — PLANTS HAVE LIFE CYCLES TOO 🌱",
                  symbol: "",
                  points: [],
                  body:
                      "Plants also have life cycles.\n\nA simple flowering plant life cycle may look like:\n\nSeed 🌰\n↓\n\nSprout 🌱\n↓\n\nYoung Plant 🪴\n↓\n\nAdult Plant 🌻\n↓\n\nSeeds\n\nThen the cycle can begin again.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 7 — TWO SIMPLE LIFE CYCLES",
                  symbol: "",
                  points: [],
                  visualType: "science-2-7",
                  visualCaption:
                      "Plants and animals grow and change during their life cycles."),
              NorieLessonSection(
                  title:
                      "SECTION 14 — HOW PLANTS AND ANIMALS CAN HELP EACH OTHER 🌻🐝",
                  symbol: "",
                  points: [],
                  body:
                      "Plants and animals often share the same environment.\n\nSometimes they can help each other.\n\nFor example:\n\n🐝 A bee may visit a flower to collect nectar.\n\n🌸 While visiting flowers, bees can help move pollen from flower to flower.\n\n🐦 Some animals eat fruits and can carry seeds to new places.\n\n🌳 Plants can provide food and shelter for animals.\n\nLiving things are connected to their environments and to other living things.\n\nFor Grade 1, remember:\n\n\"Plants and animals can depend on each other.\"",
                  reveal: false),
              NorieLessonSection(
                  title: "COMMON MISTAKES ⚠️",
                  symbol: "",
                  points: [],
                  body:
                      "MISTAKE 1:\n\n\"Plants are not living because they do not walk.\"\n\n❌ Not true.\n\nPlants grow, use resources, respond, and have life cycles.\n\n\nMISTAKE 2:\n\n\"All animals have four legs.\"\n\n❌ Not true.\n\nBirds, fish, insects, snakes, and many other animals have different body structures.\n\n\nMISTAKE 3:\n\n\"Plants get food by eating like animals.\"\n\n❌ Not true.\n\nPlants use light energy, water, and gases to help make sugars they can use.\n\n\nMISTAKE 4:\n\n\"Every animal lives on land.\"\n\n❌ Not true.\n\nFish and many other animals live in water.\n\n\nMISTAKE 5:\n\n\"Every plant has a flower.\"\n\n❌ Not true.\n\nMany plants have flowers, but not all plants produce obvious flowers.",
                  reveal: false),
              NorieLessonSection(
                  title: "ACTIVITY — PLANT OR ANIMAL? 🌿🐾",
                  symbol: "",
                  points: [],
                  body:
                      "Look at each example.\n\n🌻 Sunflower\n🐕 Dog\n🌳 Tree\n🐟 Fish\n🌵 Cactus\n🦋 Butterfly\n\nSort them.\n\nPLANTS 🌿\n\n🌻 Sunflower\n🌳 Tree\n🌵 Cactus\n\nANIMALS 🐾\n\n🐕 Dog\n🐟 Fish\n🦋 Butterfly\n\nNow ask:\n\n\"What clues helped you decide?\"\n\nGood clues include:\n\n• plant parts;\n• animal body parts;\n• how the organism gets energy;\n• how it moves;\n• where it lives.",
                  reveal: false),
              NorieLessonSection(
                  title: "Picture guide",
                  symbol: "",
                  points: [],
                  visualType: "science-2-sort"),
              NorieLessonSection(
                  title: "ACTIVITY — MATCH THE PART TO ITS JOB 🔎",
                  symbol: "",
                  points: [],
                  body:
                      "ROOTS 🌿\n→ take in water and help hold a plant in place\n\nLEAVES 🍃\n→ help capture light\n\nSTEM 🌱\n→ supports the plant and helps move materials\n\nFINS 🐟\n→ help a fish swim\n\nWINGS 🪽\n→ help many birds and insects move through the air\n\nLEGS 🐾\n→ help many animals walk, run, jump, or climb",
                  reveal: false),
              NorieLessonSection(
                  title: "QUICK CHECK 🧠",
                  symbol: "",
                  points: [],
                  body:
                      "1. SUNFLOWER 🌻\n\nPlant or animal?\n\nAnswer:\nPlant\n\nWhy?\nIt has plant structures such as roots, a stem, leaves, and a flower.\n\n\n2. FISH 🐟\n\nPlant or animal?\n\nAnswer:\nAnimal\n\nWhy?\nIt eats food and has animal body structures such as fins.\n\n\n3. ROOT 🌿\n\nWhat kind of living thing has roots?\n\nAnswer:\nPlant\n\nWhy?\nRoots are important plant structures.\n\n\n4. WING 🪽\n\nWhich group often has animals with wings?\n\nAnswer:\nAnimals\n\nWhy?\nBirds and many insects use wings.\n\n\n5. DO PLANTS AND ANIMALS BOTH NEED WATER? 💧\n\nAnswer:\nYes\n\nWhy?\nWater is an important resource for both plants and animals.",
                  reveal: true),
              NorieLessonSection(
                  title: "KEY CONCEPT ⭐",
                  symbol: "",
                  points: [],
                  body:
                      "TITLE:\n\nPlants and animals are different kinds of living things.\n\nBODY:\n\nPlants and animals both need resources, grow, respond to their environments, and have life cycles.\n\nPlants often have roots, stems, and leaves and use light to help make food.\n\nAnimals eat food and have body parts that help them move, sense, and survive.",
                  reveal: false),
              NorieLessonSection(
                  title: "FINAL RECAP 🌟",
                  symbol: "",
                  points: [],
                  body:
                      "Remember:\n\n🌿 Plants are living things.\n\n🐾 Animals are living things.\n\n💧 Both need resources such as water.\n\n🌱 Both grow and change.\n\n🍃 Plants have parts such as roots, stems, and leaves.\n\n🐟 Animals can have parts such as legs, wings, fins, eyes, and ears.\n\n☀️ Plants use light energy to help make food.\n\n🍎 Animals get energy by eating food.\n\n🏡 Plants and animals live in habitats where they can get what they need.\n\n🐣 Both have life cycles.",
                  reveal: false),
            ]),
        quiz: NorieQuizContent(questions: scienceQuestions(2, mastery: false)),
        challenge: NorieChallengeContent(
            title: "Plants & Animals 🌿🐾 Mastery",
            description: "Use what you learned in three new situations.",
            rounds: scienceQuestions(2, mastery: true))),
    NorieTopicContent(
        id: "science.g1.our-body-senses",
        subject: "Science",
        category: "Grade 1",
        gradeLevel: "g1",
        title: "Our Body & Senses 👀👂",
        subtitle:
            "Learn how body parts help us move, explore, and understand the world around us.",
        order: 3,
        accent: "green",
        visualType: "g1-science",
        prerequisiteTopicId: "science.g1.plants-animals",
        lesson: const NorieLessonContent(
            heading: "Our Body & Senses 👀👂",
            introduction:
                "Learn how body parts help us move, explore, and understand the world around us.\n20–25 minutes",
            keyConceptTitle: "",
            keyConceptBody: "",
            sections: [
              NorieLessonSection(
                  title: "LEARNING GOALS 🎯",
                  symbol: "",
                  points: [],
                  body:
                      "By the end of this lesson, the learner should be able to:\n\n• Name important external body parts.\n• Explain simple jobs of different body parts.\n• Identify the five commonly taught senses.\n• Match each sense with the body part mainly used for it.\n• Describe how our senses help us learn about our surroundings.\n• Explain simple ways to protect important sense organs.",
                  reveal: false),
              NorieLessonSection(
                  title: "OPENING — YOUR AMAZING BODY 🧒",
                  symbol: "",
                  points: [],
                  body:
                      "Your body has many different parts.\n\nSome body parts help you move.\n\nSome help you hold things.\n\nSome help you eat.\n\nSome help you see, hear, smell, taste, and feel.\n\nYour body parts work together every day.\n\nThink about what happens when you see a ball and catch it. ⚽\n\nYour eyes see the ball.\n\nYour brain helps you understand where it is.\n\nYour arms and hands move.\n\nYour fingers help you hold it.\n\nSeveral parts of your body worked together!\n\nIn this lesson, we will learn about:\n\n🧍 body parts\n\n👀 sight\n\n👂 hearing\n\n👃 smell\n\n👅 taste\n\n✋ touch",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 1 — IMPORTANT BODY PARTS 🧍",
                  symbol: "",
                  points: [],
                  body:
                      "Our bodies have many parts.\n\nEach part can have one or more important jobs.\n\nLet's look at some common external body parts.\n\nHEAD\n\nYour head is at the top of your body.\n\nIt contains important sense organs such as:\n\n👀 eyes\n\n👂 ears\n\n👃 nose\n\n👅 tongue inside the mouth\n\nYour brain is also protected inside your skull.\n\nNECK\n\nYour neck connects your head to the rest of your body.\n\nIt also helps you turn and move your head.\n\nARMS 💪\n\nYour arms help you:\n\n• reach;\n• lift;\n• carry;\n• push;\n• pull.\n\nHANDS ✋\n\nYour hands help you:\n\n• hold objects;\n• write;\n• pick things up;\n• feel surfaces;\n• perform many careful movements.\n\nLEGS 🦵\n\nYour legs help support your body.\n\nThey help you:\n\n• stand;\n• walk;\n• run;\n• jump.\n\nFEET 🦶\n\nYour feet help support your body and help you move.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 1 — BASIC BODY PARTS",
                  symbol: "",
                  points: [],
                  visualType: "science-3-1",
                  visualCaption:
                      "Different body parts help us do different jobs."),
              NorieLessonSection(
                  title: "SECTION 2 — BODY PARTS WORK TOGETHER 🤝",
                  symbol: "",
                  points: [],
                  body:
                      "Your body parts often work together.\n\nImagine riding a bicycle. 🚲\n\nYour eyes help you see where you are going.\n\nYour hands hold the handlebars.\n\nYour arms help steer.\n\nYour legs push the pedals.\n\nYour feet stay on the pedals.\n\nYour ears may help you notice sounds around you.\n\nMany parts work together to help you ride safely.\n\n💡 REMEMBER:\n\nOne action can use several body parts at the same time.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 3 — WHAT ARE SENSES? 🧠",
                  symbol: "",
                  points: [],
                  body:
                      "Our senses help us collect information about the world around us.\n\nIn Grade 1, we usually learn five main senses:\n\n👀 Sight\n\n👂 Hearing\n\n👃 Smell\n\n👅 Taste\n\n✋ Touch\n\nEach sense helps us notice different kinds of information.\n\nOur sense organs collect information, and the brain helps us understand it.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 2 — THE FIVE SENSES",
                  symbol: "",
                  points: [],
                  visualType: "science-3-2",
                  visualCaption:
                      "Our senses help us learn about our surroundings."),
              NorieLessonSection(
                  title: "SECTION 4 — SIGHT 👀",
                  symbol: "",
                  points: [],
                  body:
                      "We use our eyes mainly for sight.\n\nSight helps us notice:\n\n🎨 colors;\n\n🔺 shapes;\n\n📏 sizes;\n\n📍 locations;\n\n🏃 movement;\n\n🙂 faces;\n\n📖 words and pictures.\n\nEXAMPLE\n\nImagine you see a red apple. 🍎\n\nYour eyes help you notice:\n\n• its red color;\n• its round shape;\n• where it is.\n\nSight gives you information before you even touch the apple.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 5 — HEARING 👂",
                  symbol: "",
                  points: [],
                  body:
                      "We use our ears mainly for hearing.\n\nHearing helps us notice sounds.\n\nWe can hear:\n\n🎵 music;\n\n🗣️ voices;\n\n🐦 birds;\n\n🔔 bells;\n\n🚗 vehicles;\n\n🌧️ rain.\n\nEXAMPLE\n\nSuppose you hear a school bell.\n\nYour ears detect the sound.\n\nYour brain helps you recognize what the sound may mean.\n\nHearing can help us communicate and notice what is happening nearby.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 6 — SMELL 👃",
                  symbol: "",
                  points: [],
                  body:
                      "We use our nose mainly for smelling.\n\nSmell helps us notice odors in the air.\n\nWe may smell:\n\n🌸 flowers;\n\n🍞 bread;\n\n🍊 fruit;\n\n🍲 food;\n\n🌧️ wet soil after rain.\n\nEXAMPLE\n\nImagine you walk near a flower garden.\n\nYou may smell the flowers before you touch them.\n\nYour nose helps collect information from the air.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 7 — TASTE 👅",
                  symbol: "",
                  points: [],
                  body:
                      "Our tongue helps us taste.\n\nTaste helps us notice different flavors in food.\n\nCommon taste words include:\n\n🍬 sweet;\n\n🍋 sour;\n\n🧂 salty;\n\n🥬 bitter;\n\n🍲 savory.\n\nTaste and smell can work together.\n\nFor example, food may seem different when your nose is blocked.\n\nSAFETY NOTE ⚠️\n\nDo not taste unknown things just to learn what they are.\n\nOnly taste food or drinks that a trusted adult says are safe.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 8 — TOUCH ✋",
                  symbol: "",
                  points: [],
                  body:
                      "We sense touch through our skin.\n\nYour skin covers your body.\n\nTouch can help you notice:\n\n🔥 warm;\n\n🧊 cold;\n\n🧸 soft;\n\n🪨 rough;\n\n🪵 hard;\n\n🧽 smooth or bumpy surfaces;\n\ngentle pressure.\n\nEXAMPLE\n\nTouch a soft towel.\n\nThen touch a rough rock.\n\nThey feel different because your skin can detect information about their surfaces.\n\n⚠️ Never touch something dangerous just to test how it feels.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 3 — WHAT CAN EACH SENSE NOTICE?",
                  symbol: "",
                  points: [],
                  visualType: "science-3-3",
                  visualCaption:
                      "Different senses give us different kinds of information."),
              NorieLessonSection(
                  title: "SECTION 9 — MORE THAN ONE SENSE AT A TIME 🧠",
                  symbol: "",
                  points: [],
                  body:
                      "We often use several senses together.\n\nImagine eating an orange. 🍊\n\nYou can:\n\n👀 see its color;\n\n✋ feel its peel;\n\n👃 smell it;\n\n👅 taste it;\n\n👂 hear a small sound as you peel it.\n\nUsing several senses can give us more information about an object.",
                  reveal: false),
              NorieLessonSection(
                  title: "WORKED EXAMPLE — EXPLORING AN APPLE 🍎",
                  symbol: "",
                  points: [],
                  body:
                      "Suppose we want to learn about an apple.\n\nWhat can our senses tell us?\n\nSTEP 1 — SIGHT 👀\n\nWe can see that the apple is red and round.\n\nSTEP 2 — TOUCH ✋\n\nWe can feel that the skin is smooth and firm.\n\nSTEP 3 — SMELL 👃\n\nWe may notice the apple's smell.\n\nSTEP 4 — TASTE 👅\n\nIf the apple is safe to eat, we can taste it.\n\nSTEP 5 — HEARING 👂\n\nWe may hear a crunch when someone bites it.\n\nCONCLUSION:\n\nSeveral senses can work together to help us learn about one object.",
                  reveal: false),
              NorieLessonSection(
                  title: "Picture guide",
                  symbol: "",
                  points: [],
                  visualType: "science-3-apple"),
              NorieLessonSection(
                  title: "SECTION 10 — WHICH SENSE SHOULD I USE? 🤔",
                  symbol: "",
                  points: [],
                  body:
                      "Different questions may need different senses.\n\nQUESTION:\n\n\"What color is the flower?\"\n\nBest sense:\n👀 Sight\n\n\nQUESTION:\n\n\"Is the bell ringing?\"\n\nBest sense:\n👂 Hearing\n\n\nQUESTION:\n\n\"Does this flower have a smell?\"\n\nBest sense:\n👃 Smell\n\n\nQUESTION:\n\n\"Is this towel soft?\"\n\nBest sense:\n✋ Touch\n\n\nQUESTION:\n\n\"Does this safe fruit taste sweet?\"\n\nBest sense:\n👅 Taste\n\nChoosing the right sense helps us gather the information we need.",
                  reveal: false),
              NorieLessonSection(
                  title: "GUIDED EXAMPLE — A RINGING PHONE 📱",
                  symbol: "",
                  points: [],
                  body:
                      "A phone is somewhere nearby.\n\nYou cannot see it yet.\n\nThen you hear it ringing.\n\nWhich sense helped you know that something was happening?\n\n👂 Hearing\n\nYour ears detected the sound.\n\nNow suppose you look around and find the phone.\n\nWhich sense helped you locate it by looking?\n\n👀 Sight\n\nWe can use different senses one after another.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 11 — PROTECTING OUR EYES 👀",
                  symbol: "",
                  points: [],
                  body:
                      "Our eyes are important.\n\nWe should take care of them.\n\nGood habits include:\n\n✅ keeping sharp objects away from the eyes;\n\n✅ using appropriate eye protection when needed;\n\n✅ keeping dirty hands away from the eyes;\n\n✅ telling an adult if your eyes hurt or something gets into them.\n\nDo not stare directly at the Sun. ☀️\n\nVery bright light can harm the eyes.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 12 — PROTECTING OUR EARS 👂",
                  symbol: "",
                  points: [],
                  body:
                      "Our ears help us hear.\n\nWe should protect them too.\n\nGood habits include:\n\n✅ keeping the volume at a comfortable level;\n\n✅ moving away from sounds that are painfully loud;\n\n✅ never pushing objects deep into the ears;\n\n✅ telling an adult if an ear hurts or hearing suddenly changes.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 13 — PROTECTING OUR NOSE, MOUTH, AND SKIN 🧼",
                  symbol: "",
                  points: [],
                  body:
                      "We can take care of other sense organs too.\n\nNOSE 👃\n\nDo not put objects inside the nose.\n\nAvoid smelling unknown chemicals closely.\n\nMOUTH AND TONGUE 👅\n\nOnly eat and taste safe food.\n\nBrush your teeth and keep your mouth clean.\n\nSKIN ✋\n\nWash your skin regularly.\n\nProtect it from very hot objects.\n\nTell an adult if you have a painful injury or burn.",
                  reveal: false),
              NorieLessonSection(
                  title: "Picture guide",
                  symbol: "",
                  points: [],
                  visualType: "science-3-safety"),
              NorieLessonSection(
                  title: "SECTION 14 — BODY PART OR SENSE? 🔎",
                  symbol: "",
                  points: [],
                  body:
                      "Body parts can help with actions, while sense organs help us gather information.\n\nExamples:\n\n🦵 Leg\nhelps us walk and run\n\n✋ Hand\nhelps us hold objects\n\n👀 Eyes\nhelp us see\n\n👂 Ears\nhelp us hear\n\n👃 Nose\nhelps us smell\n\n👅 Tongue\nhelps us taste\n\n🖐️ Skin\nhelps us sense touch\n\nSome body parts can have more than one job.\n\nFor example, your hand can hold something AND the skin on your hand can help you feel it.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 4 — MATCH THE SENSE TO THE BODY PART",
                  symbol: "",
                  points: [],
                  visualType: "science-3-4",
                  visualCaption: ""),
              NorieLessonSection(
                  title: "SECTION 15 — OUR BRAIN HELPS US UNDERSTAND 🧠",
                  symbol: "",
                  points: [],
                  body:
                      "Our eyes, ears, nose, tongue, and skin collect information.\n\nThe brain helps us understand that information.\n\nFor example:\n\nYou hear a bark. 🐕\n\nYour ears detect the sound.\n\nYour brain helps you recognize that the sound may be a dog.\n\nYou see a yellow banana. 🍌\n\nYour eyes detect color and shape.\n\nYour brain helps you recognize the object.\n\nFor Grade 1, remember:\n\n\"Sense organs collect information. The brain helps us understand it.\"",
                  reveal: false),
              NorieLessonSection(
                  title:
                      "SECTION 16 — NOT EVERYONE SENSES THE WORLD THE SAME WAY ❤️",
                  symbol: "",
                  points: [],
                  body:
                      "People can experience the world in different ways.\n\nSome people may not see clearly.\n\nSome may not hear clearly.\n\nThey can use tools and other ways to learn and communicate.\n\nExamples can include:\n\n👓 glasses;\n\n🦻 hearing devices;\n\n🦯 mobility tools;\n\n🤟 sign language;\n\n⠿ Braille.\n\nPeople can learn, communicate, and explore in many different ways.\n\nTreat everyone with respect.",
                  reveal: false),
              NorieLessonSection(
                  title: "ACTIVITY — WHICH SENSE? 🧠",
                  symbol: "",
                  points: [],
                  body:
                      "Think about each situation.\n\n\nYou want to know the color of a ball. ⚽\n\nUse:\n👀 Sight\n\n\nYou want to know whether music is playing. 🎵\n\nUse:\n👂 Hearing\n\n\nYou want to know whether a blanket feels soft. 🧸\n\nUse:\n✋ Touch\n\n\nYou want to notice the smell of a flower. 🌸\n\nUse:\n👃 Smell\n\n\nYou want to know the flavor of a safe piece of fruit. 🍓\n\nUse:\n👅 Taste",
                  reveal: false),
              NorieLessonSection(
                  title: "ACTIVITY — BODY PART AND JOB 💪",
                  symbol: "",
                  points: [],
                  body:
                      "Match the body part to a job.\n\nLEGS 🦵\n→ walking and running\n\nHANDS ✋\n→ holding and picking up\n\nEYES 👀\n→ seeing\n\nEARS 👂\n→ hearing\n\nNOSE 👃\n→ smelling\n\nTONGUE 👅\n→ tasting\n\nSKIN 🖐️\n→ sensing touch",
                  reveal: false),
              NorieLessonSection(
                  title: "Picture guide",
                  symbol: "",
                  points: [],
                  visualType: "science-3-jobs"),
              NorieLessonSection(
                  title: "COMMON MISTAKES ⚠️",
                  symbol: "",
                  points: [],
                  body:
                      "MISTAKE 1:\n\n\"We only use one sense at a time.\"\n\n❌ Not true.\n\nWe often use several senses together.\n\n\nMISTAKE 2:\n\n\"Touch only happens in the hands.\"\n\n❌ Not true.\n\nYour skin covers your whole body and helps you sense touch.\n\n\nMISTAKE 3:\n\n\"The nose is used for taste.\"\n\n❌ Not exactly.\n\nThe tongue is an important organ for taste.\n\nSmell can also affect how food seems to taste.\n\n\nMISTAKE 4:\n\n\"Ears only help us when someone is talking.\"\n\n❌ Not true.\n\nEars can detect many sounds such as music, bells, animals, and vehicles.\n\n\nMISTAKE 5:\n\n\"The eyes understand everything we see by themselves.\"\n\n❌ Not quite.\n\nThe eyes collect visual information, and the brain helps us understand it.",
                  reveal: false),
              NorieLessonSection(
                  title: "QUICK CHECK 🧠",
                  symbol: "",
                  points: [],
                  body:
                      "1. WHICH BODY PART HELPS YOU SEE? 👀\n\nAnswer:\nEyes\n\nWhy?\nEyes collect visual information.\n\n\n2. WHICH SENSE HELPS YOU HEAR A BELL? 🔔\n\nAnswer:\nHearing\n\nWhy?\nOur ears detect sounds.\n\n\n3. WHICH BODY PART HELPS YOU SMELL A FLOWER? 🌸\n\nAnswer:\nNose\n\nWhy?\nThe nose helps detect smells in the air.\n\n\n4. WHICH SENSE HELPS YOU KNOW THAT A BLANKET IS SOFT? 🧸\n\nAnswer:\nTouch\n\nWhy?\nThe skin helps us feel texture.\n\n\n5. CAN MORE THAN ONE SENSE WORK AT THE SAME TIME?\n\nAnswer:\nYes\n\nWhy?\nWe often use several senses together to learn more about an object or situation.",
                  reveal: true),
              NorieLessonSection(
                  title: "KEY CONCEPT ⭐",
                  symbol: "",
                  points: [],
                  body:
                      "TITLE:\n\nOur body parts and senses help us explore the world.\n\nBODY:\n\nDifferent body parts have different jobs.\n\nOur eyes help us see.\n\nOur ears help us hear.\n\nOur nose helps us smell.\n\nOur tongue helps us taste.\n\nOur skin helps us feel touch.\n\nOur sense organs collect information, and the brain helps us understand it.",
                  reveal: false),
              NorieLessonSection(
                  title: "FINAL RECAP 🌟",
                  symbol: "",
                  points: [],
                  body:
                      "Remember:\n\n🧍 Our bodies have many different parts.\n\n💪 Arms and hands help us reach, carry, and hold.\n\n🦵 Legs and feet help us stand and move.\n\n👀 Eyes help us see.\n\n👂 Ears help us hear.\n\n👃 The nose helps us smell.\n\n👅 The tongue helps us taste.\n\n✋ Skin helps us feel touch.\n\n🧠 The brain helps us understand information from our senses.\n\n🤝 Several body parts and senses can work together.\n\n🛡️ We should protect our sense organs and use them safely.",
                  reveal: false),
            ]),
        quiz: NorieQuizContent(questions: scienceQuestions(3, mastery: false)),
        challenge: NorieChallengeContent(
            title: "Our Body & Senses 👀👂 Mastery",
            description: "Use what you learned in three new situations.",
            rounds: scienceQuestions(3, mastery: true))),
    NorieTopicContent(
        id: "science.g1.weather",
        subject: "Science",
        category: "Grade 1",
        gradeLevel: "g1",
        title: "Weather ☀️🌧️",
        subtitle:
            "Learn how to observe weather, describe daily conditions, and choose what to wear or do safely.",
        order: 4,
        accent: "green",
        visualType: "g1-science",
        prerequisiteTopicId: "science.g1.our-body-senses",
        lesson: const NorieLessonContent(
            heading: "Weather ☀️🌧️",
            introduction:
                "Learn how to observe weather, describe daily conditions, and choose what to wear or do safely.\n20–25 minutes",
            keyConceptTitle: "",
            keyConceptBody: "",
            sections: [
              NorieLessonSection(
                  title: "LEARNING GOALS 🎯",
                  symbol: "",
                  points: [],
                  body:
                      "By the end of this lesson, the learner should be able to:\n\n• Describe common kinds of weather.\n• Identify sunny, cloudy, rainy, windy, and stormy conditions.\n• Recognize that weather can change from day to day.\n• Use simple observations to describe the weather.\n• Choose suitable clothing or activities for different weather.\n• Follow basic weather safety rules.",
                  reveal: false),
              NorieLessonSection(
                  title: "OPENING — WHAT IS THE WEATHER LIKE TODAY? 👀",
                  symbol: "",
                  points: [],
                  body:
                      "Look outside.\n\nWhat do you notice?\n\nIs the Sun shining brightly? ☀️\n\nAre there many clouds? ☁️\n\nIs rain falling? 🌧️\n\nAre tree branches moving in the wind? 🌬️\n\nWeather describes what the air and sky are like in a place at a certain time.\n\nWeather can be:\n\n☀️ sunny;\n\n☁️ cloudy;\n\n🌧️ rainy;\n\n🌬️ windy;\n\n⛈️ stormy;\n\nor a mixture of different conditions.\n\nWeather can change.\n\nA morning may begin sunny and later become cloudy or rainy.\n\nThat is why we observe the weather regularly.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 1 — SUNNY WEATHER ☀️",
                  symbol: "",
                  points: [],
                  body:
                      "A sunny day usually has plenty of sunlight.\n\nThe sky may look bright and mostly clear.\n\nSunlight can make the day feel warm.\n\nOn a sunny day, people may:\n\n🧢 wear a hat;\n\n💧 drink water;\n\n🌳 spend time in shaded areas;\n\n🧴 use sun protection with adult guidance.\n\nEXAMPLE\n\nYou look outside and see:\n\n• a bright sky;\n• strong sunlight;\n• only a few clouds.\n\nYou could describe the weather as:\n\n☀️ Sunny",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 1 — SUNNY WEATHER",
                  symbol: "",
                  points: [],
                  visualType: "science-4-1",
                  visualCaption: "Sunny weather has plenty of sunlight."),
              NorieLessonSection(
                  title: "SECTION 2 — CLOUDY WEATHER ☁️",
                  symbol: "",
                  points: [],
                  body:
                      "Cloudy weather happens when many clouds cover part or much of the sky.\n\nClouds are made of tiny drops of water or ice high in the atmosphere.\n\nSome clouds are thin and white.\n\nOthers can look thick and gray.\n\nA cloudy day does not always mean it will rain.\n\nBut some clouds can bring rain.\n\nEXAMPLE\n\nYou look outside.\n\nThe Sun is hard to see because many clouds cover the sky.\n\nYou could describe the weather as:\n\n☁️ Cloudy",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 3 — RAINY WEATHER 🌧️",
                  symbol: "",
                  points: [],
                  body:
                      "Rain happens when drops of water fall from clouds.\n\nRain gives water to plants and helps fill rivers, ponds, and other water sources.\n\nWhen it rains, people may use:\n\n☔ umbrellas;\n\n🧥 raincoats;\n\n🥾 boots.\n\nRoads and paths can become wet and slippery.\n\nWe should walk carefully.\n\nEXAMPLE\n\nYou hear drops hitting the roof.\n\nWater is falling from the sky.\n\nPeople are carrying umbrellas.\n\nThe weather is:\n\n🌧️ Rainy",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 2 — RAINY WEATHER",
                  symbol: "",
                  points: [],
                  visualType: "science-4-2",
                  visualCaption: "Rain is water that falls from clouds."),
              NorieLessonSection(
                  title: "SECTION 4 — WINDY WEATHER 🌬️",
                  symbol: "",
                  points: [],
                  body:
                      "Wind is moving air.\n\nWe cannot usually see the air itself.\n\nBut we can see what the wind moves.\n\nOn a windy day, you might notice:\n\n🍃 leaves moving;\n\n🌳 branches swaying;\n\n🚩 flags waving;\n\n🪁 kites flying.\n\nA little wind can feel pleasant.\n\nVery strong winds can be dangerous.\n\nHOW CAN WE TELL IT IS WINDY?\n\nLook for things that are moving because of the air.\n\nFor example:\n\nA flag is flapping.\n\nLeaves are blowing across the ground.\n\nTree branches are moving.\n\nThese are clues that the weather is windy.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 3 — HOW WE NOTICE WIND",
                  symbol: "",
                  points: [],
                  visualType: "science-4-3",
                  visualCaption:
                      "We cannot see wind itself, but we can see what it moves."),
              NorieLessonSection(
                  title: "SECTION 5 — STORMY WEATHER ⛈️",
                  symbol: "",
                  points: [],
                  body:
                      "A storm may bring:\n\n🌧️ heavy rain;\n\n🌬️ strong wind;\n\n⚡ lightning;\n\n🌩️ thunder;\n\ndark clouds.\n\nStormy weather can be dangerous.\n\nWhen there is thunder or lightning, children should follow instructions from trusted adults and stay in a safe place.\n\nIMPORTANT SAFETY RULE ⚠️\n\nIf you hear thunder:\n\nGo indoors or stay inside a safe building.\n\nDo not stay in an open field.\n\nDo not shelter under a lone tree.\n\nFollow adult instructions.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 6 — WEATHER CAN CHANGE 🔄",
                  symbol: "",
                  points: [],
                  body:
                      "Weather does not stay exactly the same every day.\n\nMonday may be sunny.\n\nTuesday may be rainy.\n\nWednesday may be cloudy.\n\nWeather can even change during the same day.\n\nFor example:\n\nMorning:\n☀️ Sunny\n\nAfternoon:\n☁️ Cloudy\n\nLater:\n🌧️ Rainy\n\nBecause weather can change, people observe it often.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 4 — WEATHER CAN CHANGE",
                  symbol: "",
                  points: [],
                  visualType: "science-4-4",
                  visualCaption: "Weather can change during the day."),
              NorieLessonSection(
                  title: "SECTION 7 — HOW DO WE DESCRIBE WEATHER? 🔎",
                  symbol: "",
                  points: [],
                  body:
                      "We can describe weather by observing different things.\n\nAsk:\n\nWhat does the sky look like?\n\nIs the Sun easy to see?\n\nAre clouds covering the sky?\n\nIs rain falling?\n\nIs the wind moving leaves or flags?\n\nDoes the air feel warm or cool?\n\nThese observations help us describe the weather.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 8 — TEMPERATURE 🌡️",
                  symbol: "",
                  points: [],
                  body:
                      "Temperature tells us how warm or cool something is.\n\nWe often describe the weather as:\n\n🔥 hot;\n\n🙂 warm;\n\n❄️ cool;\n\n🥶 cold.\n\nA thermometer is a tool used to measure temperature.\n\nFor Grade 1, the important idea is:\n\n🌡️ A thermometer helps us measure how warm or cold the air is.",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 5 — HOT, WARM, COOL, COLD",
                  symbol: "",
                  points: [],
                  visualType: "science-4-5",
                  visualCaption:
                      "Temperature tells us how warm or cold the air is."),
              NorieLessonSection(
                  title: "SECTION 9 — WEATHER TOOLS 🧰",
                  symbol: "",
                  points: [],
                  body:
                      "People use tools to observe and measure weather.\n\nFor Grade 1, introduce these simple tools:\n\nTHERMOMETER 🌡️\n\nMeasures temperature.\n\nRAIN GAUGE 🌧️\n\nMeasures how much rain falls.\n\nWIND VANE 🌬️\n\nShows the direction the wind is coming from.\n\nANEMOMETER 💨\n\nMeasures wind speed.\n\nDo not expect Grade 1 students to memorize every tool perfectly.\n\nThe main idea is:\n\n\"Scientists use tools to measure weather.\"",
                  reveal: false),
              NorieLessonSection(
                  title: "VISUAL 6 — SIMPLE WEATHER TOOLS",
                  symbol: "",
                  points: [],
                  visualType: "science-4-6",
                  visualCaption: ""),
              NorieLessonSection(
                  title: "SECTION 10 — CLOUDS CAN GIVE US CLUES ☁️",
                  symbol: "",
                  points: [],
                  body:
                      "Clouds are an important part of weather.\n\nA few small white clouds may appear on a fair day.\n\nThicker gray clouds may bring rain.\n\nBut looking at clouds alone does not always tell us exactly what will happen.\n\nWeather can change.\n\nWe observe several clues together.\n\n💡 REMEMBER:\n\nOne cloud does not always mean rain is coming.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 11 — WEATHER AND CLOTHING 👕",
                  symbol: "",
                  points: [],
                  body:
                      "Weather can help us decide what clothing may be useful.\n\nSUNNY AND HOT ☀️\n\nYou might choose:\n\n👕 light clothing;\n\n🧢 a hat;\n\n💧 water.\n\nRAINY 🌧️\n\nYou might choose:\n\n🧥 raincoat;\n\n☔ umbrella;\n\n🥾 boots.\n\nCOOL OR COLD ❄️\n\nYou might choose:\n\n🧥 jacket;\n\n🧣 warm clothing.\n\nThe goal is to dress in a way that helps you stay comfortable and safe.",
                  reveal: false),
              NorieLessonSection(
                  title: "Picture guide",
                  symbol: "",
                  points: [],
                  visualType: "science-4-clothing"),
              NorieLessonSection(
                  title: "SECTION 12 — WEATHER AND ACTIVITIES ⚽",
                  symbol: "",
                  points: [],
                  body:
                      "Weather can affect what activities are suitable.\n\nA calm sunny day might be good for:\n\n⚽ outdoor games;\n\n🚲 cycling with proper safety equipment;\n\n🌳 visiting a park.\n\nA rainy day may be better for:\n\n📚 reading indoors;\n\n🎨 drawing;\n\n🧩 puzzles.\n\nStormy weather may mean:\n\n🏠 staying safely indoors.\n\nWe should always choose activities that fit the weather and follow adult safety instructions.",
                  reveal: false),
              NorieLessonSection(
                  title: "WORKED EXAMPLE — WHAT IS THE WEATHER? 🔎",
                  symbol: "",
                  points: [],
                  body:
                      "Imagine you look outside.\n\nYou observe:\n\n• dark clouds;\n• water falling from the sky;\n• people using umbrellas;\n• puddles forming on the ground.\n\nLet's decide what kind of weather this is.\n\nSTEP 1:\nLook at the sky.\n\nThere are dark clouds.\n\nSTEP 2:\nLook for precipitation.\n\nWater is falling from the sky.\n\nSTEP 3:\nLook at what people are doing.\n\nPeople are using umbrellas.\n\nCONCLUSION:\n\n🌧️ The weather is rainy.",
                  reveal: false),
              NorieLessonSection(
                  title: "GUIDED EXAMPLE — IS IT WINDY? 🌬️",
                  symbol: "",
                  points: [],
                  body:
                      "You cannot see air.\n\nBut you notice:\n\n🍃 leaves blowing;\n\n🚩 a flag waving quickly;\n\n🌳 small branches moving.\n\nWhat does this tell you?\n\nThe air is moving.\n\nSo the weather is:\n\n🌬️ Windy",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 13 — WEATHER OR SEASON? 🤔",
                  symbol: "",
                  points: [],
                  body:
                      "Weather describes conditions over a short time.\n\nFor example:\n\n\"Today is rainy.\"\n\n\"Tomorrow may be sunny.\"\n\nA season lasts much longer.\n\nDifferent places have different seasonal patterns.\n\nFor Grade 1, remember:\n\nWEATHER:\nwhat the air and sky are like now or over a short time.\n\nSEASON:\na longer part of the year with common weather patterns.\n\nDo not mix up weather with seasons.",
                  reveal: false),
              NorieLessonSection(
                  title: "SECTION 14 — WEATHER SAFETY 🛡️",
                  symbol: "",
                  points: [],
                  body:
                      "Weather can be fun to observe, but safety is important.\n\nHOT AND SUNNY WEATHER ☀️\n\nDrink water.\n\nTake breaks in shade.\n\nFollow adult guidance for sun protection.\n\nRAINY WEATHER 🌧️\n\nWalk carefully on wet surfaces.\n\nStay away from fast-moving floodwater.\n\nNever play in flooded areas.\n\nTHUNDERSTORMS ⛈️\n\nGo inside a safe building.\n\nStay away from open areas.\n\nFollow adult instructions.\n\nSTRONG WIND 🌬️\n\nStay away from loose objects or branches that may fall.\n\nMove to a safe place if adults tell you to.",
                  reveal: false),
              NorieLessonSection(
                  title: "Picture guide",
                  symbol: "",
                  points: [],
                  visualType: "science-4-safety"),
              NorieLessonSection(
                  title: "SECTION 15 — WEATHER CAN AFFECT LIVING THINGS 🌱🐾",
                  symbol: "",
                  points: [],
                  body:
                      "Weather affects plants, animals, and people.\n\nPlants may receive water from rain. 🌱💧\n\nAnimals may look for shade when it is very hot. 🐕🌳\n\nBirds may seek shelter during strong rain. 🐦\n\nPeople choose clothing and activities based on weather.\n\nWeather is part of the environment around living things.",
                  reveal: false),
              NorieLessonSection(
                  title: "ACTIVITY — WHAT WEATHER DO YOU SEE? 👀",
                  symbol: "",
                  points: [],
                  body:
                      "Imagine these scenes.\n\n\nSCENE 1\n\nBright Sun\nBlue sky\nVery few clouds\n\nWeather:\n☀️ Sunny\n\n\nSCENE 2\n\nMany gray clouds\nWater falling\nUmbrellas open\n\nWeather:\n🌧️ Rainy\n\n\nSCENE 3\n\nFlag waving\nLeaves blowing\nBranches moving\n\nWeather:\n🌬️ Windy\n\n\nSCENE 4\n\nDark clouds\nHeavy rain\nThunder and lightning\n\nWeather:\n⛈️ Stormy",
                  reveal: false),
              NorieLessonSection(
                  title: "Picture guide",
                  symbol: "",
                  points: [],
                  visualType: "science-4-sort"),
              NorieLessonSection(
                  title: "ACTIVITY — WHAT SHOULD YOU BRING? 🎒",
                  symbol: "",
                  points: [],
                  body:
                      "RAINY DAY 🌧️\n\nUseful:\n☔ Umbrella\n\n\nSUNNY HOT DAY ☀️\n\nUseful:\n🧢 Hat\n💧 Water\n\n\nCOOL DAY 🍃\n\nUseful:\n🧥 Jacket\n\n\nSTORMY DAY ⛈️\n\nBest choice:\n🏠 Stay safely indoors and follow adult instructions.",
                  reveal: false),
              NorieLessonSection(
                  title: "COMMON MISTAKES ⚠️",
                  symbol: "",
                  points: [],
                  body:
                      "MISTAKE 1:\n\n\"Cloudy always means it is raining.\"\n\n❌ Not true.\n\nA day can be cloudy without rain.\n\n\nMISTAKE 2:\n\n\"If I cannot see the wind, it is not there.\"\n\n❌ Not true.\n\nWind is moving air.\n\nWe can observe what it moves.\n\n\nMISTAKE 3:\n\n\"Weather stays the same all day.\"\n\n❌ Not always.\n\nWeather can change during the day.\n\n\nMISTAKE 4:\n\n\"Every sunny day has no clouds.\"\n\n❌ Not true.\n\nA sunny day can still have some clouds.\n\n\nMISTAKE 5:\n\n\"Thunderstorms are safe to play outside in.\"\n\n❌ Not true.\n\nThunder and lightning can be dangerous.\n\nWe should go to a safe indoor place and follow adult instructions.",
                  reveal: false),
              NorieLessonSection(
                  title: "QUICK CHECK 🧠",
                  symbol: "",
                  points: [],
                  body:
                      "1. THE SUN IS BRIGHT AND THE SKY IS MOSTLY CLEAR.\n\nWeather:\nSunny ☀️\n\nWhy?\nThere is plenty of sunlight and few clouds.\n\n\n2. WATER IS FALLING FROM CLOUDS.\n\nWeather:\nRainy 🌧️\n\nWhy?\nRain is falling from the sky.\n\n\n3. LEAVES AND FLAGS ARE MOVING QUICKLY.\n\nWeather:\nWindy 🌬️\n\nWhy?\nMoving air is pushing them.\n\n\n4. WHICH TOOL MEASURES TEMPERATURE?\n\nAnswer:\nThermometer 🌡️\n\nWhy?\nA thermometer measures how warm or cold the air is.\n\n\n5. YOU HEAR THUNDER OUTSIDE.\n\nWhat should you do?\n\nAnswer:\nGo to a safe indoor place. 🏠\n\nWhy?\nThunderstorms can be dangerous.",
                  reveal: true),
              NorieLessonSection(
                  title: "KEY CONCEPT ⭐",
                  symbol: "",
                  points: [],
                  body:
                      "TITLE:\n\nWeather tells us what the air and sky are like.\n\nBODY:\n\nWeather can be sunny, cloudy, rainy, windy, stormy, warm, cool, and more.\n\nWe can observe the sky, rain, wind, and temperature to describe weather.\n\nWeather can change, so we observe it regularly.",
                  reveal: false),
              NorieLessonSection(
                  title: "FINAL RECAP 🌟",
                  symbol: "",
                  points: [],
                  body:
                      "Remember:\n\n☀️ Sunny weather has plenty of sunlight.\n\n☁️ Cloudy weather has many clouds.\n\n🌧️ Rainy weather has water falling from clouds.\n\n🌬️ Windy weather has moving air.\n\n⛈️ Stormy weather may bring heavy rain, strong wind, thunder, or lightning.\n\n🌡️ Temperature tells us how warm or cold the air is.\n\n🔄 Weather can change during the day.\n\n👕 Weather helps us choose suitable clothing.\n\n🛡️ We should follow safety rules during dangerous weather.",
                  reveal: false),
            ]),
        quiz: NorieQuizContent(questions: scienceQuestions(4, mastery: false)),
        challenge: NorieChallengeContent(
            title: "Weather ☀️🌧️ Mastery",
            description: "Use what you learned in three new situations.",
            rounds: scienceQuestions(4, mastery: true))),
    norieGrade1MaterialsTopic,
  ];
}
