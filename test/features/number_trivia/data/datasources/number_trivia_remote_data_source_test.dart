import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client{}

void main(){
  NumberTriviaRemoteDataSourceImpl datasouce;
  MockHttpClient mockHttpClient;
  final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

  setUp((){
    mockHttpClient = MockHttpClient();
    datasouce = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttp200Sucess(){
     when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }
  void setUpMockHttp404Failure(){
     when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Server response time exceeded', 404));
  }

  group("getContreteNumberTrivia", (){
    final tNumber = 1;
    test(
      'should perform Get request on a URL with number being the endpoint and with application/json header',
        () async {
        // arrange
        setUpMockHttp200Sucess();
        // act
        datasouce.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockHttpClient.get('http://numbersapi/$tNumber', headers: {'Content-Type':'application/json'} ));
        
    
        }
    );
    test(
      'should return NumberTrivia if the response code is 200',
        () async {
        setUpMockHttp200Sucess();
        // act
        NumberTrivia result = await datasouce.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, tNumberTriviaModel);
        }
    );
     test(
      'should return ServerException if the response code is not 200',
        () async {
          setUpMockHttp404Failure();
        // act
          final call = datasouce.getConcreteNumberTrivia;
        //assert
          expect(()=> call(tNumber), throwsA(TypeMatcher<ServerException>()));
        }
    );

  });
  group("getRandomNumberTrivia", (){
    final tNumber = 1;
    test(
      'should perform Get request on a URL with number being the endpoint and with application/json header',
        () async {
        // arrange
        setUpMockHttp200Sucess();
        // act
        datasouce.getRandomNumberTrivia();
        //assert
        verify(mockHttpClient.get('http://numbersapi/random', headers: {'Content-Type':'application/json'} ));
        
    
        }
    );
    test(
      'should return NumberTrivia if the response code is 200',
        () async {
        setUpMockHttp200Sucess();
        // act
        NumberTrivia result = await datasouce.getRandomNumberTrivia();
        //assert
        expect(result, tNumberTriviaModel);
        }
    );
     test(
      'should return ServerException if the response code is not 200',
        () async {
          setUpMockHttp404Failure();
        // act
          final call = datasouce.getRandomNumberTrivia;
        //assert
          expect(()=> call(), throwsA(TypeMatcher<ServerException>()));
        }
    );

  });
}
