class RecordStub {
  DateTime _startDate;
  DateTime _stopDate;
  // Used to indicate whether the dates held in this class
  // are current and should be used
  bool _isFresh = false;
  bool _needsValue = true;
  bool _usedBonusTime = false;

  DateTime get startDate => _startDate;
  DateTime get stopDate => _stopDate;
  bool get isFresh => _isFresh;
  bool get didUseBonusTime => _usedBonusTime;

  void usedBonusTime() => _usedBonusTime = true;

  void begin() {
    if (_isFresh == false) {
      _startDate = DateTime.now();
      _isFresh = true;
    } else {
      print(
          "Did not begin at ${DateTime.now().toString()} since Stub was isFresh");
    }
  }

  // Makes the stub stale
  void reset() {
    _isFresh = false;
    _needsValue = true;
    _usedBonusTime = false;
  }

  // Used to record the time at which the stop button was pressed
  void setStopDate({bool fromSaveButton = false}) {
    if ((fromSaveButton && _needsValue) || !fromSaveButton) {
      _stopDate = DateTime.now();
      _needsValue = false;
    }
  }
}
