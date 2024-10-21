import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final auth = FirebaseAuth.instance;
  Future<bool> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential);
        // Once signed in, return the UserCredential
        return true;
      } else {
        throw Exception('Google sign in canceled');
      }
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.message}");
      return false;
    } on PlatformException catch (e) {
      log("Platform Exception: ${e.message}");
      return false;
    } catch (e) {
      log("Error occurred: $e");
      return false;
    }
  }

  Future<bool> signOutWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signOut();
    if (googleUser == null) {
      return true;
    }
    return false;
  }
}
