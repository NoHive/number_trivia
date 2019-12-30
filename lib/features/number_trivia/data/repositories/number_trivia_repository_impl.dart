import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_datasource.dart';
import '../datasources/number_trivia_remote_datasource.dart';
import '../models/number_trivia_model.dart';

typedef Future<NumberTrivia> _TriviaChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaReporitory{

  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource, 
    @required this.localDataSource, 
    @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async{
    return await _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async{
     return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

   Future<Either<Failure, NumberTrivia>> _getTrivia(_TriviaChooser getConcreteOrRandom) async{
    if(await networkInfo.isConnected){
      try{
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrvia(remoteTrivia);
        return  Right(remoteTrivia);
      } on ServerException{
        return Left(ServerFailure());
      }
    }else{
      try{
          NumberTriviaModel triviaModel = await localDataSource.getLastNumberTrivia();
          return Right(triviaModel);
      } on CacheException{
          return Left(CacheFailure());
      }
    }
   }


}