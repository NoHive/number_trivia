import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia{}
class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia{}
class MockInputConverter extends Mock implements InputConverter{}

void main(){
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp((){
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(concrete: mockGetConcreteNumberTrivia, 
                            random: mockGetRandomNumberTrivia, 
                            converter: mockInputConverter);

  });

  test(
    'initial state should be empty',
      () async {
      // arrange
  
      // act
  
      //assert
      expect(bloc.initialState, Empty());
      }
  );

  group('GetTriviaForConcreteNumber', (){
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'Test');
    test(
      'should call the InputConverter to validate an convert to an int',
        () async {
        // arrange
        when(mockInputConverter.stringTOUnsignedInteger(any)).thenReturn(Right(tNumberParsed));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringTOUnsignedInteger(any));
        //assert
        verify(mockInputConverter.stringTOUnsignedInteger(tNumberString));
    
        }
    );
     test(
      'should emit an error if the input is invalid',
        () async {
        // arrange
        when(mockInputConverter.stringTOUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));
        //assert later
        final expectedMessageList = [
          Empty(),
          Error(message: INVALID_INPUT_MESSAGE)
          ];

        expectLater(bloc.state, emitsInOrder(expectedMessageList));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    
        }
    );
  });
}

