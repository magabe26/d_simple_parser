A simple and easy to use text parsing dart library,```d_simple_parser``` comes with elegant parsers that you can use to build complex and more elegant parsers.

## Usage

A simple usage example:

```dart
import 'package:d_simple_parser/d_simple_parser.dart';

void main() {
  
    print((char('a') | char('b')).seq(char('c')).firstStringMatch('abc')); // bc
           // is the same as writing
    print(char('a').or(char('b')).seq(char('c')).firstStringMatch('abc')); // bc
           // is the same as writing
    print(((char('a') | char('b')) & char('c')).firstStringMatch('abc')); // bc


  
    print(char('a').seq(spaceOptional()).seq(char('b')).allStringMatches('ab a b a    b')); // [ab, a b, a    b]
  
    print(letter().seq(space()).seq(digit()).firstStringMatch('Yes!, I agree , year 2019 was not the best year for me.')); // r 2
    // is the same as writing
    print(pattern('a-zA-Z').seq(char(' ').plus()).seq(pattern('0-9')).firstStringMatch('Yes!, I agree , year 2019 was not the best year for me.'));// r 2
    
    print(letter().plus().seq(space()).seq(digit().plus()).firstStringMatch('Yes!, I agree , year 2019 was not the best year for me.')); // year 2019
    // is the same as writing
    print(pattern('a-zA-Z').plus().seq(char(' ').plus()).seq(pattern('0-9').plus()).firstStringMatch('Yes!, I agree , year 2019 was not the best year for me.')); // year 2019

  
    //The almighty any(end,except) function
    var awesomeParser = string('awesome',caseSensitive: false).seq(char('!'));
    print(any(end: awesomeParser).firstStringMatch('I am Awesome!')); // I
    print(any(end: awesomeParser).plus().firstStringMatch('I am Awesome!')); // I am 
    print(any(end: awesomeParser).plus().seq(awesomeParser).firstStringMatch('I am Awesome!')); // I am Awesome!

    final startTagParser = char('<').seq(any(end: char('>'),except: '<>').plus()).seq(char('>'));
    final endTagParser = char('<').seq(word().plus()).seq(char('/')).seq(spaceOptional()).seq(char('>'));
    final elementParser = startTagParser.seq(any(end: endTagParser).plus()).seq(endTagParser);
    print(startTagParser.firstStringMatch('<i>42<i/>')); // <i>
    print(endTagParser.firstStringMatch('<i>42<i/>')); // <i/>
    print(elementParser.firstStringMatch('<i>42<i/>')); // <i>42<i/>

  
    print(allInput().firstStringMatch('Hello world!')); // Hello world!
  
    //hasMatch method
    print(char('a').hasMatch('bc')); // false
    print(char('b').hasMatch('bc')); // true
    print(char('c').hasMatch('bc')); // true

    //replaceIn method
    print(char('b').replaceIn(input: 'bc', replacement: 'ab')); // abc
        //replace multiple spaces with a single space
    print(space().replaceIn(input: 'I         am         Awesome!  ', replacement: ' ')); // I am Awesome!

    //replaceInMapped
    print(letter().replaceInMapped(input: 'abc', replace: (match){
      return match == 'b' ? 'B' : match;
    })); //aBc
 
    //removeFrom method
    print(char('a').seq(char('b')).seq(char('c')).removeFrom('abcdefg')); // defg

   //repeat method
   print(char('a').repeat(min:2,max:3).allStringMatches('aaaaaa aa aaa aa aaaaaa aaa a aa')); // [aaa, aaa, aa, aaa, aa, aaa, aaa, aaa, aa]

   //Lastly, A parser that parses most of HTML and XML elements

  final input = '''<k>
           <tag attr1="attribute1"> Text </tag>
           <TAG> TEXT </TAG>
           <i></i>
           <b/>
           <v href="qwety"/></k>
        ''';

 var anyElement = (spaceOptional().seq(spaceOptional().seq(char('<').seq(any(end:char('>'),except:'/').star()).seq(char('>'))).seq(spaceOptional()) & (spaceOptional().seq(spaceOptional().seq (char('<').seq(any(end:char('>'),except:'/').star()).seq(char('>')))
     .seq(spaceOptional()).seq((spaceOptional().seq(spaceOptional().seq (char('<').seq(any(end:char('>'),except:'/').star()).seq(char('>')))
     .seq(spaceOptional()).seq(any(end:spaceOptional().seq(char('<').seq(char('/')).seq(spaceOptional()).seq(word().plus()).seq(spaceOptional()).seq(char('>')))
     .seq(spaceOptional()),except:'<>').plus()).seq(spaceOptional().seq(char('<').seq(char('/')).seq(spaceOptional()).seq(word().plus()).seq(spaceOptional()).seq(char('>')))
     .seq(spaceOptional()))).seq(spaceOptional()) | spaceOptional().seq(spaceOptional().seq (char('<').seq(any(end:char('>'),except:'/').star()).seq(char('>'))).seq(spaceOptional()).seq(spaceOptional()).seq(spaceOptional().seq(char('<').seq(char('/')).seq(spaceOptional()).seq(word().plus()).seq(spaceOptional()).seq(char('>')))
     .seq(spaceOptional()))).seq(spaceOptional()) | spaceOptional().seq(char('<').seq(any(end:char('/').seq(char('>')),except:'<>').plus()).seq(char('/').seq(char('>'))))
     .seq(spaceOptional())).plus()).seq(spaceOptional().seq(char('<').seq(char('/')).seq(spaceOptional()).seq(word().plus()).seq(spaceOptional()).seq(char('>'))).seq(spaceOptional()))).seq(spaceOptional())  | spaceOptional().seq(spaceOptional().seq (char('<').seq(any(end:char('>'),except:'/').star()).seq(char('>')))
     .seq(spaceOptional()).seq(any(end:spaceOptional().seq(char('<').seq(char('/')).seq(spaceOptional()).seq(word().plus()).seq(spaceOptional()).seq(char('>'))).seq(spaceOptional()),except:'<>').plus()).seq(spaceOptional().seq(char('<').seq(char('/')).seq(spaceOptional()).seq(word().plus()).seq(spaceOptional()).seq(char('>'))).seq(spaceOptional())))
     .seq(spaceOptional()) | spaceOptional().seq(spaceOptional().seq (char('<').seq(any(end:char('>'),except:'/').star()).seq(char('>'))).seq(spaceOptional()).seq(spaceOptional()).seq(spaceOptional().seq(char('<').seq(char('/')).seq(spaceOptional()).seq(word().plus()).seq(spaceOptional()).seq(char('>'))).seq(spaceOptional())))
     .seq(spaceOptional()) | spaceOptional().seq(char('<').seq(any(end:char('/').seq(char('>')),except:'<>').plus()).seq(char('/').seq(char('>')))).seq(spaceOptional()) | spaceOptional().seq (char('<').seq(any(end:char('>'),except:'/').star()).seq(char('>'))).seq(spaceOptional()) | word().plus() | char('<').seq(char('!')).seq(char('-')).seq(char('-'))
     .seq(any(end:char('-').seq(char('-')).seq(char('>'))).star()).seq(char('-').seq(char('-')).seq(char('>'))))
     .star() & spaceOptional().seq(char('<').seq(char('/')).seq(spaceOptional()).seq(word().plus()).seq(spaceOptional()).seq(char('>')))
     .seq(spaceOptional())).seq(spaceOptional())).or(spaceOptional().seq(char('<').seq(any(end:char('/').seq(char('>')),except:'<>').plus()).seq(char('/').seq(char('>'))))
     .seq(spaceOptional()) | spaceOptional().seq (char('<').seq(any(end:char('>'),except:'/').star()).seq(char('>'))).seq(spaceOptional()) | char('<').seq(char('!')).seq(char('-')).seq(char('-')).seq(any(end:char('-').seq(char('-')).seq(char('>'))).star()).seq(char('-').seq(char('-')).seq(char('>'))));

 print(anyElement.allStringMatches(input)); // [<k>,            <tag attr1="attribute1"> Text </tag>,            <TAG> TEXT </TAG>,            <i></i>,            <b/>,            <v href="qwety"/>]

   

}
```

 For more examples on how to use ```d_simple_parser``` see ```d_simple_parser_test.dart```


