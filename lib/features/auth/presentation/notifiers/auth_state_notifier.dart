import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecases/usecase.dart'; // <--- ДОБАВЛЕН ЭТОТ ИМПОРТ
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../providers/auth_providers.dart';
import 'auth_state.dart';

final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(
    ref.watch(loginUseCaseProvider),
    ref.watch(logoutUseCaseProvider),
    ref.watch(getCurrentUserUseCaseProvider),
  );
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthStateNotifier(
    this._loginUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
  ) : super(AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = AuthLoading();
    final result = await _getCurrentUserUseCase(NoParams());
    result.fold(
      (failure) => state = Unauthenticated(),
      (user) => state = Authenticated(user),
    );
  }

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    final result = await _loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => state = AuthError(failure.message ?? "Ошибка входа"),
      (user) => state = Authenticated(user),
    );
  }

  Future<void> logout() async {
    state = AuthLoading();
    await _logoutUseCase(NoParams());
    state = Unauthenticated();
  }
}
