import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';


void main(){
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text:'test');


  test(
    'should be a subclass of NumberTrivia Entity',
      () async {
      // arrange
  
      // act
  
      //assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
  
      }
  );

  group('fromJson', (){
    test(
      'should return a valid model when the JSON number is an integer',
        () async {
        // arrange
        final Map<String, dynamic> jsonMap = 
          json.decode(fixture('trivia.json'));
        // act
    
        //assert
    
        }
    );
  });

}