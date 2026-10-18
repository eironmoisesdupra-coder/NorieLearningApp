abstract final class NorieAppInfo {
  static const version =
      String.fromEnvironment('FLUTTER_BUILD_NAME', defaultValue: '0.16.0');
  static const build =
      String.fromEnvironment('FLUTTER_BUILD_NUMBER', defaultValue: '21');
  static final downloads = Uri.parse(
      'https://eironmoisesdupra-coder.github.io/NorieLearningApp/downloads.html');
}
