import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../core/current_user.dart';

class SchoolScopedRepository {
  final FirebaseFirestore _db;
  final _uuid = const Uuid();

  SchoolScopedRepository({
    FirebaseFirestore? firestore,
  }) : _db = firestore ?? FirebaseFirestore.instance;

  String get schoolId => CurrentUser.require.schoolId;

  CollectionReference<Map<String, dynamic>> _collection(String name) {
    return _db.collection(name);
  }

  Query<Map<String, dynamic>> schoolQuery(String collectionName) {
    return _collection(collectionName)
        .where('schoolId', isEqualTo: schoolId);
  }

  /// UUID controlled create
  Future<String> create(
      String collectionName,
      Map<String, dynamic> data,
      ) async {
    final id = _uuid.v4();

    await _collection(collectionName).doc(id).set({
      ...data,
      'schoolId': schoolId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return id;
  }

  Future<void> update(
      String collectionName,
      String docId,
      Map<String, dynamic> data,
      ) async {
    final ref = _collection(collectionName).doc(docId);
    final snap = await ref.get();

    if (!snap.exists || snap['schoolId'] != schoolId) {
      throw Exception('Cross-school update blocked');
    }

    await ref.update(data);
  }

  Future<void> delete(
      String collectionName,
      String docId,
      ) async {
    final ref = _collection(collectionName).doc(docId);
    final snap = await ref.get();

    if (!snap.exists || snap['schoolId'] != schoolId) {
      throw Exception('Cross-school delete blocked');
    }

    await ref.delete();
  }
}
