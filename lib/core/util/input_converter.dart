import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failure.dart';

class InputConverter{
  Either<Failure, int> stringTOUnsignedInteger(String str){
    try{
      int conversionResult = int.parse(str);
      if(conversionResult >= 0)
        return Right(conversionResult);
      else{
        return Left(InvalidInputFailure());
      }
    } on FormatException{
      return Left(InvalidInputFailure());
    }
  }
}
