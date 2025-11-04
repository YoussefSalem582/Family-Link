import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService extends GetxController {
  // Firebase initialized flag
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Firebase Instances (lazy getters with error handling)
  FirebaseAuth get auth {
    if (!_isInitialized) throw Exception('Firebase not initialized');
    return FirebaseAuth.instance;
  }

  FirebaseFirestore get firestore {
    if (!_isInitialized) throw Exception('Firebase not initialized');
    return FirebaseFirestore.instance;
  }

  FirebaseStorage get storage {
    if (!_isInitialized) throw Exception('Firebase not initialized');
    return FirebaseStorage.instance;
  }

  // Current User
  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    if (_isInitialized) {
      currentUser.bindStream(auth.authStateChanges());
    }
  }

  // Initialize Firebase
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _isInitialized = true;
      currentUser.bindStream(auth.authStateChanges());
      print('✅ Firebase initialized successfully');
    } catch (e) {
      _isInitialized = false;
      print('❌ Error initializing Firebase: $e');
      rethrow;
    }
  }

  // Auth Methods
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  Future<UserCredential?> registerWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error registering: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Check if user is logged in
  bool get isLoggedIn => currentUser.value != null;
  String? get userId => currentUser.value?.uid;
}
