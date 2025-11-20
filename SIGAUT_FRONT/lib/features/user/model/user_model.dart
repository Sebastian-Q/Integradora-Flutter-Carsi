class UserModel {
  int id = 0;
  String name = "";
  String paternalName = "";
  String maternalName = "";
  String email = "";
  String username = "";
  String password = "";
  String direction = "";
  String? image_url;

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        paternalName = json["paternalName"],
        maternalName = json["maternalName"],
        email = json["email"],
        username = json["username"],
        password = json["password"],
        direction = json["direction"] ?? "Sin definir",
        image_url = json["image_url"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "paternalName": paternalName,
      "maternalName": maternalName,
      "email": email,
      "username": username,
      "password": password,
      "direction": direction,
      "image_url": image_url,
    };
  }

  Map<String, dynamic> toSave() {
    return {
      "name": name,
      "paternalName": paternalName,
      "maternalName": maternalName,
      "email": email,
      "username": username,
      "password": password,
      "direction": direction,
    };
  }

  String toFullName() {
    return '$name $paternalName $maternalName';
  }
}