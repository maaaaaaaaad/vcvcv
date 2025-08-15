import '../../domain/entities/token_pair.dart';

class AuthLocalDataSource {
  TokenPair? _cached;

  TokenPair? getSession() => _cached;

  TokenPair save(TokenPair tokens) {
    _cached = tokens;
    return tokens;
  }

  bool clear() {
    _cached = null;
    return true;
  }
}
