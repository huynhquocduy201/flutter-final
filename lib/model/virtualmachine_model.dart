// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VirtualmachineModel {
  String id;
  String name;
  String gpu;
  String cpu;
  String ram;
  double price;
  String description;
  String status;
  VirtualmachineModel({
    required this.id,
    required this.name,
    required this.gpu,
    required this.cpu,
    required this.ram,
    required this.price,
    required this.description,
    required this.status,
  });

  VirtualmachineModel copyWith({
    String? id,
    String? name,
    String? gpu,
    String? cpu,
    String? ram,
    double? price,
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
      id: map['id'] as String,
      name: map['name'] as String,
      gpu: map['gpu'] as String,
      cpu: map['cpu'] as String,
      ram: map['ram'] as String,
      price: map['price'] as double,
      description: map['description'] as String,
      status: map['status'] as String,
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
        other.description == description &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        gpu.hashCode ^
        cpu.hashCode ^
        ram.hashCode ^
        price.hashCode ^
        description.hashCode ^
        status.hashCode;
  }
}
