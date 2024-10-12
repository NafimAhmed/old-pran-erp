class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = "Could not connect to the internet!"]);

  @override
  String toString() => message;
}
