import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workspace/features/thesis/dashboard/model/task_model.dart';

class EmployeeTaskService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Create a new task document
  Future<Either<String, String>> createTask({
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
      final Map<String, dynamic> taskData = {
        'status': status,
        'dueDate': dueDate,
        'assignedTo': assignedTo,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'title': title,
        'description': description,
        'priority': priority,
        'taskType': taskType,
        'comments': comments,
        'attachments': attachments,
        'client': client,
        'amount': amount,
      };
      _logger.e(taskData);

      await _firestore.collection('tasks').add(taskData);

      return const Right('Task created successfully.');
    } catch (e) {
      _logger.e('Error creating task: $e');
      return Left('Failed to create task: $e');
    }
  }

  /// ✏️ Edit (update) an existing task by its document ID
  Future<Either<String, String>> editTask({
    required String taskId,
    required Map<String, dynamic> updatedFields,
  }) async {
    try {
      updatedFields['updatedAt'] = FieldValue.serverTimestamp();
      _logger.e(updatedFields);

      await _firestore.collection('tasks').doc(taskId).update(updatedFields);

      return const Right('Task updated successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error editing task: ${e.message}');
      return Left('Failed to update task: ${e.message}');
    } catch (e) {
      _logger.e('Error editing task: $e');
      return Left('Failed to edit task: $e');
    }
  }

  /// 🗑️ Delete a task by its document ID
  Future<Either<String, String>> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      return const Right('Task deleted successfully.');
    } on FirebaseException catch (e) {
      _logger.e('Firebase error deleting task: ${e.message}');
      return Left('Failed to delete task: ${e.message}');
    } catch (e) {
      _logger.e('Error deleting task: $e');
      return Left('Failed to delete task: $e');
    }
  }

  /// 📋 Get all tasks assigned to a specific employee
  Future<List<Map<String, dynamic>>> getTasksByEmployee(
    String assignedTo,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: assignedTo)
          .get();

      final tasks = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'taskId': doc.id, ...data};
      }).toList();

      return tasks;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching tasks: ${e.message}');
      return [];
    } catch (e) {
      _logger.e('Error fetching tasks: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getTaskByEmployeeAndId({
    String? assignedTo,
    String? taskId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: assignedTo)
          .get();

      final tasks = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'taskId': doc.id, ...data};
      }).toList();

      if (tasks.isEmpty) return null;

      Map<String, dynamic>? getTask = tasks.firstWhere(
        (element) => element['taskId'] == taskId,
      );

      return getTask;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching tasks: ${e.message}');
      return null;
    } catch (e) {
      _logger.e('Error fetching tasks: $e');
      return null;
    }
  }

  Future<List<TaskModel>> getTasksByEmployeeV2(String assignedTo) async {
    try {
      final querySnapshot = await _firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: assignedTo)
          .get();

      final tasks = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final mapData = {'taskId': doc.id, ...data};
        return TaskModel.fromMap(mapData);
      }).toList();

      return tasks;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching tasks: ${e.message}');
      return [];
    } catch (e) {
      _logger.e('Error fetching tasks: $e');
      return [];
    }
  }

  Future<TaskModel?> getTaskByEmployeeAndIdV2({
    String? assignedTo,
    String? taskId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: assignedTo)
          .get();

      final tasks = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'taskId': doc.id, ...data};
      }).toList();

      if (tasks.isEmpty) return null;

      Map<String, dynamic>? getTask = tasks.firstWhere(
        (element) => element['taskId'] == taskId,
      );

      final getData = TaskModel.fromMap(getTask);

      return getData;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching tasks: ${e.message}');
      return null;
    } catch (e) {
      _logger.e('Error fetching tasks: $e');
      return null;
    }
  }
}
