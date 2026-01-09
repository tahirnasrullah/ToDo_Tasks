class ToDoDailyTasks_history {
  final String to;
  final String from;
  final String title;
  final String desc;

  ToDoDailyTasks_history({
    required this.to,
    required this.from,
    required this.title,
    required this.desc,
  });

  Map<String, dynamic> toMap() {
    return {'to': to, 'from': from,'title': title, 'desc': desc};
  }

  factory ToDoDailyTasks_history.fromMap(Map<String, dynamic> map) {
    return ToDoDailyTasks_history(
      to: map['to'] ?? '',
      from: map['from'] ?? '',
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
    );
  }
}

