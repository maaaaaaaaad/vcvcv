class TokenPair {
  final String accessToken;
  final String refreshToken;

  const TokenPair({required this.accessToken, required this.refreshToken});

  bool get isValid => accessToken.isNotEmpty && refreshToken.isNotEmpty;
}
