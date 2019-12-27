import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia  implements UseCase<NumberTrivia, Params>{
  final NumberTriviaReporitory reporitory;
  GetConcreteNumberTrivia(this.reporitory);
  Future<Either<Failure, NumberTrivia>> call({Params params}) async {
      return await reporitory.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable{
  final int number;
  Params({@required this.number});

  @override
  // TODO: implement props
  List<Object> get props => [number];
}