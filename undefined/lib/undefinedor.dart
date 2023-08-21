/// [Undefined] is a class that represents an undefined value.
abstract class Undefined {
  /// [isUndefined] is a method that returns true if the value is undefined.
  /// use it to take action when the value is undefined.
  /// in dart you cant tell if a value is undefined or just null
  /// so we use this method to check if the value is undefined;
  bool get isUndefined;
}

/// [UndefinedOr<T>] is a class that represents an undefined value or a value of type [T].
class UndefinedOr<T> implements Undefined {
  final T? value;
  @override
  final bool isUndefined;

  const UndefinedOr(this.value, {this.isUndefined = false});

  /// [undefined] is a method that returns an [UndefinedOr<T>] with an undefined value.
  const UndefinedOr.undefined() : this(null, isUndefined: true);
}

const UndefinedOr undefined = UndefinedOr(null, isUndefined: true);

/// [UndefinedOrExtension] is an extension class that adds methods to [UndefinedOr<T>].
extension UndefinedOrExtension on Object {
  /// [toUndefinedOr] is a method that returns an [UndefinedOr<T>] with the value of [this].
  UndefinedOr<T> toUndefinedOr<T>() =>
      UndefinedOr<T>(this as T, isUndefined: false);
}

/// [UndefinedOrExtensionForNull] is an extension class that adds methods to [Null].
extension UndefinedOrExtensionForNull on Null {
  /// [toUndefinedOr] is a method that returns an [UndefinedOr<T>] with the value of [this].
  UndefinedOr<T> toUndefinedOr<T>() => UndefinedOr<T>(null, isUndefined: false);
}
