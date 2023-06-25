import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final String fvmConfig = File('./.fvm/fvm_config.json').readAsStringSync();
  final dynamic fvmConfigJson = jsonDecode(fvmConfig);
  final dynamic flutterVersion = fvmConfigJson['flutterSdkVersion'];
  final Process install =
      await Process.start('fvm', <String>['install', flutterVersion]);

  install.stdout.listen(
    (List<int> event) {
      stdout.write(utf8.decode(event));
    },
    onDone: () async {
      stdout.writeln();

      final ProcessResult result =
          await Process.run('fvm', <String>['use', flutterVersion]);
      stdout.write(result.stdout);
    },
  );
}
