class ToDoDailyTasksHistory {
  final String to;
  final String from;
  final String title;
  final String desc;
  final String? uid;


  ToDoDailyTasksHistory({
    required this.to,
    required this.from,
    required this.uid,
    required this.title,
    required this.desc,
  });

  Map<String, dynamic> toMap() {
    return {'to': to, 'from': from,'title': title, 'desc': desc, 'uid': uid};
  }

  factory ToDoDailyTasksHistory.fromMap(Map<String, dynamic> map) {
    return ToDoDailyTasksHistory(
      to: map['to'] ?? '',
      from: map['from'] ?? '',
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}

