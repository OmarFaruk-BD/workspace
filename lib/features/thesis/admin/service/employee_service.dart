import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workspace/core/components/app_image_helper.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';

class EmployeeService {
  final Logger _logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AppImageHelper _compressor = AppImageHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<String, String>> createEmployee({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String position,
    required String department,
    required String role,
    File? imageFile,
  }) async {
    try {
      // Step 1: Create user in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      String? imageBase64;
      if (imageFile != null) {
        final compressedBytes = await _compressor.compressImageToBase64(
          imageFile,
        );
        imageBase64 = compressedBytes;
      }

      // Step 3: Save user data in Firestore
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'position': position,
        'department': department,
        'role': role.toLowerCase(),
        'imageUrl': imageBase64 ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return const Right('Employee created successfully.');
    } on FirebaseAuthException catch (e) {
      _logger.e("FirebaseAuthException: ${e.message}");
      if (e.code == 'email-already-in-use') {
        return Left("This email is already registered.");
      } else if (e.code == 'weak-password') {
        return Left("Password is too weak. Please use a stronger one.");
      } else {
        return Left("Authentication error: ${e.message}");
      }
    } catch (e) {
      _logger.e("createEmployee Error: $e");
      return Left("Failed to create employee: $e");
    }
  }

  Future<Either<String, String>> editEmployee({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String password,
    required String position,
    required String department,
    required String role,
    File? imageFile,
  }) async {
    try {
      // 🔹 Step 1: Check if user exists
      final docRef = _firestore.collection('users').doc(uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        return const Left("Employee not found.");
      }

      // 🔹 Step 2: Prepare update data
      Map<String, dynamic> updateData = {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'position': position,
        'department': department,
        'role': role.toLowerCase(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (imageFile != null) {
        final compressedBytes = await _compressor.compressImageToBase64(
          imageFile,
        );
        updateData['imageUrl'] = compressedBytes;
      }

      // 🔹 Step 4: Update Firestore document
      await docRef.update(updateData);

      _logger.i('✅ Employee $uid updated successfully.');
      return const Right("Employee updated successfully.");
    } on FirebaseAuthException catch (e) {
      _logger.e("FirebaseAuthException: ${e.message}");
      return Left("Firebase Auth error: ${e.message}");
    } on FirebaseException catch (e) {
      _logger.e("FirebaseException: ${e.message}");
      return Left("Database error: ${e.message}");
    } catch (e) {
      _logger.e("editEmployee Error: $e");
      return Left("Failed to update employee: $e");
    }
  }

  Future<Either<String, String>> deleteEmployee(UserModel? user) async {
    try {
      // ✅ Step 2: Temporarily sign in as the employee using email & password
      final employeeCredential = await _auth.signInWithEmailAndPassword(
        email: user?.email ?? '',
        password: user?.password ?? '',
      );

      final employee = employeeCredential.user;
      if (employee == null) {
        return const Left('Employee not found.');
      }

      // ✅ Step 3: Delete employee document from Firestore using UID
      await _firestore.collection('users').doc(user?.id).delete();

      // ✅ Step 4: Delete employee authentication record
      await employee.delete();

      _logger.i('Employee deleted successfully: ${user?.email}');

      return const Right('Employee deleted successfully.');
    } on FirebaseAuthException catch (e) {
      _logger.e('Firebase Auth Error: ${e.message}');
      return Left('Auth error: ${e.message}');
    } catch (e) {
      _logger.e('Delete employee failed: $e');
      return Left('Failed to delete employee: $e');
    }
  }

  Future<List<UserModel>> getAllEmployees([String role = 'employee']) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: role.toLowerCase())
          .orderBy('createdAt', descending: true)
          .get();

      final employees = querySnapshot.docs.map((doc) {
        return UserModel(
          id: doc['uid'],
          name: doc['name'],
          email: doc['email'],
          phone: doc['phone'],
          role: doc['role'],
          password: doc['password'],
          position: doc['position'],
          department: doc['department'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
        );
      }).toList();

      return employees;
    } catch (e) {
      _logger.e("Error fetching employees: $e");
      return [];
    }
  }

  Future<UserModel?> getEmployeeDetail(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (!docSnapshot.exists) {
        _logger.w("No employee found with UID: $uid");
        return null;
      }

      final data = docSnapshot.data()!;
      return UserModel(
        id: data['uid'],
        name: data['name'],
        role: data['role'],
        email: data['email'],
        phone: data['phone'],
        password: data['password'],
        position: data['position'],
        department: data['department'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      _logger.e("Error fetching employee detail: $e");
      return null;
    }
  }

  Future<UserModel?> getEmployeeWithImage(String? uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (!docSnapshot.exists) {
        _logger.w("No employee found with UID: $uid");
        return null;
      }

      final data = docSnapshot.data()!;
      return UserModel(
        id: data['uid'],
        name: data['name'],
        role: data['role'],
        email: data['email'],
        phone: data['phone'],
        imageUrl: data['imageUrl'],
        password: data['password'],
        position: data['position'],
        department: data['department'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      _logger.e("Error fetching employee detail: $e");
      return null;
    }
  }
}
