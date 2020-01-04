import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/util/input_converter.dart';
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
          yield failureOrTrivia.fold((failure) => Error(message: failure is ServerFailure ? SERVER_FAILURE_MESSAGE : CACHED_FAILURE_MESSAGE),
          (trivia) => Loaded(trivia: trivia));
        },
      );
    }
  }
}
