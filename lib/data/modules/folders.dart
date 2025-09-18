class Folder {
  final int id;
  final String name;
  final int? parentId;
  final String childCount;
  final String imageUrl;
  final bool isTeacher;
  final bool locked;
  final String price;

  Folder(
      {required this.id,
      required this.name,
      this.parentId,
      required this.childCount,
      required this.imageUrl,
      required this.isTeacher,
      required this.locked,
      required this.price});

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      parentId: map['parent_id'],
      childCount: map['child_count'],
      imageUrl: map["image_url"],
      isTeacher: map["is_teacher"],
      locked: map["locked"],
      price: map["price"],
    );
  }
  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      childCount: json['child_count'],
      imageUrl: json["image_url"] ?? "",
      isTeacher: json["is_teacher"],
      locked: json["locked"],
      price: json["price"] ?? "",
    );
  }
  toJson() {
    return {
      "id": id,
      "name": name,
      "parent_id": parentId,
      "child_count": childCount,
      "image_url": imageUrl,
      "is_teacher": isTeacher,
      "locked": locked,
      "price": price,
    };
  }
}
