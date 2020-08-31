class FormofBirthControl {
  final int id;
  final String title;
  bool checked = false;

  FormofBirthControl({this.id, this.title});

  factory FormofBirthControl.fromJson(Map<String, dynamic> json) {
    return FormofBirthControl(
      id: json['id'],
      title: json['name'],
    );
  }
}