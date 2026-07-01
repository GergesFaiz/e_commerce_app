
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/model/user.dart';

class FirebaseUtils {

  static CollectionReference<User> getUserCollection(){
    return   FirebaseFirestore.instance.collection(User.collectionName).
    withConverter<User>(
      fromFirestore:  (snapshot, _) => User.fromFirestore(snapshot.data()!),
       toFirestore:(model, _) => model.toFirestore());

  }
  static Future<void> addUser(User user){
    var collectionReference =getUserCollection();
   var docRef= collectionReference.doc(user.id);
    user.id=docRef.id;
    return docRef.set (user);
   
  }


}