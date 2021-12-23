class TimeDelta {
  int _delta = 0;

  /// In seconds
  int get delta => _delta;
  void increment() {
    _delta++;
  }

  void setTo(int prior, int current) {
    _delta += current - prior;
  }

  void reset() {
    _delta = 0;
  }
}
