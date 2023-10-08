class Singleton<T extends Singleton<T>> {
  static final Map<String, dynamic> _instances = {};

  factory Singleton() {
    final String type = T.toString();
    if (_instances.containsKey(type)) {
      return _instances[type];
    } else {
      final instance = Singleton<T>._internal();
      _instances[type] = instance;
      return instance;
    }
  }

  Singleton._internal();
}
