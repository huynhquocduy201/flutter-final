// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';
class VirtualmachineModel {
  String? id;
  String? name;
  String? gpu;
  String? cpu;
  String? ram;
  Float? price;
  String? description;
  String? status;
  VirtualmachineModel({
    this.id,
    this.name,
    this.gpu,
    this.cpu,
    this.ram,
    this.price,
    this.description,
    this.status,
  });

  VirtualmachineModel copyWith({
    String? id,
    String? name,
    String? gpu,
    String? cpu,
    String? ram,
    Float? price,
    String? description,
    String? status,
  }) {
    return VirtualmachineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gpu: gpu ?? this.gpu,
      cpu: cpu ?? this.cpu,
      ram: ram ?? this.ram,
      price: price ?? this.price,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'gpu': gpu,
      'cpu': cpu,
      'ram': ram,
      'price': price,
      'description': description,
      'status': status,
    };
  }

  factory VirtualmachineModel.fromMap(Map<String, dynamic> map) {
    return VirtualmachineModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      gpu: map['gpu'] != null ? map['gpu'] as String : null,
      cpu: map['cpu'] != null ? map['cpu'] as String : null,
      ram: map['ram'] != null ? map['ram'] as String : null,
      price: map['price'] != null ? map['price'] as Float : null,
      description: map['description'] != null ? map['description'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VirtualmachineModel.fromJson(String source) =>
      VirtualmachineModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant VirtualmachineModel other) {
    if (identical(this, true)) return true;
    return other.id == id &&
        other.name == name &&
        other.gpu == gpu &&
        other.cpu == cpu &&
        other.ram == ram &&
        other.price == price &&
        other.description == description&&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        gpu.hashCode ^
        cpu .hashCode ^
        ram .hashCode ^
        price.hashCode ^
        description.hashCode ^
        status.hashCode ;
  }
}
