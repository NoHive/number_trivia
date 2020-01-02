import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource{
    /// Calls the numbers api http://numbersapi.com/{number}
    /// throws a [ServerException] for all error codes
    Future <NumberTriviaModel> getConcreteNumberTrivia(int number);
    /// Calls the numbers api http://numbersapi.com/random
    /// throws a [ServerException] for all error codes
    Future <NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource{
  
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client}); 
  
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async{
    // TODO: implement getConcreteNumberTrivia
    
      final resonse = await client.get('http://numbersapi/$number', headers: {'Content-Type':'application/json'} );
      if(resonse.statusCode != 200){
        throw ServerException();
      }else{
        return NumberTriviaModel.fromJson(json.decode(resonse.body));
      }
    
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    return null;
  }
}