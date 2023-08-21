import 'package:undefinedor/undefinedor.dart';

import '../test/undefined_test.dart';

void main() {
  Car car = Car();
  print(car.name); // null
  print(car.price); // null

  car = car.copyWith(
    name: 'BMW'.toUndefinedOr(), // or UndefinedOr('BMW'),
    price: UndefinedOr(100000), // or 100000.toUndefinedOr(),
  );

  print(car.name); // BMW
  print(car.price); // 100000

  car = car.copyWith(
    name: null.toUndefinedOr(),
  );

  print(car.name); // null
  print(car.price); // 100000
}
