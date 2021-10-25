import 'dart:io';

import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

Builder build(BuilderOptions options) {
  return VersionGenBuilder();
}

class VersionGenBuilder extends Builder {
  @override
  Future<void> build(BuildStep buildStep) async => generate();

  @override
  Map<String, List<String>> get buildExtensions => {
        r"$lib$": ["version.gen.dart"],
      };

  void generate({
    String pubspec = 'pubspec.yaml',
    String genFile = 'version.gen.dart',
  }) {
    final settings = loadYaml(File(pubspec).readAsStringSync()) as Map?;
    final version = settings?['version'];
    final path = settings?['version_gen']?['path'] ?? 'lib/gen/';
    final outputFile = File('$path/$genFile');
    if (!outputFile.existsSync()) {
      outputFile.createSync(recursive: true);
    }
    outputFile.writeAsStringSync(
        '''/// DO NOT MODIFY BY HAND, Generated by version_gen
String packageVersion = '$version';
''');
  }
}
