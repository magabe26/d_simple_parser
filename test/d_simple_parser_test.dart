/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:d_simple_parser/d_simple_parser.dart';
import 'package:test/test.dart';

void main() {
  group('>> ', () {
    test("A call to char('c').parse('chura', 0) should return a Success", () {
      final result = char('c').parse('chura', 0);
      expect(result, isA<Success>());
      expect((result as Success).value, 'c');
    });

    test("A call to char('c').parse('chura', 0) should return a Failure", () {
      final result = char('c').parse('chura', 1);
      expect(result, isA<Failure>());
      expect((result as Failure).position, 1);
    });

    test(
        "A call to char('c').seq(char('h')).parse('chura', 0) should return a Success",
        () {
      final result = char('c').seq(char('h')).parse('chura', 0);
      expect(result, isA<Success>());
      expect((result as Success).value, 'ch');
      expect((result as Success).start, 0);
      expect((result as Success).end, 2);
    });

    test(
        "A call to char('c').seq(char('h')).parse('chura', 0) should return a Failure",
        () {
      final result = char('c').seq(char('h')).parse('chura', 2);
      expect(result, isA<Failure>());
      expect((result as Failure).position, 2);
    });

    test(
        "A call to char('c').or(char('h')).parse('chura', 0)  should return a Success",
        () {
      final result = char('c').or(char('h')).parse('chura', 0);
      expect((result as Success).value, 'c');
    });

    test(
        "A call to char('k').or(char('h')).parse('chura', 1)  should return a Success",
        () {
      final result = char('k').or(char('h')).parse('chura', 1);
      expect((result as Success).value, 'h');
    });

    test(
        "A call to char('k').or(char('h')).parse('chura', 0)  should return a Failure",
        () {
      final result = char('k').or(char('h')).parse('chura', 0);
      expect(result, isA<Failure>());
      expect((result as Failure).position, 0);
    });

    test(
        "A call to char('c').seq(char('h')).allStringMatch('chura chura teja', 0)  should return ['ch','ch']",
        () {
      final result =
          char('c').seq(char('h')).allStringMatches('chura chura teja', 0);

      expect(result, ['ch', 'ch']);
    });

    test(
        "A call to string('chura',caseSensitive: false).allStringMatch(' ChuRA')  should return ['ChuRA']",
        () {
      expect(string('chura', caseSensitive: false).allStringMatches(' ChuRA'),
          ['ChuRA']);
    });

    test("A call to string('chura').allStringMatch(' ChuRA')  should return []",
        () {
      expect(string('chura').allStringMatches(' ChuRA'), []);
    });

    test("A call to space().parse('') should return a Failure", () {
      expect(space().parse(''), isA<Failure>());
    });

    test("A call to spaceOptional().parse('') should return a Success", () {
      expect(spaceOptional().parse(''), isA<Success>());
    });

    group('spaceOptional() And start() tests |', () {
      Parser parser1, parser2;

      setUp(() {
        parser1 = char('<')
            .seq(string('tag'))
            .seq(spaceOptional())
            .seq(char('/').optional())
            .seq(char('>'));

        parser2 = char('<')
            .seq(string('tag'))
            .seq(spaceOptional())
            .seq(char('/').star())
            .seq(char('>'));
      });
      test(
          "A call to char('<').seq(string('tag')).seq(spaceOptional()).seq(char('/').optional()).seq(char('>')).firstStringMatch('<tag></tag>') should return '<tag>'",
          () {
        expect(parser1.firstStringMatch('<tag></tag>'), '<tag>');
      });

      test(
          "A call to char('<').seq(string('tag')).seq(spaceOptional()).seq(char('/').optional()).seq(char('>')).firstStringMatch('<tag/><i></i>') should return '<tag/>'",
          () {
        expect(parser1.firstStringMatch('<tag/><i></i>'), '<tag/>');
      });

      test(
          "A call to char('<').seq(string('tag')).seq(spaceOptional()).seq(char('/').optional()).seq(char('>')).firstStringMatch('<tag /><i></i>') should return '<tag />'",
          () {
        expect(parser1.firstStringMatch('<tag /><i></i>'), '<tag />');
      });

      test(
          "A call to char('<').seq(string('tag')).seq(spaceOptional()).seq(char('/').optional()).seq(char('>')).firstStringMatch('<tag //><i></i>') should return null",
          () {
        expect(parser1.firstStringMatch('<tag //><i></i>'), null);
      });

      test(
          "A call to char('<').seq(string('tag')).seq(spaceOptional()).seq(char('/').star()).seq(char('>')).firstStringMatch('<tag //><i></i>') should return '<tag //>'",
          () {
        expect(parser2.firstStringMatch('<tag //><i></i>'), '<tag //>');
      });
    });

    group('firstChar() and lastChar() tests |', () {
      test(
          "A call to firstChar().firstStringMatch('I am Awesome!',0) should return 'I'",
          () {
        expect(firstChar().firstStringMatch('I am Awesome!', 0), 'I');
      });

      test(
          "A call to firstChar().firstStringMatch('I am Awesome!',2) should return null",
          () {
        expect(firstChar().firstStringMatch('I am Awesome!', 2), null);
      });

      test(
          "A call to lastChar().firstStringMatch('I am Awesome!') should return '!'",
          () {
        expect(lastChar().firstStringMatch('I am Awesome!'), '!');
      });

      test(
          "A call to any(end: lastChar()).star().seq(lastChar()).parse('I am Awesome!') should return 'I am Awesome!'",
          () {
        expect(
            any(end: lastChar())
                .star()
                .seq(lastChar())
                .firstStringMatch('I am Awesome!'),
            'I am Awesome!');
      });

      test(
          "A call to firstChar().seq(any(end: lastChar()).seq(lastChar())).firstStringMatch('I am Awesome!') should return 'I am Awesome!'",
          () {
        expect(
            firstChar()
                .seq(any(end: lastChar()).star().seq(lastChar()))
                .firstStringMatch('I am Awesome!'),
            'I am Awesome!');
      });

      test(
          "A call to allInput().firstStringMatch('I am Awesome!') should return 'I am Awesome!'",
          () {
        expect(allInput().firstStringMatch('I am Awesome!'), 'I am Awesome!');
      });
    });

    group('pattern() tests |', () {
      test(
          "A call to pattern('a-zA-Z').plus().seq(spaceOptional()).seq(pattern('0-9').plus()).firstStringMatch('Welcome Year 2020 !') should return 'Year 2020'",
          () {
        expect(
            pattern('a-zA-Z')
                .plus()
                .seq(spaceOptional())
                .seq(pattern('0-9').plus())
                .firstStringMatch('Welcome Year 2020 !'),
            'Year 2020');
      });
    });

    group(' digit(), letter() and  repeat tests |', () {
      test(
          "A call to  digit().repeat(min: 2).seq(letter().repeat(min: 1)).firstStringMatch('01x2y') should return '01x'",
          () {
        expect(
            digit()
                .repeat(min: 2)
                .seq(letter().repeat(min: 1))
                .firstStringMatch('01x2y'),
            '01x');
      });

      test(
          "A call to digit().repeat(min: 1).seq(letter().repeat(min: 1)).allStringMatches('01x2y') should return '[1x, 2y]'",
          () {
        expect(
            digit()
                .repeat(min: 1)
                .seq(letter().repeat(min: 1))
                .allStringMatches('01x2y'),
            ['1x', '2y']);
      });
    });

    test("A call to word().firstStringMatch('Hello') return a 'H'", () {
      expect(word().firstStringMatch('Hello'), 'H');
    });

    test("A call to word().plus().firstStringMatch('Hello') return a 'Hello'",
        () {
      expect(word().plus().firstStringMatch('Hello'), 'Hello');
    });

    group('AnyCharacterParser tests |', () {
      test(
          "A call to (any(end: char('!')).star().parse('WELCOME TO TANZANIA !') as Success).value should return 'WELCOME TO TANZANIA '",
          () {
        expect(
            (any(end: char('!')).star().parse('WELCOME TO TANZANIA !')
                    as Success)
                .value,
            'WELCOME TO TANZANIA ');
      });

      test(
          "A call to any(end: space(),except: 'c').star().firstStringMatch('abc ') return a Failure'",
          () {
        expect(any(end: space(), except: 'c').star().firstStringMatch('abc '),
            'ab');
      });

      test(
          "A call to any(end: space(),except: 'c').star().parse('abd ') return a Success'",
          () {
        expect(any(end: space(), except: 'c').star().parse('abd '),
            isA<Success>());
      });

      test(
          "A call to any(end: space(),except: '^').plus().parse('ab^ ') return a Success'",
          () {
        expect(any(end: space(), except: '^').plus().parse('ab^ '),
            isA<Success>());
      });
    });

    group('Skipping tests |', () {
      test(
          'A call firstChar().skip().seq(remainingChars()).firstStringMatch(\'abcd\') to should return \'bcd\'',
          () {
        expect(
            firstChar().skip().seq(remainingChars()).firstStringMatch('abcd'),
            'bcd');
      });

      test(
          "any(end: char('c')).start().skip().seq(any(end: lastChar()).star().seq(lastChar())).parse('abcd') "
          'should be equal '
          "charsBefore(parser: char('c')).skip().seq(remainingChars()).parse('abcd'))",
          () {
        expect(
            any(end: char('c'))
                .star()
                .skip()
                .seq(any(end: lastChar()).star().seq(lastChar()))
                .parse('abcd'),
            charsBefore(parser: char('c'))
                .skip()
                .seq(remainingChars())
                .parse('abcd'));
      });

      test(
          "any(end: char('c')).star().skip().seq(any(end: lastChar())).star().seq(lastChar()).parse('abcd') "
          'should be equal '
          "charsBefore(parser: char('c')).skip().seq(remainingChars()).parse('abcd'))",
          () {
        expect(
            any(end: char('c'))
                .star()
                .skip()
                .seq(any(end: lastChar()))
                .star()
                .seq(lastChar())
                .parse('abcd'),
            charsBefore(parser: char('c'))
                .skip()
                .seq(remainingChars())
                .parse('abcd'));
      });
    });

    group('Text replacement tests | ', () {
      test(
          "When orginal and replacement have equal length, A call to char('a').replaceIn(input: 'ab a', replacement: '-') return '-b -'",
          () {
        expect(char('a').replaceIn(input: 'ab a', replacement: '-'), '-b -');
      });

      test(
          "When replacement has greater length, A call to char('a').replaceIn(input: 'ab a', replacement: '--') return '--b --'",
          () {
        expect(char('a').replaceIn(input: 'ab a', replacement: '--'), '--b --');
      });

      test(
          "When replacement has smaller length, A call to char('a').replaceIn(input: 'ab a', replacement: '') return 'b '",
          () {
        expect(char('a').replaceIn(input: 'ab a', replacement: ''), 'b ');
      });
    });
  });
}
