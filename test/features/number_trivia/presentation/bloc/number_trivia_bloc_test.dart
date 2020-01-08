import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/global/no_params..dart';
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

    void arrangeForAnyConcreteNumberTriviaCallSuccess(){
      when(mockGetConcreteNumberTrivia(params: anyNamed('params'))).thenAnswer((_) async => Right(tNumberTrivia));
    }
    void arrangeForAnyConcreteNumberTriviaCallFailure(){
      when(mockGetConcreteNumberTrivia(params: anyNamed('params'))).thenAnswer((_) async => Left(ServerFailure()));
    } 

    void setUpMockinputConverterSuccess(){
      when(mockInputConverter.stringTOUnsignedInteger(any)).thenReturn(Right(tNumberParsed));
    }
    
    
    test(
      'should call the InputConverter to validate an convert to an int',
        () async {
        // arrange
        setUpMockinputConverterSuccess();
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
     test(
      'should get data from the concrete usecase',
        () async {
        // arrange
        setUpMockinputConverterSuccess();
        arrangeForAnyConcreteNumberTriviaCallSuccess();
        
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(params: anyNamed('params')));

        verify(mockGetConcreteNumberTrivia(params: Params(number: tNumberParsed)));
    
        }
    );

    test(
      'should emit [loading, loaded] when data is gotten successfully',
        () async {
        // arrange
        setUpMockinputConverterSuccess();
        arrangeForAnyConcreteNumberTriviaCallSuccess();
       // when()
        final expectedMessageList = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expectedMessageList));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    
        //assert
    
        }
    );
      test(
      'should emit [loading, Error] when data is gotten unsuccessfully',
        () async {
        // arrange
        setUpMockinputConverterSuccess();
        arrangeForAnyConcreteNumberTriviaCallFailure();
       // when()
        final expectedMessageList = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expectedMessageList));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    
        //assert
    
        }
    );
     test(
      'should emit [loading, Error] with a proper Message when data is gotten unsuccessfully',
        () async {
        // arrange
        setUpMockinputConverterSuccess();
        when(mockGetConcreteNumberTrivia(params: anyNamed('params'))).thenAnswer((_) async => Left(CacheFailure()));
       // when()
        final expectedMessageList = [
          Empty(),
          Loading(),
          Error(message: CACHED_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expectedMessageList));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    
        //assert
    
        }
    );
  });
   group('GetTriviaForRandomNumber', (){
    
    final tNumberTrivia = NumberTrivia(number: 1, text: 'Test');

    void arrangeForRandomNumberTriviaCallSuccess(){
      when(mockGetRandomNumberTrivia(params: anyNamed('params'))).thenAnswer((_) async => Right(tNumberTrivia));
    }
      void arrangeForRandomNumberTriviaCallFail(){
      when(mockGetRandomNumberTrivia(params: anyNamed('params'))).thenAnswer((_) async => Left(ServerFailure()));
    }

   
    
    

     test(
      'should get data from the random usecase',
        () async {
        // arrange
        
        arrangeForRandomNumberTriviaCallSuccess();
        
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(params: anyNamed('params')));

        verify(mockGetRandomNumberTrivia(params: NoParams()));
    
        }
    );

    test(
      'should emit [loading, loaded] when data is gotten successfully',
        () async {
        // arrange
        
        arrangeForRandomNumberTriviaCallSuccess();
       // when()
        final expectedMessageList = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expectedMessageList));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
    
        //assert
    
        }
    );
      test(
      'should emit [loading, Error] when data is gotten unsuccessfully',
        () async {
        // arrange
        arrangeForRandomNumberTriviaCallFail();
       // when()
        final expectedMessageList = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expectedMessageList));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
    
        //assert
    
        }
    );
     test(
      'should emit [loading, Error] with a proper Message when data is gotten unsuccessfully',
        () async {
        // arrange
        
        when(mockGetRandomNumberTrivia(params: anyNamed('params'))).thenAnswer((_) async => Left(CacheFailure()));
       // when()
        final expectedMessageList = [
          Empty(),
          Loading(),
          Error(message: CACHED_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expectedMessageList));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
    
        //assert
    
        }
    );
  });
}

