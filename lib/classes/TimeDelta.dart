class TimeDelta {
  int _delta = 0;
  // _preresetDelta is here so that I can reset the delta and use the value in
  // the merge process when saving
  int _preresetDelta = 0;

  /// In seconds
  int get delta => _delta;
  // DO NOT USE OUTSIDE OF MERGE
  int get preresetDelta => _preresetDelta;
  void increment() {
    _delta++;
  }

  void setTo(int prior, int current) {
    _delta += current - prior;
  }

  void reset() {
    _preresetDelta = _delta;
    _delta = 0;
  }
}
