class TestModel {
  String? name;
  int? id;

  TestModel({required this.name, required this.id});

  TestModel.fromJson(Map<String, dynamic> json) {
    name = json['note'];
    id = id;
  }
}
