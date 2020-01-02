import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource{
  /// Gets the last cached [NumberTriviaModel] 
  /// throws a [CacheException]
  Future<NumberTriviaModel> getLastNumberTrivia();
  /// Caches the submitted [NumberTriviaModel] to the local cache
  /// throws a [CacheException]
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const SHARED_PREFERENCES_KEY = 'NUMBER_TRIVIA_SP_KEY';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource{
  
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    sharedPreferences.setString(SHARED_PREFERENCES_KEY, json.encode(triviaToCache.toJson()));
    return Future.value();
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(SHARED_PREFERENCES_KEY);
    if(jsonString != null){
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }else{
      throw CacheException();
    }
    
  }
}