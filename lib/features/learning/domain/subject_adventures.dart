/// Adventure availability is separate from authored lesson/map availability.
/// A preview describes an idea; it is never a published lesson or assessment.
class SubjectAdventure {
  const SubjectAdventure({
    required this.subject,
    required this.title,
    required this.description,
    required this.concepts,
    this.playable = false,
  });

  final String subject;
  final String title;
  final String description;
  final List<String> concepts;
  final bool playable;
}

abstract final class SubjectAdventures {
  static const all = [
    SubjectAdventure(
      subject: 'Mathematics',
      title: 'Observatory Mystery',
      description:
          'A planned observatory investigation using number patterns and measurements to interpret clues.',
      concepts: ['Number patterns', 'Measurement', 'Reading data'],
    ),
    SubjectAdventure(
      subject: 'Science',
      title: 'The Case of the Vanishing Water',
      description:
          'Inspect a room, compare warm and cool dishes, and use evidence to explain where water went.',
      concepts: [
        'Evaporation',
        'Controlled comparison',
        'Evidence and reasoning'
      ],
      playable: true,
    ),
    SubjectAdventure(
      subject: 'English',
      title: 'The Lost Story',
      description:
          'A planned story investigation about ordering events and finding evidence in a text.',
      concepts: [
        'Reading comprehension',
        'Sequence of events',
        'Text evidence'
      ],
    ),
    SubjectAdventure(
      subject: 'Filipino',
      title: 'Misteryo sa Aklatan',
      description:
          'Isang planong misteryo tungkol sa pag-unawa sa binasa at pagsunod sa pagkakasunod-sunod ng pangyayari.',
      concepts: ['Pag-unawa sa binasa', 'Talasalitaan', 'Pagkakasunod-sunod'],
    ),
    SubjectAdventure(
      subject: 'Araling Panlipunan',
      title: 'The Missing Map',
      description:
          'A planned map investigation using symbols and directions to explore places in a community.',
      concepts: ['Map symbols', 'Directions', 'Community places'],
    ),
  ];

  static SubjectAdventure? forSubject(String subject) {
    for (final adventure in all) {
      if (adventure.subject == subject) return adventure;
    }
    return null;
  }
}
