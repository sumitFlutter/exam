class FBModel{
  String? name,email,mobile;
  int? id;
  FBModel({required this.name, required this.email, required this.mobile,this.id});
  factory FBModel.mapToModel(Map m1)
  {
    return FBModel(name: m1["name"], email: m1["email"], mobile:m1["mobile"],id: m1["id"]);

  }
}