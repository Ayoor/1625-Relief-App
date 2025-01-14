import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Authenticate with Firebase
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // save sign in session
await saveSession("googleEmail", "${userCredential.user!.email}");
      return userCredential.user;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error signing in with Google");
      print("$e");
           return null;
    }
  }

  Future<void> saveGoogleUserToDatabase(User user) async {
    String email = user.email!;
    String firstName;
    String lastName;
    // Replace invalid characters in the email for Firebase keys
    final safeKey = email.replaceAll('.', 'dot');


    if (user.displayName != null && user.displayName!.contains(' ')) {
      final nameParts = user.displayName!.split(' ');
      firstName = nameParts.first;
      lastName = nameParts.last;
    } else {
      // Use manual names if provided, otherwise default to placeholders
      firstName = user.displayName ?? "Unknown";
      lastName = "N/A";
    }

    // Handle password: use manualPassword for email sign-up; "N/A" for Google
    final password = "N/A";

    // Reference to the database
    final databaseRef = FirebaseDatabase.instance.ref().child("Users");

    await databaseRef.child(safeKey).set({
      "First Name": firstName,
      "Last Name": lastName,
      "Email": email,
      "Password": password,
      "Account Status": user.emailVerified
          ? "Verified"
          : "Awaiting email verification",
      "Authentication Type" :"Google"
    });
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  final storage = FlutterSecureStorage();

// Save session
  Future<void> saveSession(String key, String value) async {
    await storage.write(key: key, value: value);
  }

// Retrieve session
  Future<String?> getSession(String key) async {
    return await storage.read(key: key);
  }

// Delete session
  Future<void> clearSession() async {
    await storage.deleteAll();
  }
}
