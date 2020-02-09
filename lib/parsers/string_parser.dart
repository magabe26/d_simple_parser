/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import '../core/core.dart';

class StringParser extends Parser {
  final String string;
  final bool caseSensitive;

  StringParser(
    this.string, {
    this.caseSensitive = true,
  });

  int _failedAt = -1;

  @override
  Result parseOn(Context context) {
    if (string == null) {
      return Failure(context.position, 'Failed , the string is null');
    }

    if (context.position < context.buffer.length) {
      if ((_failedAt != -1) && (context.position <= _failedAt)) {
        return Failure(context.position, 'Failed , No match found');
      }

      var end = context.position;
      for (var i = 0; i < string.length; i++, end++) {
        final charInBuffer = context.buffer[end];
        final charInString = string[i];
        final match = caseSensitive
            ? (charInString == charInBuffer)
            : ((charInString.toLowerCase() == charInBuffer) ||
                (charInString.toUpperCase() == charInBuffer));

        if (!match) {
          _failedAt = end;
          return Failure(_failedAt, 'Failed , No match found');
        }
      }
      _failedAt = -1;
      return Success(context.position, end);
    } else {
      return Failure(context.buffer.length, 'Failed , No match found');
    }
  }
}

Parser string(
  String string, {
  bool caseSensitive = true,
}) =>
    StringParser(string, caseSensitive: caseSensitive);
