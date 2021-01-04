import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Api {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Future<QuerySnapshot> getDocumentByfields(String field, dynamic value) {
    return _db.collection(path).where(field, isEqualTo: value).get();
  }

  Future<QuerySnapshot> getDocumentByfieldsOrderby(
      String field, String value, String orderbyvalue) {
    return _db
        .collection(path)
        .where(field, isEqualTo: value)
        .orderBy(orderbyvalue, descending: false)
        .get();
  }

  Future<QuerySnapshot> getDocumentStartWith(dynamic fields, dynamic value) {
    return _db
        .collection(path)
        .where(fields, isGreaterThanOrEqualTo: value)
        .where(fields, isLessThan: value + 'z')
        .get();
  }

  Future<QuerySnapshot> getDocumentByisEqualTo(dynamic fields, dynamic value) {
    return _db.collection(path).where(fields, isEqualTo: value).get();
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.doc(id).update(data);
  }
}
