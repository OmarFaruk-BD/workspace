import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workspace/features/thesis/home/model/notification_model.dart';

class EmployeeNotificationService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Create a new Notification document
  Future<Either<String, String>> createNotification({
    required String assignedTo,
    required String title,
    required String description,
    required String priority,
    required String date,
    required String comments,
  }) async {
    try {
      final Map<String, dynamic> notificationData = {
        'date': date,
        'title': title,
        'priority': priority,
        'comments': comments,
        'assignedTo': assignedTo,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      _logger.e(notificationData);

      await _firestore.collection('notification').add(notificationData);

      return const Right('Notification created successfully.');
    } catch (e) {
      _logger.e('Error creating notification: $e');
      return Left('Failed to create notification: $e');
    }
  }

  /// ✏️ Edit (update) an existing Notification by its document ID
  Future<Either<String, String>> editNotification({
    required String notificationId,
    required Map<String, dynamic> updatedFields,
  }) async {
    try {
      updatedFields['updatedAt'] = FieldValue.serverTimestamp();
      _logger.e(updatedFields);

      await _firestore
          .collection('notification')
          .doc(notificationId)
          .update(updatedFields);

      return const Right('Notification updated successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error editing Notification: ${e.message}');
      return Left('Failed to update Notification: ${e.message}');
    } catch (e) {
      _logger.e('Error editing Notification: $e');
      return Left('Failed to edit Notification: $e');
    }
  }

  /// 🗑️ Delete a Notification by its document ID
  Future<Either<String, String>> deleteNotification(String id) async {
    try {
      await _firestore.collection('notification').doc(id).delete();
      return const Right('Notification deleted successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error deleting notification: ${e.message}');
      return Left('Failed to delete notification: ${e.message}');
    } catch (e) {
      _logger.e('Error deleting notification: $e');
      return Left('Failed to delete notification: $e');
    }
  }

  /// 📋 Get all notification assigned to a specific employee
  Future<List<NotificationModel>> getNotificationByEmployee(
    String assignedTo,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('notification')
          .where('assignedTo', isEqualTo: assignedTo)
          .get();

      final notification = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return NotificationModel(
          id: doc.id,
          title: data['title'],
          createdAt: data['date'],
          comments: data['comments'],
          priority: data['priority'],
          content: data['description'],
        );
      }).toList();

      return notification;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching notification: ${e.message}');
      return [];
    } catch (e) {
      _logger.e('Error fetching notification: $e');
      return [];
    }
  }

  Future<NotificationModel?> getNotificationDetails({
    required String assignedTo,
    required String notificationId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('notification')
          .where('assignedTo', isEqualTo: assignedTo)
          .get();

      final notifications = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data};
      }).toList();

      final notification = notifications.firstWhere((element) {
        return element['id'] == notificationId;
      });

      final getData = NotificationModel(
        id: notification['id'],
        title: notification['title'],
        createdAt: notification['date'],
        comments: notification['comments'],
        priority: notification['priority'],
        content: notification['description'],
      );

      return getData;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching notification: ${e.message}');
      return null;
    } catch (e) {
      _logger.e('Error fetching notification: $e');
      return null;
    }
  }
}
