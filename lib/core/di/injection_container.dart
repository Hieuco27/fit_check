import 'package:get_it/get_it.dart';
import 'package:fit_check/features/auth/domain/repositories/auth_repository.dart';
import 'package:fit_check/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:fit_check/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fit_check/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:fit_check/features/auth/data/datasources/auth_remote_data_source.dart';

final sl = GetIt.instance;

void init() {
  // --- Auth Feature ---

  // 1. Blocs
  sl.registerFactory(() => LoginBloc(signInUseCase: sl()));

  // 2. UseCases
  sl.registerLazySingleton(() => SignInUseCase(sl()));

  // 3. Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authDataSource: sl<AuthRemoteDataSource>()),
  );

  // --- Capture Feature ---

  // --- Try_On Feature ---
}
