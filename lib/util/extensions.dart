import 'package:fpdart/fpdart.dart';

extension MyEitherOps<L, R> on Either<L, R> {
  TaskEither<L, R2> flatMapFuture<R2>(Future<Either<L, R2>> Function(R r) f) =>
      bindFuture(f);

  Either<LL, RR> bimap<LL, RR>(
          LL Function(L l) ifLeft, RR Function(R r) ifRight) =>
      fold((l) => left(ifLeft(l)), (r) => right(ifRight(r)));
}

extension MyFutureEitherOps<L, R> on Future<Either<L, R>> {
  Future<Either<L, R2>> map<R2>(R2 Function(R r) f) async =>
      (await this).map(f);

  Future<Either<LL, RR>> bimap<LL, RR>(
          LL Function(L l) ifLeft, RR Function(R r) ifRight) async =>
      (await this).fold((l) => left(ifLeft(l)), (r) => right(ifRight(r)));

  Future<Either<L, R2>> flatMap<R2>(Either<L, R2> Function(R r) f) async =>
      (await this).flatMap(f);

  Future<Either<L2, R>> mapLeft<L2>(L2 Function(L l) f) async =>
      (await this).fold((L l) => left(f(l)), right);
}

extension MyFutureOps<T> on Future<T> {
  Future<R> flatMap<R>(Future<R> Function(T t) f) async => f(await this);
}
