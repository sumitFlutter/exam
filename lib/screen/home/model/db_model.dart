class DBModel{
  String? name,email,mobile;
  int? id;
  DBModel({required this.name, required this.email, required this.mobile,this.id});
  factory DBModel.mapToModel(Map m1)
  {
    return DBModel(name: m1["name"], email: m1["email"], mobile:m1["mobile"],id: m1["id"]);

  }
}