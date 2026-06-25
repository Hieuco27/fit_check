import 'package:fit_check/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fit_check/features/auth/domain/entities/user_entity.dart';
import 'package:fit_check/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<UserEntity> signIn(String email, String password) async {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> signUp(String email, String password) async {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> changePassword(UserEntity user, String password) async {
    // TODO: implement changePassword
    throw UnimplementedError();
  }
}
