

`Undefined` is a Dart package for Undefined value in Dart.
it can be used in general purpose.

it can solve the problem of when you really wanna set `null` value to a variable, but you can't because ``copyWith`` method doesn't accept `null` value. dart thinks that you wanna keep the old value of the variable.

in the future, dart may support undefined value, or union type, but for now, you can use this package.

## Example of using Undefined

```dart
import 'package:undefinedor/undefinedor.dart';

class Car {
  final String? name;
  final int? price;
  Car({this.name, this.price});

  Car copyWith({
    UndefinedOr<String>? name = const UndefinedOr.undefined(),
    UndefinedOr<int>? price = const UndefinedOr.undefined(),
  }) {
    return Car(
      name: name?.isUndefined == true ? this.name : name?.value,
      price: price?.isUndefined == true ? this.price : price?.value,
    );
  }
}

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
    price: null.toUndefinedOr(),
  );

  print(car.name); // null
  print(car.price); // null
}
```
