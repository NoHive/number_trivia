import 'package:equatable/equatable.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}


class GetTriviaForConcreteNumber extends NumberTriviaEvent{
  final String numberString;
  
  GetTriviaForConcreteNumber(this.numberString);

  @override
  List<Object> get props => [numberString];
}
class GetTriviaForRandomNumber extends NumberTriviaEvent{
  @override
  List<Object> get props => [];

}