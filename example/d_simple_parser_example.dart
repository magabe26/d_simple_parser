/**
 * Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
 * Author Edwin Magabe    edyma50@yahoo.com
 */

import 'package:d_simple_parser/d_simple_parser.dart';

void main() {

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

 print(anyElement.allStringMatches(input));


}