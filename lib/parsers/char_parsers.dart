/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import '../core/context.dart';
import '../core/parser.dart';
import '../core/result.dart';
import 'package:meta/meta.dart';
import 'any_character_parser.dart';

class CharParser extends Parser {
  int _codeUnit;

  CharParser(String char) {
    _codeUnit = char.codeUnitAt(0);
  }

  @override
  Result parseOn(Context context) {
    if (context.position < context.buffer.length) {
      if (context.buffer.codeUnitAt(context.position) == _codeUnit) {
        final start = context.position;
        final end = start + 1;
        return Success(start, end);
      } else {
        return Failure(context.position);
      }
    }
    return Failure(context.buffer.length);
  }
}

class _LastCharParserDelegate extends Parser {
  @override
  Result parseOn(Context context) {
    if (context.position == context.buffer.length - 1) {
      return Success(context.position, context.buffer.length);
    } else {
      return Failure(context.position, 'Not the end of input');
    }
  }
}

class LastCharParser extends Parser {
  @override
  Result parseOn(Context context) {
    return _LastCharParserDelegate().plus().parseOn(context);
  }
}

class FirstCharParser extends Parser {
  @override
  Result parseOn(Context context) {
    if (context.position == 0) {
      return Success(context.position, 1);
    } else {
      return Failure(context.position, 'Not the end of input');
    }
  }
}

Parser char(String char) => CharParser(char);

Parser firstChar() => FirstCharParser();

Parser lastChar() => LastCharParser();

Parser remainingChars() => any(end: lastChar()).star().seq(lastChar());

Parser charsBefore({@required Parser parser}) => any(end: parser).star();

Parser newLine() => char('\n');
