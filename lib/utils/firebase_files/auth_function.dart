import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies/model/user.dart';

class FirebaseFunctions {
  static Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    try {
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // password بيتبعت لـ Firebase Auth بس — مش بيتحفظ في Firestore
      User newUser = User(
        id: userCredential.user!.uid,
        avatar: avatar,
        name: name,
        email: email,
        phoneNum: phone,
      );

      await FirebaseFirestore.instance
          .collection(User.collectionName)
          .doc(newUser.id)
          .set(newUser.toFirestore());

      return null;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') return 'The password is too weak.';
      if (e.code == 'email-already-in-use')
        return 'The email is already in use.';
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return null;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return 'No user found for that email.';
      if (e.code == 'wrong-password') return 'Wrong password provided.';
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return 'cancelled';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.FirebaseAuth.instance
          .signInWithCredential(credential);
      final user = userCredential.user!;

      // لو مسجل لأول مرة، نحفظ بياناته في Firestore بدون password
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'id': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'avatar': user.photoURL ?? '',
          'phoneNum': '',
          'watchlist': [],
          'history': [],
        });
      }

      return null;
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> resetPassword(String email) async {
    try {
      await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();
    return doc.exists ? doc.data() : null;
  }
}
