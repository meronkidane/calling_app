import 'package:calling_app/src/app.dart';
import 'package:calling_app/src/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const CallingApp());
}
