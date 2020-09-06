class Symptom {
  final int id;
  final String title;
  bool checked = false;

  Symptom({this.id, this.title});

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      id: json['id'],
      title: json['name'],
    );
  }
}