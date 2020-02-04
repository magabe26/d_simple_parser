/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import '../core/core.dart';

class PatternParser extends Parser {
  final Pattern pattern;

  PatternParser(this.pattern) : assert(pattern != null);

  @override
  Result parseOn(Context context) {
    final buffer = context.buffer;
    final position = context.position;
    if (pattern == null) {
      return Failure(position);
    }
    final match = RegExp('[$pattern]').matchAsPrefix(buffer, position);
    if (match != null) {
      return Success(position, match.end);
    } else {
      return Failure(position);
    }
  }
}

Parser pattern(Pattern pattern) => PatternParser(pattern);

Parser letter() => pattern('a-zA-Z');

Parser digit() => pattern('0-9');

Parser word() => (letter() | digit());
