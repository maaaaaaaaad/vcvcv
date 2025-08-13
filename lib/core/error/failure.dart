class Failure {
  final String message;
  final Exception? exception;

  const Failure(this.message, {this.exception});

  @override
  String toString() =>
      'Failure(message: ' +
      message +
      ', exception: ' +
      (exception?.toString() ?? 'null') +
      ')';
}
