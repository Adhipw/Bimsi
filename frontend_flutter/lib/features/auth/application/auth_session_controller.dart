import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole {
  mahasiswa,
  dosen,
  koordinator,
  admin,
  superAdmin,
}

class AuthSessionState {
  const AuthSessionState({
    this.isAuthenticated = false,
    this.role,
    this.profileCompleted = false,
    this.requiresVerification = false,
  });

  final bool isAuthenticated;
  final UserRole? role;
  final bool profileCompleted;
  final bool requiresVerification;

  AuthSessionState copyWith({
    bool? isAuthenticated,
    UserRole? role,
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
    required UserRole role,
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
      role: UserRole.mahasiswa,
      profileCompleted: false,
      requiresVerification: true,
    );
  }

  void requestLecturerAccount() {
    state = const AuthSessionState(
      isAuthenticated: true,
      role: UserRole.dosen,
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

  void logout() {
    state = const AuthSessionState();
  }
}

final authSessionControllerProvider =
    NotifierProvider<AuthSessionController, AuthSessionState>(AuthSessionController.new);

