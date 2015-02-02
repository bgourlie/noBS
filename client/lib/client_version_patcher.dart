library client_version_patcher;

import 'dart:async';
import 'dart:io';
import 'package:barback/barback.dart';

class ClientVersionPatcher extends Transformer {
  final BarbackSettings _settings;

  ClientVersionPatcher.asPlugin(this._settings);

  String get allowedExtensions => '.dart';

  Future apply(Transform transform) {
    return transform.primaryInput.readAsString().then((content) {
      final buildInfo = _getBuildInfo();
      final id = transform.primaryInput.id;
      final buildNumber =
          buildInfo['BUILD_NUMBER'] != null ? buildInfo['BUILD_NUMBER'] : "1";
      final branch = buildInfo['BRANCH'] != null
          ? buildInfo['BRANCH']
          : ""; // todo: detect via cli?
      final commitId = buildInfo['COMMIT_ID'] != null
          ? buildInfo['COMMIT_ID']
          : ""; // todo: detect via cli?
      final buildTime = buildInfo['BUILD_TIME'] != null
          ? DateTime.parse(buildInfo['BUILD_TIME']).toUtc().toIso8601String()
          : new DateTime.now().toUtc().toIso8601String();

      var newContent = _replaceConst(content, 'BUILD_NUMBER', buildNumber);
      newContent = _replaceConst(newContent, 'BRANCH', branch);
      newContent = _replaceConst(newContent, 'COMMIT_ID', commitId);
      newContent = _replaceConst(newContent, 'BUILD_TIME', buildTime);
      transform.addOutput(new Asset.fromString(id, newContent));
    });
  }

  Future<bool> isPrimary(AssetId id) {
    final entryPoint = 'web/${this._settings.configuration['entryPoint']}';
    return new Future<bool>(() => id.path == '$entryPoint');
  }

  static String _replaceConst(
      String content, String constName, String newValue) {
    print('Setting $constName = "$newValue"');
    final regex = new RegExp(r"const " + constName + r" = '(.*)'");
    if (!regex.hasMatch(content)) {
      print('Couldn\'t locate const $constName');
    }
    return content.replaceFirst(regex, 'const $constName = "$newValue"');
  }

  Map<String, String> _getBuildInfo() {
    final env = Platform.environment;
    return {
      'BUILD_NUMBER': env['TRAVIS_BUILD_NUMBER'],
      'BRANCH': env['TRAVIS_BRANCH'],
      'COMMIT_ID': env['TRAVIS_COMMIT'],
      'BUILD_TIME': env['BUILD_TIME']
    };
  }
}
