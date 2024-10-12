sealed class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() {
    return '$statusCode: $message';
  }
}

class BadRequestException extends ApiException {
  BadRequestException({String? message})
      : super(statusCode: 400, message: message ?? "Bad Request");
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(statusCode: 401, message: message ?? "Unauthorized");
}

class ForbiddenException extends ApiException {
  ForbiddenException({String? message})
      : super(statusCode: 403, message: message ?? "Forbidden");
}

class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(statusCode: 404, message: message ?? "Not Found");
}

class MethodNotAllowedException extends ApiException {
  MethodNotAllowedException({String? message})
      : super(statusCode: 405, message: message ?? "Method Not Allowed");
}

class ConflictException extends ApiException {
  ConflictException({String? message})
      : super(statusCode: 409, message: message ?? "Conflict");
}

class TooManyRequestsException extends ApiException {
  TooManyRequestsException({String? message})
      : super(statusCode: 429, message: message ?? "Too Many Requests");
}

class UnprocessableEntityException extends ApiException {
  UnprocessableEntityException({String? message})
      : super(statusCode: 422, message: message ?? "Unprocessable Entity");
}

class ServiceUnavailableException extends ApiException {
  ServiceUnavailableException({String? message})
      : super(statusCode: 503, message: message ?? "Service Unavailable");
}

class RequestTimeoutException extends ApiException {
  RequestTimeoutException({String? message})
      : super(statusCode: 408, message: message ?? "Request Timeout");
}

class GatewayTimeoutException extends ApiException {
  GatewayTimeoutException({String? message})
      : super(statusCode: 504, message: message ?? "Gateway Timeout");
}

class BadGatewayException extends ApiException {
  BadGatewayException({String? message})
      : super(statusCode: 502, message: message ?? "Bad Gateway");
}

class GatewayException extends ApiException {
  GatewayException({String? message})
      : super(statusCode: 502, message: message ?? "Bad Gateway");
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException({String? message})
      : super(statusCode: 500, message: message ?? "Internal Server Error");
}

class ApiDataException implements Exception {
  final String message;

  const ApiDataException([String? message])
      : message = message ?? "Something went wrong!";

  @override
  String toString() => message;
}
