/// Tracks identity changes, including A -> B -> A, independently of token
/// refreshes or network/access configuration. Used by active local activities.
class NorieLearnerIdentity {
  String? _owner;
  int _revision = 0;
  void update(String? owner) {
    if (owner != _owner) {
      _owner = owner;
      _revision++;
    }
  }

  bool Function() capture() {
    final revision = _revision;
    return () => revision == _revision;
  }
}
