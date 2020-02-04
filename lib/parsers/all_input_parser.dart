/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import '../core/core.dart';
import 'parsers.dart';

///Parses the entire input
/// For example:
///   allInput().firstStringMatch('I am Awesome!') returns 'I am Awesome!'
Parser allInput() => firstChar().seq(any(end: lastChar()).star().seq(lastChar()));
