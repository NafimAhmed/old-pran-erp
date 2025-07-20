import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:pran_rfl_erp/core/exceptions/api_exceptions.dart';

mixin HttpDecoderServiceMixin {
  Future<String> decodeResponse(http.StreamedResponse response) async {
    switch (response.statusCode) {
      case 200 || 201:
        var jsonBody = await response.stream.bytesToString();
        //log("Response: $jsonBody");
        return jsonBody;
      case 401:
        throw UnauthorizedException(message: await _parseMessage(response));

      case 400:
        throw BadRequestException(message: await _parseMessage(response));

      case 404:
        throw NotFoundException(message: await _parseMessage(response));

      case 405:
        throw MethodNotAllowedException(message: await _parseMessage(response));

      case 409:
        throw ConflictException(message: await _parseMessage(response));

      case 422:
        throw UnprocessableEntityException(
          message: await _parseMessage(response),
        );

      case 403:
        throw ForbiddenException(message: await _parseMessage(response));

      case 429:
        throw TooManyRequestsException(message: await _parseMessage(response));

      case 408:
        throw RequestTimeoutException(message: await _parseMessage(response));

      case 502:
        throw BadGatewayException(message: await _parseMessage(response));

      case 500:
        throw InternalServerErrorException(
          message: await _parseMessage(response),
        );

      default:
        throw ApiDataException(await _parseMessage(response));
    }
  }

  /// Helper function to parse API error messages
  Future<String> _parseMessage(http.StreamedResponse response) async {
    try {
      var resBody = await response.stream.bytesToString();
      Map<String, dynamic> res = json.decode(resBody);
      return res["Status"] ?? "Unknown error occurred";
    } catch (e) {
      return "Unknown error occurred";
    }
  }
}
