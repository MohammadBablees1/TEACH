class Folder {
  final int id;
  final String name;
  final int? parentId;

  Folder({required this.id, required this.name, this.parentId});
  
  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      parentId: map['parent_id'],
    );
  }
  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
    );
  }
}