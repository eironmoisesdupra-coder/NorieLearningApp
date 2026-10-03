/// Locally authored diagram content; all labels render as accessible text.
///
/// Processes and cycles use ordered stages. Comparisons use paired labels and
/// explanations. Bars use nonnegative measurements on a shared zero baseline.
/// Three particle panels represent solid, liquid and gas, in that order.
class ScienceFigure {
  const ScienceFigure({
    required this.title,
    required this.kind,
    required this.labels,
    required this.details,
    this.note = '',
    this.values = const [],
    this.unit = '',
    this.picture = '',
  }) : assert(kind == 'process' ||
            kind == 'cycle' ||
            kind == 'comparison' ||
            kind == 'bars' ||
            kind == 'particles');

  final String title;
  final String kind;
  final List<String> labels;
  final List<String> details;
  final String note;
  final List<double> values;
  final String unit;
  final String picture;

  /// Validate authored data separately so grade packs can use const figures.
  void validate() {
    if (picture.isNotEmpty &&
        !const [
          'butterfly',
          'bean',
          'habitat',
          'shadow',
          'daynight',
          'plant-parts',
          'forces',
          'g4-body',
          'g4-rock',
          'g4-moon',
          'g5-cells',
          'g5-food-web',
          'g5-lever',
          'g5-water-paths',
        ].contains(picture)) {
      throw ArgumentError('Unknown Science picture: $picture');
    }
    if (labels.isEmpty || labels.length != details.length) {
      throw ArgumentError(
          'Figures need a matching explanation for each label.');
    }
    if (kind == 'bars' &&
        (values.length != labels.length ||
            values.any((value) => !value.isFinite || value < 0))) {
      throw ArgumentError('Bars need one finite nonnegative value per label.');
    }
    if (kind == 'particles') {
      const states = ['solid', 'liquid', 'gas'];
      if (labels.length != 3) {
        throw ArgumentError(
            'Particle labels must be Solid, Liquid, Gas in that order.');
      }
      for (var index = 0; index < 3; index++) {
        if (labels[index].trim().toLowerCase() != states[index]) {
          throw ArgumentError(
              'Particle labels must be Solid, Liquid, Gas in that order.');
        }
      }
    }
  }
}
