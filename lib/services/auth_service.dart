import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static String _verifyOTP = "";

  // send the otp
  static Future sendOTP({
    required String phoneNo,
    required Function errorHandle,
    required Function nextStep,
  }) async {
    await _firebaseAuth
        .verifyPhoneNumber(
            timeout: const Duration(seconds: 30),
            phoneNumber: "+91$phoneNo",
            verificationCompleted: (phoneAuthCredential) async {
              // ignore: avoid_print
              print('verificationCompleted');
              return;
            },
            verificationFailed: (error) async {
              // ignore: avoid_print
              print('verificationFailed, $error');
              return;
            },
            codeSent: (verifyId, forceResendingToken) async {
              // ignore: avoid_print
              print('codeSent');
              _verifyOTP = verifyId;
              nextStep();
            },
            codeAutoRetrievalTimeout: (verificationId) async {
              // ignore: avoid_print
              print('codeAutoRetrievalTimeout');
              return;
            })
        .onError(
      (error, stackTrace) {
        errorHandle();
      },
    );
  }

  // login with otp
  static Future loginWithOtp({required String otp}) async {
    final credential =
        PhoneAuthProvider.credential(verificationId: _verifyOTP, smsCode: otp);
    try {
      final userData = await _firebaseAuth.signInWithCredential(credential);
      if (userData.user != null) {
        return "Success";
      } else {
        return "Error in Otp login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future logout() async {
    await _firebaseAuth.signOut();
  }

  static Future isLoggedIn() async {
    final user = _firebaseAuth.currentUser;
    return (user != null);
  }
}
