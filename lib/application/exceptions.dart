class ApplicationException implements Exception {
  ApplicationException(this.message);

  final String message;
}

class LeftException<T> implements Exception {
  LeftException(this.failure);

  final T failure;
}
