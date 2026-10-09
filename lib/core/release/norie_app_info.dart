abstract final class NorieAppInfo {
  static const version =
      String.fromEnvironment('FLUTTER_BUILD_NAME', defaultValue: '0.6.1');
  static const build =
      String.fromEnvironment('FLUTTER_BUILD_NUMBER', defaultValue: '10');
  static final downloads = Uri.parse(
      'https://eironmoisesdupra-coder.github.io/NorieLearningApp/downloads.html');
}
