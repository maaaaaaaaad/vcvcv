typedef FactoryFunc<T> = T Function();

class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  final Map<Type, dynamic> _singletons = {};
  final Map<Type, FactoryFunc<dynamic>> _factories = {};

  void registerSingleton<T>(T instance) {
    _singletons[T] = instance;
  }

  void registerFactory<T>(FactoryFunc<T> factory) {
    _factories[T] = factory;
  }

  T get<T>() {
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }
    final factory = _factories[T];
    if (factory != null) {
      return factory() as T;
    }
    throw StateError('Service of type $T not found');
  }

  void reset() {
    _singletons.clear();
    _factories.clear();
  }
}

final sl = ServiceLocator.instance;
