import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailDatabase {
  Future addUser(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .set(userInfoMap);
  }

  Stream<String?> getProfileUser(String userId, String Field) {
    return FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return doc[userId][Field];
    });
  }
}