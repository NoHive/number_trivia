import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{}
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{}
class MockNetworkInfo extends Mock implements NetworkInfo{}




void main(){
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource:mockRemoteDataSource,
      localDataSource:mockLocalDataSource,
      networkInfo:mockNetworkInfo,
      );
  });
  void runTestsOnline(Function body){
   group("if device is online", (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
   });
  }
   void runTestsOffline(Function body){
   group("if device is offline", (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
   });
  }
  group('getConcreteNumberTrivia', (){

    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'Test');
    final tNumberTrivia =  tNumberTriviaModel;
    test(
      'should check if the device is connected to the network',
        () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockNetworkInfo.isConnected);
    
        }
    );



    runTestsOnline((){
     
      test(
        'should  return remote data when the call to remote datasource is successfull',
          () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer(
            (_) async => tNumberTriviaModel
          );
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
      
          }
      );
       test(
        'should cache the data locally',
          () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer(
            (_) async => tNumberTriviaModel
          );
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrvia(tNumberTriviaModel));
      
          }
      );
       test(
        'should return ServerFailure if call is not successful',
          () async {
          // arrange
            when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(
              ServerException()
            );
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            //assert
            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
      
          }
      );
    });
    runTestsOffline((){
      test(
        'should return last cached data when cached data is present',
          () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer(
            (_) async => tNumberTriviaModel
          );
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
      
          }
      );
       test(
        'should return CacheFailure when no data was previously cached',
          () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(
            CacheException()
          );
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
      
          }
      );
    });
  });
  group('getRandomNumberTrivia', (){

    
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'Test Trivia');
    final tNumberTrivia =  tNumberTriviaModel;
    test(
      'should check if the device is connected to the network',
        () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getRandomNumberTrivia();
        //assert
        verify(mockNetworkInfo.isConnected);
    
        }
    );



    runTestsOnline((){
     
      test(
        'should  return remote data when the call to remote datasource is successfull',
          () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer(
            (_) async => tNumberTriviaModel
          );
          // act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
      
          }
      );
       test(
        'should cache the data locally',
          () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer(
            (_) async => tNumberTriviaModel
          );
          // act
          await repository.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrvia(tNumberTriviaModel));
      
          }
      );
       test(
        'should return ServerFailure if call is not successful',
          () async {
          // arrange
            when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(
              ServerException()
            );
            // act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
      
          }
      );
    });
    runTestsOffline((){
      test(
        'should return last cached data when cached data is present',
          () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer(
            (_) async => tNumberTriviaModel
          );
          // act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
      
          }
      );
       test(
        'should return CacheFailure when no data was previously cached',
          () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(
            CacheException()
          );
          // act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
      
          }
      );
    });
  });
}