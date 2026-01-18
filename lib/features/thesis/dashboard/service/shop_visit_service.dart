import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workspace/core/components/app_image_helper.dart';
import 'package:workspace/features/thesis/dashboard/model/shop_visit_model.dart';

class ShopVisitService {
  final Logger _logger = Logger();
  final AppImageHelper _compressor = AppImageHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Create a new task document
  Future<Either<String, String>> createShopVisit({
    required String svTitle,
    required String svDescription,
    required String svDate,
    required String svClient,
    required String svAmount,
    required String svType,
    required String svTaskId,
    File? imageFile,

    ///
    required String assignedTo,
    required String title,
    required String status,
    required String description,
    required String priority,
    required String taskType,
    required String client,
    required String amount,
    required String dueDate,
    required String comments,
    required String attachments,
  }) async {
    try {
      final compressedBytes = await _compressor.compressImageToBase64(
        imageFile,
      );

      final Map<String, dynamic> shopVisitData = {
        'svTitle': svTitle,
        'svDescription': svDescription,
        'svDate': svDate,
        'svClient': svClient,
        'svAmount': svAmount,
        'svAttachment': compressedBytes,
        'svType': svType,
        'svTaskId': svTaskId,

        //
        'status': status,
        'dueDate': dueDate,
        'assignedTo': assignedTo,
        'title': title,
        'description': description,
        'priority': priority,
        'taskType': taskType,
        'comments': comments,
        'attachments': attachments,
        'client': client,
        'amount': amount,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      _logger.e(shopVisitData);

      await _firestore.collection('shopVisits').add(shopVisitData);

      return const Right('Shop visit created successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error creating shop visit: ${e.message}');
      return Left('Firebase error creating shop visit: ${e.message}');
    } catch (e) {
      _logger.e('Error creating shop visit: $e');
      return Left('Failed to create shop visit: $e');
    }
  }

  /// ✏️ Edit (update) an existing task by its document ID
  Future<Either<String, String>> editShopVisit({
    required String shopVisitId,
    required String svTitle,
    required String svDescription,
    required String svDate,
    required String svClient,
    required String svAmount,
    required String svType,
    required String svTaskId,
    File? imageFile,

    ///
    required String assignedTo,
    required String title,
    required String status,
    required String description,
    required String priority,
    required String taskType,
    required String client,
    required String amount,
    required String dueDate,
    required String comments,
    required String attachments,
  }) async {
    try {
      final compressedBytes = await _compressor.compressImageToBase64(
        imageFile,
      );

      final Map<String, dynamic> shopVisitData = {
        'svTitle': svTitle,
        'svDescription': svDescription,
        'svDate': svDate,
        'svClient': svClient,
        'svAmount': svAmount,
        'svType': svType,
        'svTaskId': svTaskId,

        //
        'status': status,
        'dueDate': dueDate,
        'assignedTo': assignedTo,
        'title': title,
        'description': description,
        'priority': priority,
        'taskType': taskType,
        'comments': comments,
        'attachments': attachments,
        'client': client,
        'amount': amount,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (compressedBytes != null) {
        shopVisitData['svAttachment'] = compressedBytes;
      }
      _logger.e(shopVisitData);

      await _firestore
          .collection('shopVisits')
          .doc(shopVisitId)
          .update(shopVisitData);

      return const Right('Shop visit updated successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error editing shop visit: ${e.message}');
      return Left('Failed to update shop visit: ${e.message}');
    } catch (e) {
      _logger.e('Error editing shop visit: $e');
      return Left('Failed to edit shop visit: $e');
    }
  }

  /// ✏️ Edit (update) an existing task by its document ID
  Future<Either<String, String>> editShopVisitV2({
    required String shopVisitId,
    required String comments,
  }) async {
    try {
      Map<String, dynamic> shopVisitData = {'comments': comments};

      _logger.e(shopVisitData);
      _logger.e(shopVisitId);

      await _firestore
          .collection('shopVisits')
          .doc(shopVisitId)
          .update(shopVisitData);

      return const Right('Shop visit updated successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error editing shop visit: ${e.message}');
      return Left('Failed to update shop visit: ${e.message}');
    } catch (e) {
      _logger.e('Error editing shop visit: $e');
      return Left('Failed to edit shop visit: $e');
    }
  }

  /// 🗑️ Delete a task by its document ID
  Future<Either<String, String>> deleteShopVisit(String id) async {
    try {
      await _firestore.collection('shopVisits').doc(id).delete();
      return const Right('Shop visit deleted successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error deleting shop visit: ${e.message}');
      return Left('Failed to delete shop visit: ${e.message}');
    } catch (e) {
      _logger.e('Error deleting shop visit: $e');
      return Left('Failed to delete shop visit: $e');
    }
  }

  /// 📋 Get all tasks assigned to a specific employee
  Future<List<ShopVisitModel>> getShopVisitByEmployee(String assignedTo) async {
    try {
      final querySnapshot = await _firestore
          .collection('shopVisits')
          .where('assignedTo', isEqualTo: assignedTo)
          .get();

      final shopVisitList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final mapData = {'id': doc.id, ...data};
        // _logger.w(mapData);
        // _logger.w(mapData);
        return ShopVisitModel.fromMap(mapData);
      }).toList();

      return shopVisitList;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching shop visits: ${e.message}');
      return [];
    } catch (e) {
      _logger.e('Error fetching shop visits: $e');
      return [];
    }
  }

  Future<ShopVisitModel?> getShopVisitDetail(String? id) async {
    try {
      final querySnapshot = await _firestore
          .collection('shopVisits')
          .doc(id)
          .get();

      final getData = querySnapshot.data();
      if (getData != null && getData.isNotEmpty) {
        final mapData = {'id': id, ...getData};
        return ShopVisitModel.fromMap(mapData);
      }

      return null;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching shop visits: ${e.message}');
      return null;
    } catch (e) {
      _logger.e('Error fetching shop visits: $e');
      return null;
    }
  }

  // Future<ShopVisitModel?> getShopVisitByEmployeeAndIdV2({
  //   String? assignedTo,
  //   String? taskId,
  // }) async {
  //   try {
  //     final querySnapshot = await _firestore
  //         .collection('shopVisits')
  //         .where('assignedTo', isEqualTo: assignedTo)
  //         .get();

  //     final tasks = querySnapshot.docs.map((doc) {
  //       final data = doc.data();
  //       return {'taskId': doc.id, ...data};
  //     }).toList();

  //     if (tasks.isEmpty) return null;

  //     Map<String, dynamic>? getTask = tasks.firstWhere(
  //       (element) => element['taskId'] == taskId,
  //     );

  //     final getData = TaskModel.fromMap(getTask);

  //     return getData;
  //   } on FirebaseException catch (e) {
  //     _logger.e('Firebase error fetching tasks: ${e.message}');
  //     return null;
  //   } catch (e) {
  //     _logger.e('Error fetching tasks: $e');
  //     return null;
  //   }
  // }
}
