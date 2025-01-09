import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  late final Stream<User?> _authStateChangesSubscription;

  AuthCubit(this._firebaseAuth) : super(AuthInitial()) {
    // Listen to authentication state changes
    _authStateChangesSubscription = _firebaseAuth.authStateChanges();
    _authStateChangesSubscription.listen((user) {
      if (!isClosed) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      }
    });
  }
  Future<void> signIn(String email, String password) async {
    try {
      emit(AuthLoading());
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (!isClosed) emit(AuthError(e.message ?? 'An error occurred during sign in'));
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      emit(AuthLoading());
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (!isClosed) emit(AuthError(e.message ?? 'An error occurred during sign up'));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await _firebaseAuth.signOut();
      if (!isClosed) emit(Unauthenticated());
    } catch (e) {
      if (!isClosed) emit(AuthError('An error occurred during sign out'));
    }
  }

  @override
  Future<void> close() {
    // Cancel the subscription to auth state changes
    _authStateChangesSubscription.drain();
    return super.close();
  }
}
