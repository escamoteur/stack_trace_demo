import 'package:http/http.dart' as http;

Future<void> level1() async {
  await Future<void>.delayed(const Duration(seconds: 1));
  print('level1');
  await level2();
}

Future<void> level2() async {
  await Future<void>.delayed(const Duration(seconds: 1));
  print('level2');
  await level3();
}

Future<void> level3() async {
  await Future<void>.delayed(const Duration(seconds: 1));
  print('level3');
  await level4();
}

Future<void> level4() async {
  await Future<void>.delayed(const Duration(seconds: 1));
  print('level4');
  await level5();
}

Future<void> level5() async {
  await Future<void>.delayed(const Duration(seconds: 1));
  print('level5');
  final response =
      await http.get(Uri.parse('https://www.no-domain-escamoteur.com'));
}
