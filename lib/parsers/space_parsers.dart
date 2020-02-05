/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import '../core/core.dart';
import 'char_parsers.dart';

final _whitespaceChar = (char('\u0009') |
    char('\u000A') |
    char('\u000B') |
    char('\u000C') |
    char('\u000D') |
    char('\u0020') |
    char('\u0085') |
    char('\u00A0') |
    char('\u1680') |
    char('\u2000') |
    char('\u2001') |
    char('\u2002') |
    char('\u2003') |
    char('\u2004') |
    char('\u2005') |
    char('\u2006') |
    char('\u2007') |
    char('\u2008') |
    char('\u2009') |
    char('\u200A') |
    char('\u2028') |
    char('\u2029') |
    char('\u202F') |
    char('\u205F') |
    char('\u3000') |
    char('\uFEFF'));

Parser spaceOptional() => _whitespaceChar.star();

Parser space() => _whitespaceChar.plus();
