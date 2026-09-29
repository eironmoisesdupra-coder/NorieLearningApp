import 'package:flutter/material.dart';

enum AnatomySystemId {
  skeletal,
  articular,
  muscular,
  cardiovascular,
  arterial,
  venous,
  nervous,
  lymphatic,
  respiratory,
  digestive,
  urinary,
  reproductive,
  endocrine,
  integumentary,
  sensory,
}

class AnatomyStructure {
  const AnatomyStructure({
    required this.id,
    required this.name,
    required this.system,
    required this.description,
    required this.function,
    required this.x,
    required this.y,
    this.z = 0,
  });

  final String id;
  final String name;
  final AnatomySystemId system;
  final String description;
  final String function;
  final double x;
  final double y;
  final double z;
}

class AnatomySystem {
  const AnatomySystem({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.structures,
  });

  final AnatomySystemId id;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<AnatomyStructure> structures;
}

abstract final class AnatomyCatalog {
  static const systems = <AnatomySystem>[
    AnatomySystem(
      id: AnatomySystemId.skeletal,
      label: 'Skeletal',
      subtitle: 'Bones, support, protection, and movement',
      icon: Icons.accessibility_new_rounded,
      color: Color(0xFFE7EDF6),
      structures: [
        AnatomyStructure(id:'skull',name:'Skull',system:AnatomySystemId.skeletal,description:'Bones of the cranium and face.',function:'Protects the brain and supports facial structures.',x:.50,y:.12),
        AnatomyStructure(id:'vertebral-column',name:'Vertebral Column',system:AnatomySystemId.skeletal,description:'Stacked vertebrae from neck to pelvis.',function:'Protects the spinal cord and supports the trunk.',x:.50,y:.40),
        AnatomyStructure(id:'rib-cage',name:'Rib Cage',system:AnatomySystemId.skeletal,description:'Ribs and sternum surrounding the thorax.',function:'Protects thoracic organs and assists breathing mechanics.',x:.50,y:.31),
        AnatomyStructure(id:'femur',name:'Femur',system:AnatomySystemId.skeletal,description:'Long bone of the thigh.',function:'Transfers body weight and enables lower-limb movement.',x:.43,y:.72),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.articular,
      label: 'Articular',
      subtitle: 'Joints and ranges of motion',
      icon: Icons.hub_rounded,
      color: Color(0xFF8CF5FF),
      structures: [
        AnatomyStructure(id:'shoulder-joint',name:'Shoulder Joint',system:AnatomySystemId.articular,description:'Ball-and-socket joint of the upper limb.',function:'Allows a wide range of arm movement.',x:.36,y:.27),
        AnatomyStructure(id:'elbow-joint',name:'Elbow Joint',system:AnatomySystemId.articular,description:'Joint between arm and forearm bones.',function:'Primarily allows flexion and extension.',x:.27,y:.45),
        AnatomyStructure(id:'hip-joint',name:'Hip Joint',system:AnatomySystemId.articular,description:'Ball-and-socket joint connecting femur and pelvis.',function:'Supports body weight while allowing leg movement.',x:.42,y:.57),
        AnatomyStructure(id:'knee-joint',name:'Knee Joint',system:AnatomySystemId.articular,description:'Large synovial joint of the lower limb.',function:'Supports flexion, extension, and weight bearing.',x:.42,y:.79),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.muscular,
      label: 'Muscular',
      subtitle: 'Major muscles and movement',
      icon: Icons.fitness_center_rounded,
      color: Color(0xFFFF6B7D),
      structures: [
        AnatomyStructure(id:'deltoid',name:'Deltoid',system:AnatomySystemId.muscular,description:'Triangular muscle over the shoulder.',function:'Abducts the arm and assists shoulder movement.',x:.36,y:.27),
        AnatomyStructure(id:'pectoralis-major',name:'Pectoralis Major',system:AnatomySystemId.muscular,description:'Large chest muscle.',function:'Moves the upper arm across and toward the body.',x:.45,y:.32),
        AnatomyStructure(id:'rectus-abdominis',name:'Rectus Abdominis',system:AnatomySystemId.muscular,description:'Paired abdominal muscle.',function:'Flexes the trunk and stabilizes the abdominal wall.',x:.50,y:.46),
        AnatomyStructure(id:'quadriceps',name:'Quadriceps',system:AnatomySystemId.muscular,description:'Muscle group on the front of the thigh.',function:'Extends the knee and supports locomotion.',x:.43,y:.69),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.cardiovascular,
      label: 'Heart',
      subtitle: 'Central pump of circulation',
      icon: Icons.favorite_rounded,
      color: Color(0xFFFF4E73),
      structures: [
        AnatomyStructure(id:'heart',name:'Heart',system:AnatomySystemId.cardiovascular,description:'Muscular organ in the thorax.',function:'Pumps blood through pulmonary and systemic circulation.',x:.54,y:.34),
        AnatomyStructure(id:'right-atrium',name:'Right Atrium',system:AnatomySystemId.cardiovascular,description:'Upper right heart chamber.',function:'Receives systemic venous blood.',x:.53,y:.32),
        AnatomyStructure(id:'left-ventricle',name:'Left Ventricle',system:AnatomySystemId.cardiovascular,description:'Thick-walled lower left chamber.',function:'Pumps oxygenated blood into systemic circulation.',x:.55,y:.36),
        AnatomyStructure(id:'aorta',name:'Aorta',system:AnatomySystemId.cardiovascular,description:'Largest artery of the body.',function:'Carries oxygenated blood from the left ventricle.',x:.54,y:.29),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.arterial,
      label: 'Arteries',
      subtitle: 'Blood flow away from the heart',
      icon: Icons.route_rounded,
      color: Color(0xFFFF4C4C),
      structures: [
        AnatomyStructure(id:'carotid-artery',name:'Carotid Artery',system:AnatomySystemId.arterial,description:'Major artery of the neck.',function:'Supplies blood to the head and brain.',x:.52,y:.19),
        AnatomyStructure(id:'subclavian-artery',name:'Subclavian Artery',system:AnatomySystemId.arterial,description:'Artery beneath the clavicle.',function:'Supplies upper limbs and parts of the thorax.',x:.40,y:.27),
        AnatomyStructure(id:'abdominal-aorta',name:'Abdominal Aorta',system:AnatomySystemId.arterial,description:'Aorta within the abdomen.',function:'Supplies abdominal organs and lower body.',x:.51,y:.48),
        AnatomyStructure(id:'femoral-artery',name:'Femoral Artery',system:AnatomySystemId.arterial,description:'Major artery of the thigh.',function:'Supplies the lower limb.',x:.45,y:.67),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.venous,
      label: 'Veins',
      subtitle: 'Blood return toward the heart',
      icon: Icons.alt_route_rounded,
      color: Color(0xFF6D7CFF),
      structures: [
        AnatomyStructure(id:'jugular-vein',name:'Jugular Vein',system:AnatomySystemId.venous,description:'Major vein of the neck.',function:'Drains blood from the head toward the heart.',x:.48,y:.19),
        AnatomyStructure(id:'superior-vena-cava',name:'Superior Vena Cava',system:AnatomySystemId.venous,description:'Large thoracic vein.',function:'Returns blood from the upper body to the right atrium.',x:.52,y:.28),
        AnatomyStructure(id:'inferior-vena-cava',name:'Inferior Vena Cava',system:AnatomySystemId.venous,description:'Large abdominal vein.',function:'Returns blood from the lower body to the heart.',x:.49,y:.49),
        AnatomyStructure(id:'femoral-vein',name:'Femoral Vein',system:AnatomySystemId.venous,description:'Major vein of the thigh.',function:'Drains the lower limb.',x:.47,y:.68),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.nervous,
      label: 'Nervous',
      subtitle: 'Brain, spinal cord, and peripheral nerves',
      icon: Icons.psychology_rounded,
      color: Color(0xFFFFD84A),
      structures: [
        AnatomyStructure(id:'brain',name:'Brain',system:AnatomySystemId.nervous,description:'Central nervous organ within the cranium.',function:'Integrates sensory input and coordinates body functions.',x:.50,y:.10),
        AnatomyStructure(id:'spinal-cord',name:'Spinal Cord',system:AnatomySystemId.nervous,description:'Central nervous tissue within the vertebral canal.',function:'Relays signals between brain and body.',x:.50,y:.38),
        AnatomyStructure(id:'brachial-plexus',name:'Brachial Plexus',system:AnatomySystemId.nervous,description:'Network of nerves near the shoulder.',function:'Provides motor and sensory innervation to the upper limb.',x:.38,y:.28),
        AnatomyStructure(id:'sciatic-nerve',name:'Sciatic Nerve',system:AnatomySystemId.nervous,description:'Large nerve of the posterior lower limb.',function:'Carries motor and sensory signals to much of the leg and foot.',x:.57,y:.69),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.lymphatic,
      label: 'Lymphatic',
      subtitle: 'Lymph vessels, nodes, and immune organs',
      icon: Icons.blur_on_rounded,
      color: Color(0xFF7EEB8A),
      structures: [
        AnatomyStructure(id:'cervical-nodes',name:'Cervical Lymph Nodes',system:AnatomySystemId.lymphatic,description:'Lymph nodes in the neck.',function:'Filter lymph from head and neck regions.',x:.46,y:.20),
        AnatomyStructure(id:'axillary-nodes',name:'Axillary Lymph Nodes',system:AnatomySystemId.lymphatic,description:'Nodes within the armpit.',function:'Filter lymph from upper limb and thoracic regions.',x:.34,y:.31),
        AnatomyStructure(id:'spleen',name:'Spleen',system:AnatomySystemId.lymphatic,description:'Lymphoid organ in the upper left abdomen.',function:'Filters blood and supports immune responses.',x:.60,y:.45),
        AnatomyStructure(id:'inguinal-nodes',name:'Inguinal Lymph Nodes',system:AnatomySystemId.lymphatic,description:'Nodes in the groin.',function:'Filter lymph from lower limb and pelvic regions.',x:.43,y:.58),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.respiratory,
      label: 'Respiratory',
      subtitle: 'Airways and lungs',
      icon: Icons.air_rounded,
      color: Color(0xFF7FD4FF),
      structures: [
        AnatomyStructure(id:'larynx',name:'Larynx',system:AnatomySystemId.respiratory,description:'Voice box in the neck.',function:'Maintains airway and contributes to sound production.',x:.50,y:.20),
        AnatomyStructure(id:'trachea',name:'Trachea',system:AnatomySystemId.respiratory,description:'Air-conducting tube from larynx to bronchi.',function:'Conducts air toward the lungs.',x:.50,y:.26),
        AnatomyStructure(id:'right-lung',name:'Right Lung',system:AnatomySystemId.respiratory,description:'Right pulmonary organ.',function:'Performs gas exchange between air and blood.',x:.42,y:.34),
        AnatomyStructure(id:'left-lung',name:'Left Lung',system:AnatomySystemId.respiratory,description:'Left pulmonary organ.',function:'Performs gas exchange while accommodating the heart.',x:.58,y:.34),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.digestive,
      label: 'Digestive',
      subtitle: 'Alimentary tract and accessory organs',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFFF9C55),
      structures: [
        AnatomyStructure(id:'esophagus',name:'Esophagus',system:AnatomySystemId.digestive,description:'Muscular tube from pharynx to stomach.',function:'Moves swallowed material to the stomach.',x:.51,y:.31),
        AnatomyStructure(id:'stomach',name:'Stomach',system:AnatomySystemId.digestive,description:'Muscular organ in the upper abdomen.',function:'Stores and mechanically and chemically processes food.',x:.57,y:.44),
        AnatomyStructure(id:'liver',name:'Liver',system:AnatomySystemId.digestive,description:'Large organ in the upper right abdomen.',function:'Processes nutrients and produces bile among many functions.',x:.43,y:.42),
        AnatomyStructure(id:'small-intestine',name:'Small Intestine',system:AnatomySystemId.digestive,description:'Coiled intestinal segment.',function:'Performs most digestion and nutrient absorption.',x:.50,y:.53),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.urinary,
      label: 'Urinary',
      subtitle: 'Kidneys, ureters, and bladder',
      icon: Icons.water_drop_rounded,
      color: Color(0xFFB58CFF),
      structures: [
        AnatomyStructure(id:'right-kidney',name:'Right Kidney',system:AnatomySystemId.urinary,description:'Retroperitoneal urinary organ.',function:'Filters blood and helps regulate fluid balance.',x:.42,y:.47),
        AnatomyStructure(id:'left-kidney',name:'Left Kidney',system:AnatomySystemId.urinary,description:'Retroperitoneal urinary organ.',function:'Filters blood and forms urine.',x:.58,y:.47),
        AnatomyStructure(id:'ureter',name:'Ureter',system:AnatomySystemId.urinary,description:'Tube connecting kidney and bladder.',function:'Conducts urine to the bladder.',x:.54,y:.55),
        AnatomyStructure(id:'urinary-bladder',name:'Urinary Bladder',system:AnatomySystemId.urinary,description:'Muscular pelvic reservoir.',function:'Stores urine before elimination.',x:.50,y:.60),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.reproductive,
      label: 'Reproductive',
      subtitle: 'Primary reproductive structures',
      icon: Icons.female_rounded,
      color: Color(0xFFFF78C8),
      structures: [
        AnatomyStructure(id:'uterus',name:'Uterus',system:AnatomySystemId.reproductive,description:'Muscular pelvic organ.',function:'Supports implantation and development during pregnancy.',x:.50,y:.59),
        AnatomyStructure(id:'ovary',name:'Ovary',system:AnatomySystemId.reproductive,description:'Female gonad.',function:'Produces oocytes and reproductive hormones.',x:.44,y:.58),
        AnatomyStructure(id:'testis',name:'Testis',system:AnatomySystemId.reproductive,description:'Male gonad.',function:'Produces sperm and testosterone.',x:.50,y:.64),
        AnatomyStructure(id:'prostate',name:'Prostate',system:AnatomySystemId.reproductive,description:'Male gland below the bladder.',function:'Contributes fluid to semen.',x:.50,y:.61),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.endocrine,
      label: 'Endocrine',
      subtitle: 'Hormone-producing glands',
      icon: Icons.bubble_chart_rounded,
      color: Color(0xFF54E0C2),
      structures: [
        AnatomyStructure(id:'pituitary',name:'Pituitary Gland',system:AnatomySystemId.endocrine,description:'Small gland at the base of the brain.',function:'Regulates multiple endocrine organs through hormone secretion.',x:.50,y:.105),
        AnatomyStructure(id:'thyroid',name:'Thyroid Gland',system:AnatomySystemId.endocrine,description:'Gland in the anterior neck.',function:'Produces hormones that regulate metabolism.',x:.50,y:.205),
        AnatomyStructure(id:'adrenal',name:'Adrenal Gland',system:AnatomySystemId.endocrine,description:'Glands superior to the kidneys.',function:'Produces hormones involved in stress response and electrolyte balance.',x:.43,y:.44),
        AnatomyStructure(id:'pancreas',name:'Pancreas',system:AnatomySystemId.endocrine,description:'Abdominal gland with endocrine and digestive roles.',function:'Releases insulin and glucagon to help regulate blood glucose.',x:.55,y:.46),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.integumentary,
      label: 'Integumentary',
      subtitle: 'Skin and surface protection',
      icon: Icons.layers_rounded,
      color: Color(0xFFE0A985),
      structures: [
        AnatomyStructure(id:'skin',name:'Skin',system:AnatomySystemId.integumentary,description:'Largest organ covering the body.',function:'Protects tissues and participates in sensation and temperature control.',x:.68,y:.35),
        AnatomyStructure(id:'epidermis',name:'Epidermis',system:AnatomySystemId.integumentary,description:'Outer epithelial layer of skin.',function:'Forms a protective barrier.',x:.70,y:.31),
        AnatomyStructure(id:'dermis',name:'Dermis',system:AnatomySystemId.integumentary,description:'Connective tissue layer beneath epidermis.',function:'Contains vessels, nerves, glands, and follicles.',x:.69,y:.37),
        AnatomyStructure(id:'sweat-gland',name:'Sweat Gland',system:AnatomySystemId.integumentary,description:'Coiled gland in skin.',function:'Produces sweat for thermoregulation.',x:.67,y:.43),
      ],
    ),
    AnatomySystem(
      id: AnatomySystemId.sensory,
      label: 'Sense Organs',
      subtitle: 'Vision, hearing, smell, taste, and touch',
      icon: Icons.visibility_rounded,
      color: Color(0xFF65E6FF),
      structures: [
        AnatomyStructure(id:'eye',name:'Eye',system:AnatomySystemId.sensory,description:'Organ of vision.',function:'Detects light and forms visual signals.',x:.47,y:.105),
        AnatomyStructure(id:'ear',name:'Ear',system:AnatomySystemId.sensory,description:'Organ involved in hearing and balance.',function:'Detects sound and contributes to equilibrium.',x:.36,y:.12),
        AnatomyStructure(id:'olfactory-region',name:'Olfactory Region',system:AnatomySystemId.sensory,description:'Sensory region of the nasal cavity.',function:'Detects odor molecules.',x:.50,y:.14),
        AnatomyStructure(id:'tongue',name:'Tongue',system:AnatomySystemId.sensory,description:'Muscular oral organ with taste receptors.',function:'Supports taste, speech, and swallowing.',x:.50,y:.17),
      ],
    ),
  ];

  static AnatomySystem byId(AnatomySystemId id) =>
      systems.firstWhere((system) => system.id == id);

  static List<AnatomyStructure> structuresFor(Set<AnatomySystemId> selected) => [
        for (final system in systems)
          if (selected.contains(system.id)) ...system.structures,
      ];

  static AnatomyStructure? structureById(String id) {
    for (final system in systems) {
      for (final structure in system.structures) {
        if (structure.id == id) return structure;
      }
    }
    return null;
  }
}
