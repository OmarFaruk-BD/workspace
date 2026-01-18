import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workspace/features/thesis/home/model/notification_model.dart';

class EmergencyRequestService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Create a new request document
  Future<Either<String, String>> createRequest({
    required String assignedTo,
    required String title,
    required String description,
    required String priority,
    required String date,
    required String userName,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'date': date,
        'title': title,
        'comments': '',
        'priority': priority,
        'userName': userName,
        'assignedTo': assignedTo,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      _logger.e(requestData);

      await _firestore.collection('request').add(requestData);

      return const Right('Request created successfully.');
    } catch (e) {
      _logger.e('Error creating request: $e');
      return Left('Failed to create request: $e');
    }
  }

  /// ✏️ Edit (update) an existing request by its document ID
  Future<Either<String, String>> editrequest({
    required String requestId,
    required Map<String, dynamic> updatedFields,
  }) async {
    try {
      updatedFields['updatedAt'] = FieldValue.serverTimestamp();
      _logger.e(updatedFields);

      await _firestore
          .collection('request')
          .doc(requestId)
          .update(updatedFields);

      return const Right('request updated successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error editing request: ${e.message}');
      return Left('Failed to update request: ${e.message}');
    } catch (e) {
      _logger.e('Error editing request: $e');
      return Left('Failed to edit request: $e');
    }
  }

  /// 🗑️ Delete a request by its document ID
  Future<Either<String, String>> deleteRequest(String id) async {
    try {
      await _firestore.collection('request').doc(id).delete();
      return const Right('request deleted successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error deleting request: ${e.message}');
      return Left('Failed to delete request: ${e.message}');
    } catch (e) {
      _logger.e('Error deleting request: $e');
      return Left('Failed to delete request: $e');
    }
  }

  /// 📋 Get all request assigned to a specific employee
  Future<List<NotificationModelV2>> getRequestByEmployee(
    String assignedTo,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('request')
          .where('assignedTo', isEqualTo: assignedTo)
          .get();

      final request = querySnapshot.docs.map((doc) {
        final data = doc.data();
        _logger.e(data);
        return NotificationModelV2(
          id: doc.id,
          date: data['date'],
          title: data['title'],
          userName: data['userName'],
          comments: data['comments'],
          priority: data['priority'],
          content: data['description'],
          assignedTo: data['assignedTo'],
          createdAt: data['date'],
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

  Future<List<NotificationModelV2>> getAllRequest() async {
    try {
      final querySnapshot = await _firestore.collection('request').get();

      final request = querySnapshot.docs.map((doc) {
        final data = doc.data();
        _logger.e(data);
        return NotificationModelV2(
          id: doc.id,
          date: data['date'],
          title: data['title'],
          userName: data['userName'],
          comments: data['comments'],
          priority: data['priority'],
          content: data['description'],
          assignedTo: data['assignedTo'],
          createdAt: data['date'],
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

  Future<NotificationModelV2?> getrequestDetails({
    required String assignedTo,
    required String requestId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('request')
          .where('assignedTo', isEqualTo: assignedTo)
          .get();

      final requests = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data};
      }).toList();

      final request = requests.firstWhere((element) {
        return element['id'] == requestId;
      });

      final getData = NotificationModelV2(
        id: request['id'],
        date: request['date'],
        title: request['title'],
        userName: request['userName'],
        comments: request['comments'],
        priority: request['priority'],
        content: request['description'],
        assignedTo: request['assignedTo'],
        createdAt: request['date'],
      );

      return getData;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching request: ${e.message}');
      return null;
    } catch (e) {
      _logger.e('Error fetching request: $e');
      return null;
    }
  }
}
