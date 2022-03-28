import 'dart:convert';

class DriverModel {
  final String? id;
  final String userName;
  final String profilePictureUrl;
  final double credit;
  final String carModel;
  final String plateNumber;
  
  DriverModel({
    this.id,
    required this.userName,
    required this.profilePictureUrl,
    required this.credit,
    required this.carModel,
    required this.plateNumber,
  });

  DriverModel copyWith({
    String? id,
    String? userName,
    String? profilePictureUrl,
    double? credit,
    String? carModel,
    String? plateNumber,
  }) {
    return DriverModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      credit: credit ?? this.credit,
      carModel: carModel ?? this.carModel,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'profilePictureUrl': profilePictureUrl,
      'credit': credit,
      'carModel': carModel,
      'plateNumber': plateNumber,
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'],
      userName: map['userName'] ?? '',
      profilePictureUrl: map['profilePictureUrl'] ?? '',
      credit: map['credit']?.toDouble() ?? 0.0,
      carModel: map['carModel'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverModel.fromJson(String source) => DriverModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DriverModel(id: $id, userName: $userName, profilePictureUrl: $profilePictureUrl, credit: $credit, carModel: $carModel, plateNumber: $plateNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DriverModel &&
      other.id == id &&
      other.userName == userName &&
      other.profilePictureUrl == profilePictureUrl &&
      other.credit == credit &&
      other.carModel == carModel &&
      other.plateNumber == plateNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userName.hashCode ^
      profilePictureUrl.hashCode ^
      credit.hashCode ^
      carModel.hashCode ^
      plateNumber.hashCode;
  }
}
