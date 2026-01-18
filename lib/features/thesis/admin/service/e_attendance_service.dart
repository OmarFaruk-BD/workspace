import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workspace/features/thesis/area/model/my_area_model.dart';

class EAssignLocationService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Create a new task document
  Future<Either<String, String>> assignLocation({
    required String start,
    required String end,
    required String lat,
    required String long,
    required String radius,
    required String userId,
  }) async {
    try {
      final Map<String, dynamic> locationData = {
        'end': end,
        'lat': lat,
        'long': long,
        'start': start,
        'radius': radius,
        'assignedTo': userId,
        'createdAt': FieldValue.serverTimestamp(),
      };
      _logger.e(locationData);

      await _firestore.collection('assignLocation').add(locationData);

      return const Right('Location created successfully.');
    } catch (e) {
      _logger.e('Error creating task: $e');
      return Left('Failed to create location: $e');
    }
  }

  Future<MyAreaModel?> getAssignLocationByEmployee(String assignedTo) async {
    final dataList = await getAllAssignLocationsByEmployee(assignedTo);
    return dataList.isNotEmpty ? dataList.first : null;
  }

  /// ✅ Get all assigned locations (descending by createdAt)
  Future<List<MyAreaModel>> getAllAssignLocationsByEmployee(
    String assignedTo,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('assignLocation')
          .where('assignedTo', isEqualTo: assignedTo)
          .orderBy('createdAt', descending: true)
          .get();

      final List<MyAreaModel> areas = querySnapshot.docs.map((doc) {
        final data = doc.data();

        return MyAreaModel(
          longitude: data['long'],
          radius: data['radius'],
          latitude: data['lat'],
          start: data['start'],
          end: data['end'],
          date: data['createdAt'].toDate(),
        );
      }).toList();

      _logger.i('Fetched ${areas.length} assigned locations for $assignedTo');
      return areas;
    } on FirebaseException catch (e) {
      _logger.e('Firebase error fetching all assignLocations: ${e.message}');
      return [];
    } catch (e) {
      _logger.e('Error fetching all assignLocations: $e');
      return [];
    }
  }
}
