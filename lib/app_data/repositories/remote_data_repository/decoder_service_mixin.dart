import 'dart:convert';

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
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw UnauthorizedException(message: res["Status"]);

      case 400:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw BadRequestException(message: res["Status"]);

      case 404:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw NotFoundException(message: res["Status"]);
      case 405:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw MethodNotAllowedException(message: res["Status"]);

      case 409:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw ConflictException(message: res["Status"]);

      case 422:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw UnprocessableEntityException(message: res["Status"]);

      case 403:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw ForbiddenException(message: res["Status"]);

      case 429:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw TooManyRequestsException(message: res["Status"]);

      case 408:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw RequestTimeoutException(message: res["Status"]);

      case 502:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw BadGatewayException(message: res["Status"]);

      case 500:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw InternalServerErrorException(message: res["Status"]);

      default:
        var resBody = await response.stream.bytesToString();
        Map<String, dynamic> res = json.decode(resBody);
        throw ApiDataException(res["Status"] ?? "");
    }
  }
}
