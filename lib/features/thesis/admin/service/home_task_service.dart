import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workspace/features/thesis/dashboard/model/task_model.dart';

class HomeTaskService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TaskModel>> getTasks() async {
    try {
      final querySnapshot = await _firestore.collection('tasks').get();

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
}
