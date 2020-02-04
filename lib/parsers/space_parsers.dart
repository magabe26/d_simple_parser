/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import '../core/core.dart';
import 'char_parsers.dart';

Parser spaceOptional() => char('\u0020').star();

Parser space() => char('\u0020').plus();
