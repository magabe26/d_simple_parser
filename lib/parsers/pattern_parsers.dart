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
    if (pattern == null) {
      return Failure(context.position);
    }
    final match =
        RegExp('[$pattern]').matchAsPrefix(context.buffer, context.position);
    if (match != null) {
      return Success(context.position, match.end);
    } else {
      return Failure(context.position);
    }
  }
}

Parser pattern(Pattern pattern) => PatternParser(pattern);

Parser letter() => pattern('a-zA-Z');

Parser digit() => pattern('0-9');

Parser word() => (letter() | digit());
