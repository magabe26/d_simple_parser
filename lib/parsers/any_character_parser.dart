/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import '../core/core.dart';
import 'package:meta/meta.dart';

class AnyCharacterParser extends Parser {
  final Parser end;
  final Pattern except;

  AnyCharacterParser(this.end, {this.except}) : assert(end != null);

  @override
  Result parseOn(Context context) {
    if (end == null) {
      return Failure(
          context.position, 'AnyCharacterParser: end parser is null');
    } else {
      final match = end.firstMatch(context.buffer, context.position);
      if (match.isSuccess) {
        if (context.position < ((match as Success).start)) {
          if (except == null) {
            return Success(context.position, context.position + 1);
          }

          if (RegExp('[^$except]')
                  .matchAsPrefix(context.buffer, context.position) !=
              null) {
            return Success(context.position, context.position + 1);
          } else {
            return Failure(context.position,
                'AnyCharacterParser: unwanted character found');
          }
        } else {
          return Failure(
              context.position, 'AnyCharacterParser: no character found');
        }
      } else {
        return Failure(context.position, 'AnyCharacterParser: end not found');
      }
    }
  }
}

Parser any({@required Parser end, Pattern except}) =>
    AnyCharacterParser(end, except: except);
