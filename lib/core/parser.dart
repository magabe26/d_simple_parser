/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'context.dart';
import 'result.dart';
import 'package:meta/meta.dart';

abstract class Parser {
  Result firstMatch(String input, [int start = 0]) {
    final skipPosition = _getSkipPosition(input, start);
    var position = (skipPosition != -1) ? skipPosition : start;

    var message = '';
    while ((position >= 0) && (position < input.length)) {
      var result = parse(input, position);
      if (result.isSuccess) {
        return result;
      } else {
        message = (result as Failure).message;
        position++;
      }
    }
    return Failure(position, message);
  }

  String firstStringMatch(String input, [int start = 0]) {
    final result = firstMatch(input, start);
    if (result.isSuccess) {
      return (result as Success).value;
    } else {
      return null;
    }
  }

  Result lastMatch(String input, [int start = 0]) {
    final matches = allMatches(input, start);
    return (matches.isNotEmpty) ? matches.last : Failure(start);
  }

  String lastStringMatch(String input, [int start = 0]) {
    final match = lastMatch(input, start);
    if (match.isSuccess) {
      return (match as Success).value;
    } else {
      return null;
    }
  }

  List<String> allStringMatches(String input, [int start = 0]) {
    return allMatches(input, start).map((success) => success.value).toList();
  }

  List<Success> allMatches(String input, [int start = 0]) {
    final list = <Success>[];
    final skipPosition = _getSkipPosition(input, start);
    var position = (skipPosition != -1) ? skipPosition : start;

    while ((position >= 0) && (position < input.length)) {
      var result = parse(input, position);
      if (result.isSuccess) {
        final value = (result as Success).value;
        if (value.isNotEmpty) {
          list.add(result);
        }
        if (position == (result as Success).end) {
          position++;
        } else {
          position = (result as Success).end;
        }
      } else {
        position++;
      }
    }
    return list;
  }

  Result parse(String input, [int start = 0]) {
    final skipPosition = _getSkipPosition(input, start);
    start = (skipPosition != -1) ? skipPosition : start;

    RangeError.checkValidRange(start, input.length, input.length);
    final result = parseOn(Context(input, start));
    if (result.isSuccess) {
      final start = (result as Success).start;
      final end = (result as Success).end;
      RangeError.checkValidRange(start, end, input.length);
      return (result as Success).setValue(input.substring(start, end));
    } else {
      return result;
    }
  }

  int _getSkipPosition(String input, int start) {
    var list = <SkipParser>[];
    var parser = this;
    void addToList(Parser parser) {
      if ((parser.runtimeType == SkipParser) && (!list.contains(parser))) {
        list.add(parser);
      }
    }

    while ((parser != null)) {
      addToList(parser);
      if (parser.runtimeType == SeqParser) {
        parser = (parser as SeqParser).parsers.elementAt(0);
      } else if (parser.runtimeType == StarParser) {
        parser = (parser as StarParser).parser;
      } else if (parser.runtimeType == PlusParser) {
        parser = (parser as PlusParser).parser;
      } else if (parser.runtimeType == RepeatParser) {
        parser = (parser as RepeatParser).parser;
      } else if (parser.runtimeType == OptionalParser) {
        parser = (parser as OptionalParser).parser;
      } else if (parser.runtimeType == OrParser) {
        addToList((parser as OrParser).first);
        parser = (parser as OrParser).second;
      } else {
        parser = null;
      }
    }

    //if this is SkipParser and is included, removed it , also remove nulls
    list = list
        .where((skipParser) => (skipParser != this) || (skipParser == null))
        .toList();

    if (list.isEmpty) {
      return -1;
    } else {
      final skipParser = list.elementAt(0);
      return (skipParser.parse(input, start) as Success).end;
    }
  }

  Result parseOn(Context context);

  Parser seq(Parser parser) =>
      (parser != null) ? SeqParser([this, parser]) : this;

  Parser operator &(Parser parser) => seq(parser);

  Parser or(Parser other) => OrParser(this, other);

  Parser operator |(Parser other) => or(other);

  Parser optional() => OptionalParser(this);

  Parser star() => StarParser(this);

  Parser plus() => PlusParser(this);

  Parser repeat({@required int min, int max}) => RepeatParser(this, min, max);

  Parser skip() => SkipParser(this);

  String removeFrom(String input, [int start = 0, int count]) {
    return replaceIn(input: input, replacement: '', start: start, count: count);
  }

  String replaceIn({
    @required String input,
    @required String replacement,
    int start = 0,
    int count,
  }) {
    var output = input;
    var offset = 0;
    if ((start >= 0) && (start < output.length)) {
      final results = allMatches(output, start);
      if (results.isEmpty) {
        return output;
      }
      var c = 0;
      for (var result in results) {
        output = output.replaceRange(
            result.start - offset, result.end - offset, replacement);
        c++;
        offset += (result.value.length - replacement.length);
        if ((count != null) && (count == c)) {
          break;
        }
      }
      return output;
    } else {
      return output;
    }
  }

  String replaceInMapped({
    @required String input,
    @required String Function(String match) replace,
    int start = 0,
    int count,
  }) {
    var output = input;
    if (replace == null) {
      return output;
    }
    var offset = 0;
    if ((start >= 0) && (start < output.length)) {
      final results = allMatches(output, start);
      if (results.isEmpty) {
        return output;
      }
      var c = 0;
      for (var result in results) {
        final replacement = replace(result.value);
        output = output.replaceRange(
            result.start - offset, result.end - offset, replacement);
        c++;
        offset += (result.value.length - replacement.length);
        if ((count != null) && (count == c)) {
          break;
        }
      }
      return output;
    } else {
      return output;
    }
  }

