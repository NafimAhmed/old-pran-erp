import 'package:http/http.dart' as http;
import 'package:pran_rfl_erp/core/exceptions/api_exceptions.dart';

mixin DecoderServiceMixin {
  Future<T> decodeResponse<T>(
    http.StreamedResponse response, {
    bool isFile = false,
    T Function(String)? decoder,
  }) async {
    switch (response.statusCode) {
      case 200 || 201:
        if (isFile) {
          return await response.stream.toBytes() as T;
        }
        var jsonBody = await response.stream.bytesToString();

        if (decoder != null) {
          return decoder(jsonBody);
        } else {
          return jsonBody as T;
        }

      case 401:
        throw UnauthorizedException();

      case 400:
        throw BadRequestException();

      case 404:
        throw NotFoundException();
      case 405:
        throw MethodNotAllowedException();

      case 409:
        throw ConflictException();

      case 422:
        throw UnprocessableEntityException();

      case 403:
        throw ForbiddenException();

      case 429:
        throw TooManyRequestsException();

      case 408:
        throw RequestTimeoutException();

      case 502:
        throw BadGatewayException();

      case 500:
        throw InternalServerErrorException();

      default:
        throw const ApiDataException();
    }
  }
}
