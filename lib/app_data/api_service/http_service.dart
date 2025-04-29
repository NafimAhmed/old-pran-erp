import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pran_rfl_erp/app_data/api_service/http_decoder_service_mixin.dart';
import 'package:pran_rfl_erp/config/app_config.dart';
import 'package:pran_rfl_erp/core/exceptions/api_exceptions.dart';
import 'package:pran_rfl_erp/core/exceptions/custom_exception.dart';

class HttpService with HttpDecoderServiceMixin {
  final AppConfig appConfig;

  HttpService({required this.appConfig});

  Future<http.StreamedResponse> _safeApiCall(Request request) async {
    try {
      http.StreamedResponse response = await request.send();
      return response;
    } on SocketException {
      throw const ServerDownException();
    } on http.ClientException {
      throw const ServerDownException();
    } catch (e) {
      throw const CustomException("Something Went Wrong");
    }
  }

  Future<String> getCall({
    required String endPoint,
    required Map<String, dynamic> parameters,
  }) async {
    String finalUrl = appConfig.baseUrl + endPoint;

    if (parameters.isNotEmpty) {
      finalUrl +=
          "?${parameters.entries.map((e) => "${e.key}=${e.value}").join("&")}";
    }
    var request = http.Request('GET', Uri.parse(finalUrl));
    http.StreamedResponse response = await _safeApiCall(request);
    return await decodeResponse(response);
  }

  Future<String> postCall({
    required String endPoint,
    required Map<String, dynamic> parameters,
  }) async {
    String finalUrl = appConfig.baseUrl + endPoint;

    if (parameters.isNotEmpty) {
      finalUrl +=
          "?${parameters.entries.map((e) => "${e.key}=${e.value}").join("&")}";
    }
    var request = http.Request('POST', Uri.parse(finalUrl));
    http.StreamedResponse response = await _safeApiCall(request);
    return await decodeResponse(response);
  }

  Future<String> putCall({
    required String endPoint,
    required Map<String, dynamic> parameters,
  }) async {
    String finalUrl = appConfig.baseUrl + endPoint;

    if (parameters.isNotEmpty) {
      finalUrl +=
          "?${parameters.entries.map((e) => "${e.key}=${e.value}").join("&")}";
    }
    var request = http.Request('PUT', Uri.parse(finalUrl));
    http.StreamedResponse response = await _safeApiCall(request);
    return await decodeResponse(response);
  }

  Future<String> deleteCall({
    required String endPoint,
    required Map<String, dynamic> parameters,
  }) async {
    String finalUrl = appConfig.baseUrl + endPoint;

    if (parameters.isNotEmpty) {
      finalUrl +=
          "?${parameters.entries.map((e) => "${e.key}=${e.value}").join("&")}";
    }
    var request = http.Request('DELETE', Uri.parse(finalUrl));
    http.StreamedResponse response = await _safeApiCall(request);
    return await decodeResponse(response);
  }

  Future<String> manualCall({
    required String url,
    required String method,
    required Map<String, dynamic> pathParameters,
    required Map<String, String> headers,
    required String body,
  }) async {
    String finalUrl = url;
    if (pathParameters.isNotEmpty) {
      finalUrl +=
          "?${pathParameters.entries.map((e) => "${e.key}=${e.value}").join("&")}";
    }
    var request = http.Request(method.toUpperCase(), Uri.parse(finalUrl));
    request.body = body;
    request.headers.addAll(headers);
    http.StreamedResponse response = await _safeApiCall(request);
    return await decodeResponse(response);
  }
}
