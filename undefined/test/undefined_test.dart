import 'package:undefinedor/undefinedor.dart';
import 'package:test/test.dart';


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
  group('Example test', () {
    test('First Test', () {
      Car car = Car();
      expect(car.name, null);
      expect(car.price, null);
      car = car.copyWith(
        name: 'BMW'.toUndefinedOr(),
        price: 100000.toUndefinedOr(),
      );
      expect(car.name, 'BMW');
      expect(car.price, 100000);
      car = car.copyWith(
        name: null.toUndefinedOr(),
        price: null.toUndefinedOr(),
      );
      expect(car.name, null);
      expect(car.price, null);

      /// just for fun :)
      expect("Hello World!".toUndefinedOr().value, "Hello World!");
    });
  });
}
