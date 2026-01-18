import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workspace/features/thesis/dashboard/model/leave_model_v2.dart';

class LeaveRequestService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Create a new request document
  Future<Either<String, String>> createLeaveRequest({
    required String userName,
    required String userId,
    required String title,
    required String description,
    required String type,
    required String fromDate,
    required String toDate,
    required String note,
    required String status,
    required String comment,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'userName': userName,
        'userId': userId,
        'title': title,
        'description': description,
        'type': type,
        'fromDate': fromDate,
        'toDate': toDate,
        'note': note,
        'status': status,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      _logger.e(requestData);

      await _firestore.collection('leave').add(requestData);

      return const Right('Leave created successfully.');
    } catch (e) {
      _logger.e('Error creating leave: $e');
      return Left('Failed to create leave: $e');
    }
  }

  /// ✏️ Edit (update) an existing request by its document ID
  Future<Either<String, String>> editLeaveRequest({
    required String leaveId,
    required Map<String, dynamic> updatedFields,
  }) async {
    try {
      updatedFields['updatedAt'] = FieldValue.serverTimestamp();
      _logger.e(updatedFields);

      await _firestore.collection('leave').doc(leaveId).update(updatedFields);

      return const Right('Leave updated successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error editing leave: ${e.message}');
      return Left('Failed to update leave: ${e.message}');
    } catch (e) {
      _logger.e('Error editing leave: $e');
      return Left('Failed to edit leave: $e');
    }
  }

  /// 🗑️ Delete a request by its document ID
  Future<Either<String, String>> deleteLeaveRequest(String id) async {
    try {
      await _firestore.collection('leave').doc(id).delete();
      return const Right('Leave request deleted successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error deleting leave: ${e.message}');
      return Left('Failed to delete leave: ${e.message}');
    } catch (e) {
      _logger.e('Error deleting leave: $e');
      return Left('Failed to delete leave: $e');
    }
  }

  /// 📋 Get all request assigned to a specific employee
  Future<List<LeaveModelV2>> getLeaveRequestByEmployee(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('leave')
          .where('userId', isEqualTo: userId)
          .get();

      final request = querySnapshot.docs.map((doc) {
        final data = doc.data();
        _logger.e(data);
        return LeaveModelV2(
          id: doc.id,
          userName: data['userName'],
          userId: data['userId'],
          title: data['title'],
          description: data['description'],
          type: data['type'],
          fromDate: data['fromDate'],
          toDate: data['toDate'],
          note: data['note'],
          status: data['status'],
          comment: data['comment'],
        );
      }).toList();

      return request;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching leave: ${e.message}');
      return [];
    } catch (e) {
      _logger.e('Error fetching leave: $e');
      return [];
    }
  }

  Future<List<LeaveModelV2>> getAllRequest() async {
    try {
      final querySnapshot = await _firestore.collection('leave').get();

      final request = querySnapshot.docs.map((doc) {
        final data = doc.data();
        _logger.e(data);
        return LeaveModelV2(
          id: doc.id,
          userName: data['userName'],
          userId: data['userId'],
          title: data['title'],
          description: data['description'],
          type: data['type'],
          fromDate: data['fromDate'],
          toDate: data['toDate'],
          note: data['note'],
          status: data['status'],
          comment: data['comment'],
        );
      }).toList();

      return request;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching request: ${e.message}');
      return [];
    } catch (e) {
      _logger.e('Error fetching request: $e');
      return [];
    }
  }

  Future<LeaveModelV2?> getLeaveRequestDetails({
    required String userId,
    required String requestId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('leave')
          .where('userId', isEqualTo: userId)
          .get();

      final requests = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data};
      }).toList();

      final data = requests.firstWhere((element) {
        return element['id'] == requestId;
      });

      final getData = LeaveModelV2(
        id: requestId,
        userName: data['userName'],
        userId: data['userId'],
        title: data['title'],
        description: data['description'],
        type: data['type'],
        fromDate: data['fromDate'],
        toDate: data['toDate'],
        note: data['note'],
        status: data['status'],
        comment: data['comment'],
      );

      return getData;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching leave request: ${e.message}');
      return null;
    } catch (e) {
      _logger.e('Error fetching leave request: $e');
      return null;
    }
  }
}
