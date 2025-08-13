class CounterLocalDataSource {
  int _value = 0;

  int getCounter() => _value;

  int increment() => ++_value;
}
