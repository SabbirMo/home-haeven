import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  bool hidenPassword = true;
  void showPassword() {
    hidenPassword = !hidenPassword;
    update();
  }

  bool hidenConfirmPassword = true;
  void showConfirmPassword() {
    hidenConfirmPassword = !hidenConfirmPassword;
    update();
  }

  String adminEmail = "sabbirsamolla51@gmail.com";

  String selectedRole = "customer";

  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  Future<void> registorUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      if (role == "admin" && email.trim().toLowerCase() != adminEmail) {
        Get.snackbar("Error", "Only $adminEmail can be registered as admin!");
        return;
      }

      isLoading = true;
      update();

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = credential.user;

      if (user != null && !credential.user!.emailVerified) {
        await credential.user!.sendEmailVerification();
        Get.snackbar('Success', 'Verification Email sent to $email');
      }

      await _firestore.collection('auth').doc(user!.uid).set({
        'uid': user!.uid,
        'name': name,
        'email': email,
        'role': role,
        'createAt': DateTime.now(),
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Something went wrong');
    } finally {
      isLoading = false;
      update();
    }
  }
}
