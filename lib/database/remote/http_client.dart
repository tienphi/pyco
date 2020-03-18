import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_exception.dart';
import 'reponse_handler.dart';

const BASE_URL = 'https://randomuser.me/api/0.4/';

String createUrlFromPath(String path) => '$BASE_URL$path';

Future<void> createRequest<T extends http.Response>(
  Future<T> request, {
  @required ResponseHandler responseHandler,
}) async {
  try {
    final response = await request;
    print('RESPONSE: ${response.body}');
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    print('RESPONSE: $responseData');
    responseHandler.onResponseSuccess(responseData["results"]);
  } on SocketException catch (_) {
    // SocketException: Network connection error?
    final exception = AppException.netWorkConnectException();
    responseHandler.onResponseError(exception);
  } on FormatException catch (_) {
    final exception = AppException.formatException();
    responseHandler.onResponseError(exception);
  } catch (error) {
    // Other exception
    final exception = AppException.otherException(error.toString());
    responseHandler.onResponseError(exception);
  }
}

Future<void> createGetRequest<T extends http.Response>({
  @required String url,
  @required ResponseHandler responseHandler,
}) async {
  print('GET URL: $url');

  final request = http.get(url);
  return createRequest(request, responseHandler: responseHandler);
}
