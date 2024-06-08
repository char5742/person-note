import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:person_note/models/person/good_point/good_point_model.dart';

abstract interface class GoodPointServiceAbstract {
  GoodPointServiceAbstract();
  Future<List<GoodPoint>> getGoodPointList();
  Stream<List<GoodPoint>> watchGoodPointList();
  Future<void> addGoodPoint(GoodPoint goodPoint);
  Future<void> removeGoodPoint(String id);
  Future<void> editGoodPoint(GoodPoint goodPoint);
}

class GoodPointServiceWithFirebase implements GoodPointServiceAbstract {
  GoodPointServiceWithFirebase({
    required this.userId,
    required this.personId,
  });
  final String userId;
  final String personId;
  @override
  Future<List<GoodPoint>> getGoodPointList() async {
    final collectionRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('persons')
        .doc(personId)
        .collection('good_points')
        .get();
    return collectionRef.docs.map((e) => GoodPoint.fromJson(e.data())).toList();
  }

  @override
  Stream<List<GoodPoint>> watchGoodPointList() async* {
    final collectionStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('persons')
        .doc(personId)
        .collection('good_points')
        .snapshots();
    await for (final snapshot in collectionStream) {
      yield snapshot.docs
          .map((docRef) => GoodPoint.fromJson(docRef.data()))
          .toList();
    }
  }

  @override
  Future<void> addGoodPoint(GoodPoint person) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('persons')
        .doc(personId)
        .collection('good_points');
    final docRef = collectionRef.doc();
    await docRef.set(person.copyWith(id: docRef.id).toJson());
  }

  @override
  Future<void> removeGoodPoint(String id) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('persons')
        .doc(personId)
        .collection('good_points')
        .doc(id);
    await docRef.delete();
  }

  @override
  Future<void> editGoodPoint(GoodPoint goodPoint) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('persons')
        .doc(personId)
        .collection('good_points')
        .doc(goodPoint.id);
    await docRef.update(goodPoint.toJson());
  }
}
