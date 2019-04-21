import 'base/index.dart';
import 'maker/index.dart';
import 'store/index.dart';
import 'my/index.dart';

final base = Base();
final maker = Maker();
final store = Store();
final my = My();

List containerList = [
  base,
  store,
  maker,
  my
];