import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource{
    /// Calls the numbers api http://numbersapi.com/{number}
    /// throws a [ServerException] for all error codes
    Future <NumberTriviaModel> getConcreteNumberTrivia(int number);
    /// Calls the numbers api http://numbersapi.com/random
    /// throws a [ServerException] for all error codes
    Future <NumberTriviaModel> getRandomNumberTrivia();
}