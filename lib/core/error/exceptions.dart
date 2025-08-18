// lib/core/errors/exceptions.dart

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}
// Adicione outras exceções conforme necessário, por exemplo, CacheException, NetworkException
class UnknownException implements Exception {
  final String message;
  const UnknownException(this.message);

  @override
  String toString() => 'UnknownException: $message';
}
//network exception, etc.
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
