import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //giriş yap fonksiyonu
  Future<User?> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  //çıkış yap fonksiyonu
  Future<void> signOut() async {
    try {
      await _auth.signOut();  // Firebase Auth oturumu kapatma
      await _googleSignIn.signOut();  // Google Sign-In oturumu kapatma
      print("Kullanıcı çıkış yaptı.");
    } catch (e) {
      print("Çıkış hatası: $e");
    }
  }

  //kayıt ol fonksiyonu
  Future<User?> createPerson(String name, String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore
        .collection("Person")
        .doc(user.user!.uid)
        .set({'userName': name, 'email': email});

    return user.user;
  }

    Future<User?> signInWithGoogle() async {
    try {
      // Kullanıcının hesap seçmesi için signIn() kullanılıyor
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();  
      if (googleUser == null) {
        return null;  // Kullanıcı giriş yapmadan vazgeçti
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google giriş hatası: $e");
      return null;
    }
  }
}