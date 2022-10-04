// ignore_for_file: public_member_api_docs, sort_constructors_first

class ContactModel {
  String name;
  String address;
  String imagePath;
  ContactModel({
    required this.name,
    required this.address,
    required this.imagePath,
  });

  ContactModel copyWith({
    String? name,
    String? address,
    String? imagePath,
  }) {
    return ContactModel(
      name: name ?? this.name,
      address: address ?? this.address,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'imagePath': imagePath,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      name: map['name'] as String,
      address: map['address'] as String,
      imagePath: map['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory ContactModel.fromJson(Map<String, dynamic> source) =>
      ContactModel.fromMap(source);

  @override
  String toString() =>
      'ContactModel(name: $name, address: $address, imagePath: $imagePath)';

  @override
  bool operator ==(covariant ContactModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.address == address;
  }

  @override
  int get hashCode => name.hashCode ^ address.hashCode ^ imagePath.hashCode;
}
