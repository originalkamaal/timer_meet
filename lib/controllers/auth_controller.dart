import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  bool result = false;
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();
  Future<bool> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          await _firebaseDatabase
              .ref("users/${userCredential.user!.uid}")
              .once()
              .then((event) async {
            if (event.snapshot.value == null) {
              await _firebaseDatabase
                  .ref("users/${userCredential.user!.uid}")
                  .set({
                "username": userCredential.user!.displayName,
                "uid": userCredential.user!.uid,
                "phoneNumber": userCredential.user!.phoneNumber,
                "email": userCredential.user!.email,
                "photoUrl": userCredential.user!.photoURL
              }).then((v) {
                result = true;
              });
            }
          });

          // if (_firebaseDatabase.("users/${userCredential.user!.email}") ==
          //     null) {
          //   await _firebaseDatabase.ref("users").set({
          //     "username": userCredential.user!.displayName,
          //     "uid": userCredential.user!.uid,
          //     "phoneNumber": userCredential.user!.phoneNumber,
          //     "email": userCredential.user!.email,
          //     "photoUrl": userCredential.user!.photoURL
          //   }).then((v) {
          //     result = true;
          //   });
          // } else {
          //   result = true;
          // }
        }
      } on FirebaseAuthException catch (e) {
        print(e);
        result = false;
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        print(e);
        result = false;
        // handle the error here
      }
    }
    print(result);
    return result;
  }

  static Future<void> logOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await _auth.signOut();
    await googleSignIn.signOut();
  }
}
