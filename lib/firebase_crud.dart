import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCrud {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('od_voting');

  Future<void> create(Map<String, dynamic> data) async {
    await _collection.add(data);
  }

  Future<void> update(String docId, int data) async {
    await _collection.doc(docId).update({'votes': data});
  }

}
