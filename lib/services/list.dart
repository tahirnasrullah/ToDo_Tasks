import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoDailyTasksHistory {
  final String docId;
  final String to;
  final String from;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String title;
  final String desc;
  final String uid;

  ToDoDailyTasksHistory({
    this.docId = '',
    required this.to,
    required this.from,
    required this.startDateTime,
    required this.endDateTime,
    required this.title,
    required this.desc,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'to': to,
      'from': from,
      'startDateTime': Timestamp.fromDate(startDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
      'title': title,
      'desc': desc,
      'uid': uid,
    };
  }

  factory ToDoDailyTasksHistory.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ToDoDailyTasksHistory(
      docId: doc.id,
      to: data['to'] ?? '',
      from: data['from'] ?? '',
      title: data['title'] ?? '',
      desc: data['desc'] ?? '',
      uid: data['uid'] ?? '',
      startDateTime:
      (data['startDateTime'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      endDateTime:
      (data['endDateTime'] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  factory ToDoDailyTasksHistory.fromMap(Map<String, dynamic> map) {
    return ToDoDailyTasksHistory(
      to: map['to'],
      from: map['from'],
      title: map['title'],
      desc: map['desc'],
      uid: map['uid'],
      startDateTime:
      (map['startDateTime'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      endDateTime:
      (map['endDateTime'] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }
}
