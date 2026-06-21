import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/helpers/storage_helper.dart';

class AuthSessionState {
  const AuthSessionState({
    this.isAuthenticated = false,
    this.role,
    this.profileCompleted = false,
    this.requiresVerification = false,
  });

  final bool isAuthenticated;
  final String? role;
  final bool profileCompleted;
  final bool requiresVerification;

  AuthSessionState copyWith({
    bool? isAuthenticated,
    String? role,
    bool? profileCompleted,
    bool? requiresVerification,
  }) {
    return AuthSessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: role ?? this.role,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      requiresVerification: requiresVerification ?? this.requiresVerification,
    );
  }
}

class AuthSessionController extends Notifier<AuthSessionState> {
  @override
  AuthSessionState build() => const AuthSessionState();

  void login({
    required String role,
    bool profileCompleted = true,
    bool requiresVerification = false,
  }) {
    state = AuthSessionState(
      isAuthenticated: true,
      role: role,
      profileCompleted: profileCompleted,
      requiresVerification: requiresVerification,
    );
  }

  void registerStudent() {
    state = const AuthSessionState(
      isAuthenticated: true,
      role: 'mahasiswa',
      profileCompleted: false,
      requiresVerification: true,
    );
  }

  void requestLecturerAccount() {
    state = const AuthSessionState(
      isAuthenticated: true,
      role: 'dosen',
      profileCompleted: false,
      requiresVerification: true,
    );
  }

  void completeProfile() {
    state = state.copyWith(profileCompleted: true);
  }

  void approveVerification() {
    state = state.copyWith(requiresVerification: false);
  }

  Future<void> logout() async {
    await StorageHelper.clearAll();
    state = const AuthSessionState();
  }
}

final authSessionControllerProvider =
    NotifierProvider<AuthSessionController, AuthSessionState>(AuthSessionController.new);

