// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:library_management/constants/db_constants.dart';
import 'package:library_management/models/custom_error.dart';

class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final fb_auth.FirebaseAuth firebaseAuth;
  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });
  Stream<fb_auth.User?> get user => firebaseAuth.userChanges();

  Future<void> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final fb_auth.UserCredential userCredentials = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final signedInUser = userCredentials.user!;
      usersRef.doc(signedInUser.uid).set({
        'name': name,
        'email': email,
        //'profileImage':
        // 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=1800&t=st=1694866439~exp=1694867039~hmac=dc2806c69fbbdb1729852e113a5110caf22da84f941567977b87fd4ce9e877e3',
      });
    } on fb_auth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw const CustomError(
        code: 'Exception',
        message: 'flutter error/server error',
        plugin: '',
      );
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw const CustomError(
        code: 'Exception',
        message: 'flutter error/server error',
        plugin: '',
      );
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
