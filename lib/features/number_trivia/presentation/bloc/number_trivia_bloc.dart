import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/global/no_params..dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import './bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHED_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_MESSAGE = 'The input must be a positive integer number';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete, 
    @required GetRandomNumberTrivia random, 
    @required InputConverter converter}): assert(concrete != null), assert(random != null), assert(converter != null),
      this.getConcreteNumberTrivia = concrete,
      this.getRandomNumberTrivia = random,
      this.inputConverter = converter;
  
  
  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if(event is GetTriviaForConcreteNumber){
      final inputResult = inputConverter.stringTOUnsignedInteger(event.numberString);
      yield* inputResult.fold(
        (failure) async*{
          yield Error(message: INVALID_INPUT_MESSAGE);
        },
        (int_res) async* {
          yield Loading();
          final failureOrTrivia = await getConcreteNumberTrivia(params: Params(number: int_res));
          yield* _eitherErrorOrLoaded(failureOrTrivia);
        },
      );
    }else if(event is GetTriviaForRandomNumber){
          yield Loading();
          final failureOrTrivia = await getRandomNumberTrivia(params: NoParams());
          yield* _eitherErrorOrLoaded(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherErrorOrLoaded(Either<Failure, NumberTrivia> failureOrTrivia) async*{
     yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia)
      );
  }

  String _mapFailureToMessage(Failure failure){
      switch(failure.runtimeType){
        case ServerFailure:
          return SERVER_FAILURE_MESSAGE;
        case CacheFailure:
          return CACHED_FAILURE_MESSAGE;
        default: return 'unexpected error';
      }
  }
}
