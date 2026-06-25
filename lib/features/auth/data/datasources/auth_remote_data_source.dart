import 'dart:convert';

import 'package:fit_check/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> signOut();
  Future<UserModel> changePassword(UserModel user, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> signIn(String email, String password) =>
      throw UnimplementedError();

  @override
  Future<UserModel> signUp(String email, String password) =>
      throw UnimplementedError();

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<UserModel> changePassword(UserModel user, String password) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }
}
