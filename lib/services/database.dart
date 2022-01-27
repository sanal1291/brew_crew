import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });
  // collection reference

  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');
  
  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars' : sugars,
      'name'   : name,
      'strength': strength,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return Brew(
        name: e.data.call()['name'] ?? '', 
        strength: e.data.call()['strength'] ?? 0,
        sugars: e.data.call()['sugars'] ?? '0',
        );
    }).toList();
  }

  // get brew stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data.call()['name'],
      sugars: snapshot.data.call()['sugars'],
      strength:  snapshot.data.call()['strength'],
    );
  }

  //get user doc stream
  Stream<UserData> get  userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}