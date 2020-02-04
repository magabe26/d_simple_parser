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
  String _char;

  CharParser(String char) {
    _char = char[0];
  }

  @override
  Result parseOn(Context context) {
    final buffer = context.buffer;
    final position = context.position;
    if (position < buffer.length) {
      if (buffer[position] == _char) {
        final start = position;
        final end = start + _char.length;
        return Success(start, end);
      } else {
        return Failure(position);
      }
    }
    return Failure(buffer.length);
  }
}

class _LastCharParserDelegate extends Parser {
  @override
  Result parseOn(Context context) {
    final buffer = context.buffer;
    final position = context.position;
    if (position == buffer.length - 1) {
      return Success(position, buffer.length);
    } else {
      return Failure(position, 'Not the end of input');
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
    final position = context.position;
    if (position == 0) {
      return Success(position, 1);
    } else {
      return Failure(position, 'Not the end of input');
    }
  }
}

Parser char(String char) => CharParser(char);

Parser firstChar() => FirstCharParser();

Parser lastChar() => LastCharParser();

Parser remainingChars() => any(end: lastChar()).star().seq(lastChar());

Parser charsBefore({@required Parser parser}) => any(end: parser).star();

Parser newLine() => char('\n');
