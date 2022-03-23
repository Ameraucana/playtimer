class SquareTrain {
  SquareTrain() {
    _leader = 0;
    _trailer1 = 0;
    _trailer2 = 0;
  }
  int _leader, _trailer1, _trailer2;

  List<int> get carPositions => [_leader, _trailer1, _trailer2];

  void chug(int leaderPos) {
    _leader = leaderPos;
    _trailer1 = (leaderPos - 1) % 8;
    _trailer2 = (leaderPos - 2) % 8;
  }
}
