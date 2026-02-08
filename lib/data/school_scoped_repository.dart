import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/current_user.dart';

class SchoolScopedRepository {
  final FirebaseFirestore _db;

  SchoolScopedRepository({
    FirebaseFirestore? firestore,
  }) : _db = firestore ?? FirebaseFirestore.instance;

  String get _schoolId => CurrentUser.require.schoolId;

  /// Базовая коллекция (без фильтра)
  CollectionReference<Map<String, dynamic>> collection(String name) {
    return _db.collection(name);
  }

  /// Коллекция с автоматической привязкой к schoolId
  CollectionReference<Map<String, dynamic>> schoolCollection(String name) {
    return _db.collection(name);
  }

  /// Query по школе
  Query<Map<String, dynamic>> schoolQuery(String collectionName) {
    return schoolCollection(collectionName)
        .where('schoolId', isEqualTo: _schoolId);
  }

  DocumentReference<Map<String, dynamic>> doc(
      String collectionName,
      String docId,
      ) {
    return schoolCollection(collectionName).doc(docId);
  }

  Future<void> create(
      String collectionName,
      String docId,
      Map<String, dynamic> data,
      ) {
    return doc(collectionName, docId).set({
      ...data,
      'schoolId': _schoolId,
    });
  }

  Future<void> update(
      String collectionName,
      String docId,
      Map<String, dynamic> data,
      ) {
    return doc(collectionName, docId).update(data);
  }

  Future<void> delete(
      String collectionName,
      String docId,
      ) {
    return doc(collectionName, docId).delete();
  }
}
