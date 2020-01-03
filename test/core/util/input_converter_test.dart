import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/util/input_converter.dart';

void main(){
  InputConverter converter;
  setUp((){
    converter = InputConverter();
  });

  group('stringToUnsignedIntegerConversion', (){
    int tPositive5Integer = 5;
    String tPositive5String  = '5';
    String tNegative5String  = '-5';
    String tAnUnparsableString  = 'tritratralla';
    test(
      'should return a valid Integer for a String containing a positiv number',
        () async {
        // arrange
    
        // act
        dynamic result = converter.stringTOUnsignedInteger(tPositive5String);
        //assert
        expect(result, Right(tPositive5Integer));
    
        }
    );
    test('should return a Failure if String is not a parsable integer',
        () async {
        // arrange
    
        // act
        dynamic result = converter.stringTOUnsignedInteger(tAnUnparsableString);
        //assert
        expect(result, Left(InvalidInputFailure()));
    
        }
        
    );
    test('should return a Failure if String is not a positive integer',
        () async {
        // arrange
    
        // act
        dynamic result = converter.stringTOUnsignedInteger(tNegative5String);
        //assert
        expect(result, Left(InvalidInputFailure()));
    
        }
        
    );
  });

  
}