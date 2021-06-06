class UnsavedChangeModel {
  bool _hasUnsavedChange = false;
  get shouldSave => _hasUnsavedChange;

  void madeChange() {
    if (!_hasUnsavedChange) {
      _hasUnsavedChange = true;
    }
  }
  void didSave() {
    _hasUnsavedChange = false;
  }
}