  bool hasMatch(String input, [int start = 0]) {
    return firstMatch(input, start).isSuccess;
  }
}

class SeqParser extends Parser {
  final List<Parser> parsers;

  SeqParser(this.parsers);

  @override
  Result parseOn(Context context) {
    if ((parsers == null) || parsers.isEmpty) {
      return Failure(context.position, 'SeqParser: No parsers to sequence!');
    }

    if (parsers.elementAt(0).runtimeType == SkipParser) {
      try {
        return parsers.elementAt(1).parse(context.buffer, context.position);
      } catch (e) {
        return Failure(context.position, e.toString());
      }
    }

    var currentPosition = context.position;
    for (var i = 0; i < parsers.length; i++) {
      try {
        final result =
            parsers.elementAt(i).parse(context.buffer, currentPosition);
        if (result.isSuccess) {
          currentPosition = (result as Success).end;
        } else {
          return result;
        }
      } catch (e) {
        return Failure(currentPosition, e.toString());
      }
    }
    return Success(context.position, currentPosition)
        .setValue(context.buffer.substring(context.position, currentPosition));
  }
}

class OrParser extends Parser {
  final Parser first;
  final Parser second;

  OrParser(this.first, this.second)
      : assert(first != null),
        assert(second != null);

  @override
  Result parseOn(Context context) {
    try {
      var result = first.parse(context.buffer, context.position);
      if (result.isFailure) {
        try {
          result = second.parse(context.buffer, context.position);
        } catch (e) {
          result = Failure(context.position, e.toString());
        }
      }
      return result;
    } catch (_) {
      try {
        return second.parse(context.buffer, context.position);
      } catch (e) {
        return Failure(context.position, e.toString());
      }
    }
  }
}

class StarParser extends Parser {
  final Parser parser;

  StarParser(this.parser) : assert(parser != null);

  @override
  Result parseOn(Context context) {
    var currentPosition = context.position;
    var result;
    try {
      result = parser.parse(context.buffer, currentPosition);
      while (result.isSuccess) {
        currentPosition = (result as Success).end;
        try {
          result = parser.parse(context.buffer, currentPosition);
        } catch (_) {
          break;
        }
      }
      return Success(context.position, currentPosition);
    } catch (_) {
      return Success(context.position, currentPosition);
    }
  }
}

class PlusParser extends Parser {
  final Parser parser;

  PlusParser(this.parser) : assert(parser != null);

  @override
  Result parseOn(Context context) {
    var currentPosition = context.position;
    var success = false;
    var result;
    try {
      result = parser.parse(context.buffer, currentPosition);
      var message = '';
      while (result.isSuccess) {
        currentPosition = (result as Success).end;
        if (!success) {
          success = true;
        }
        try {
          result = parser.parse(context.buffer, currentPosition);
        } catch (e) {
          currentPosition = (result as Failure).position;
          message = e.toString();
          break;
        }
      }
      if (success) {
        return Success(context.position, currentPosition);
      } else {
        return Failure(currentPosition, message);
      }
    } catch (e) {
      return Failure(context.position, e.toString());
    }
  }
}

class OptionalParser extends Parser {
  final Parser parser;

  OptionalParser(this.parser) : assert(parser != null);

  @override
  Result parseOn(Context context) {
    try {
      final result = parser.parse(context.buffer, context.position);
      if (result.isSuccess) {
        return Success(context.position, (result as Success).end);
      } else {
        return Success(context.position, context.position);
      }
    } catch (_) {
      return Success(context.position, context.position);
    }
  }
}

class RepeatParser extends Parser {
  final Parser parser;
  final int min;
  int max;

  RepeatParser(this.parser, this.min, [this.max])
      : assert(parser != null),
        assert(min != null);

  @override
  Result parseOn(Context context) {
    var firstLoopEndedWithFailure = false;
    var success = false;
    var message = '';

    var currentPosition = context.position;
    for (var i = 0; i < min; i++) {
      try {
        final result = parser.parse(context.buffer, currentPosition);
        if (result.isSuccess) {
          currentPosition = (result as Success).end;
          if (!success) {
            success = true;
          }
        } else {
          message = (result as Failure).message;
          firstLoopEndedWithFailure = true;
          break;
        }
      } catch (e) {
        message = e.toString();
        firstLoopEndedWithFailure = true;
        break;
      }
    }

    if (firstLoopEndedWithFailure || (!success)) {
      return Failure(context.position, message);
    } else {
      if ((max == null) || (max <= min)) {
        return Success(context.position, currentPosition);
      } else {
        for (var i = 0; i < (max - min); i++) {
          try {
            final result = parser.parse(context.buffer, currentPosition);
            if (result.isSuccess) {
              currentPosition = (result as Success).end;
            }
          } catch (_) {
            break;
          }
        }
        return Success(context.position, currentPosition);
      }
    }
  }
}

class DebugParser extends Parser {
  @override
  Result parseOn(Context context) {
    print('>>> DebugParser:\n ${context.buffer}\n${context.position} <<<');
    return Success(context.position, context.position);
  }
}

Parser debug() => DebugParser();

///Skips the result of the parser if the passed parser succeed
class SkipParser extends Parser {
  final Parser parser;

  SkipParser(this.parser);

  @override
  Result parseOn(Context context) {
    if (parser != null) {
      try {
        final result = parser.parse(context.buffer, context.position);
        if (result.isSuccess) {
          return Success((result as Success).end, (result as Success).end);
        } else {
          return Success(context.position, context.position);
        }
      } catch (_) {
        return Success(context.position, context.position);
      }
    } else {
      return Success(context.position, context.position);
    }
  }
}
