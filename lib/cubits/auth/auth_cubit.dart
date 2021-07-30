import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth firebaseAuth;
  final FirebaseCrashlytics firebaseCrashlytics;
  late StreamSubscription<User?> _streamSubscription;

  AuthCubit({
    required this.firebaseAuth,
    required this.firebaseCrashlytics,
  }) : super(LoadingAuthenticationState()) {
    _streamSubscription = firebaseAuth.userChanges().listen(_onStateChanged);
  }

  void _onStateChanged(User? user) {
    if (user == null) {
      emit(NotAuthenticatedState());

      Fimber.d('User not authenticated');
    } else {
      emit(AuthenticatedState(user));

      firebaseCrashlytics.setUserIdentifier(user.uid);

      Fimber.d('User is authenticated: $user');
    }
  }

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();

    return super.close();
  }

  void signOut() => firebaseAuth.signOut();

  Future<void> deleteUser(User user) async => await user.delete();
}
