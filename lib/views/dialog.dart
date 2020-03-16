import 'package:flutter/material.dart';
import 'package:pyco/input.dart';

Future<T> showDialogSingleAction<T>({
  @required BuildContext context,
  bool barrierDismissible = true,
  String titleText,
  String messageText = 'message',
  String actionText = 'action',
  Function opTapAction,
}) {
  return showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (_) => AlertDialog(
      title: isNull(titleText)
          ? null
          : Container(
              child: Text(
                titleText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
      titlePadding: EdgeInsets.only(
        top: 15,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0,
      ),
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 36,
              ),
              child: Text(
                messageText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Text(
                  actionText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                // Hide popup
                Navigator.of(context).pop();

                if (opTapAction != null) {
                  opTapAction();
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Future<T> showDialogError<T>(BuildContext context) {
  final titleText = 'Error';
  final messageText = 'Something is wrong!';
  final actionText = 'OK';

  return showDialogSingleAction(
    context: context,
    barrierDismissible: false,
    titleText: titleText,
    messageText: messageText,
    actionText: actionText,
    opTapAction: null,
  );
}

Future<T> showDialogErrorWithMessage<T>(
    {BuildContext context, String message}) {
  String titleText = 'Error';
  String actionText = 'OK';

  return showDialogSingleAction(
    context: context,
    barrierDismissible: false,
    titleText: titleText,
    messageText: message,
    actionText: actionText,
    opTapAction: null,
  );
}
