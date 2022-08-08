class File {
  File(String path);
}

class Platform {
  static bool get isAndroid => false;
  static bool get isFuchsia => false;
  static bool get isIOS => false;
  static bool get isMacOS => false;
  static bool get isLinux => false;
  static bool get isWindows => false;
}
