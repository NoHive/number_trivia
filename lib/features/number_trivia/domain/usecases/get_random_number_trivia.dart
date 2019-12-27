import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/global/no_params..dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams>{
  
  final NumberTriviaReporitory reporitory;

  GetRandomNumberTrivia(this.reporitory);
  
  @override
  Future<Either<Failure, NumberTrivia>> call({NoParams params}) async {
    return await reporitory.getRandomNumberTrivia();
  }

}