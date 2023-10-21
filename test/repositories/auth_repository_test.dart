import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_management/repositories/auth_repository.dart';

void main() {
  test('auth repository ...', () async {
    final AuthRepository authRepository = AuthRepository(
        firebaseFirestore: FirebaseFirestore.instance,
        firebaseAuth: FirebaseAuth.instance);
    // expect(
    //     authRepository.signIn(
    //         email: 'admin@jaswant.me', password: ''),
    //     );
  });
}
