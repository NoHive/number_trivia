import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource{
  /// Gets the last cached [NumberTriviaModel] 
  /// throws a [CacheException]
  Future<NumberTriviaModel> getLastNumberTrivia();
  /// Caches the submitted [NumberTriviaModel] to the local cache
  /// throws a [CacheException]
  Future<void> cacheNumberTrvia(NumberTriviaModel triviaToCache);
}