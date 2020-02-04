/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import '../core/core.dart';
import 'package:meta/meta.dart';

class AnyCharacterParser extends Parser {
  Parser end;
  Pattern except;

  AnyCharacterParser(this.end, {this.except}) : assert(end != null);

  @override
  Result parseOn(Context context) {
    final buffer = context.buffer;
    final position = context.position;

    if (end == null) {
      return Failure(position, 'AnyCharacterParser: end parser is null');
    } else {
      final match = end.firstMatch(buffer, position);
      if (match.isSuccess) {
        final end = (match as Success).start;
        if (position < end) {
          if (except == null) {
            return Success(position, position + 1);
          }
          final regex = RegExp('[^$except]');
          final match = regex.matchAsPrefix(buffer, position);
          if (match != null) {
            return Success(position, position + 1);
          } else {
            return Failure(
                position, 'AnyCharacterParser: unwanted character found');
          }
        } else {
          return Failure(position, 'AnyCharacterParser: no character found');
        }
      } else {
        return Failure(position, 'AnyCharacterParser: end not found');
      }
    }
  }
}

Parser any({@required Parser end, Pattern except}) =>
    AnyCharacterParser(end, except: except);
