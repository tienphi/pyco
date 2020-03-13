import 'package:flutter/material.dart';

import 'reponse_handler.dart';

class AppException implements Exception {
  int code;
  String message;

  AppException({
    @required this.code,
    @required this.message,
  });

  AppException.netWorkConnectException() {
    code = NETWORK_CONNECT_EXCEPTION_CODE;
    message = 'CREATE REQUEST ERROR: NETWORK CONNECT ERROR';
  }

  AppException.strangeStatusCodeException() {
    code = STRANGE_RESPONSE_STATUS_EXCEPTION_CODE;
    message = 'RESPONSE ERROR: STATUS NOT EQUAL 0 OR 1';
  }

  AppException.otherException(this.message) {
    code = OTHER_EXCEPTION_CODE;
  }
}
