import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  // Forgot Password method
  Future<void> resetPassword({required String email}) async {
    try {
      if (email.isEmpty) {
        Get.snackbar('Error', 'Please enter your email');
        return;
      }

      isLoading = true;
      update();

      await _auth.sendPasswordResetEmail(email: email);

      Get.snackbar('Success', 'Password reset email sent. Check your inbox.');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Something went wrong');
    } finally {
      isLoading = false;
      update();
    }
  }
}
