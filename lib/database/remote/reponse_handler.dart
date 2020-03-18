import 'package:flutter/material.dart';
import 'package:pyco/views/dialog.dart';

import 'app_exception.dart';

typedef ResponseSuccessCallback<T> = void Function(T response);
typedef ResponseErrorCallback = void Function(AppException);

const NETWORK_CONNECT_EXCEPTION_CODE = 503;
const STRANGE_RESPONSE_STATUS_EXCEPTION_CODE = 1000;
const FORMAT_EXCEPTION_CODE = 1500;
const OTHER_EXCEPTION_CODE = 2000;
const RESPONSE_ERROR_ERROR_MESSAGE = 'response_error_error_message';
const RESPONSE_ERROR_ERROR_CODE = 'response_error_error_code';

class ResponseHandler {
  ResponseSuccessCallback onResponseSuccess;
  ResponseErrorCallback onResponseError;

  ResponseHandler({
    this.onResponseSuccess,
    this.onResponseError,
  });

  ResponseHandler.simple(
    BuildContext context, {
    this.onResponseSuccess,
    ResponseErrorCallback onResponseErrorOtherHandle,
  }) {
    this.onResponseError = (responseError) {
      String message;

      switch (responseError.code) {
        case NETWORK_CONNECT_EXCEPTION_CODE:
          {
            message = 'Please check your network connection and try again!';
            break;
          }
        case STRANGE_RESPONSE_STATUS_EXCEPTION_CODE:
          {
            message = 'Strange response status code!';
            break;
          }
        default:
          {
            message = responseError.message;
          }
      }

      if (onResponseErrorOtherHandle != null) {
        onResponseErrorOtherHandle(responseError);
      }

      showDialogErrorWithMessage(
        context: context,
        message: message,
      );
    };
  }
}
