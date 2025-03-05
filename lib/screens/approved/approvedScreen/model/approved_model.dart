
class SaloonApprovedModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String saloonName;
  final String location;
  final String shopUrl;
  final String profileUrl;
  final String licenseUrl;
  final Map<String, dynamic> coordinates;
  final List<dynamic> holidays;
  final List<dynamic> services;
  final Map<String, dynamic> workingHours;
  final String status;

  SaloonApprovedModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.saloonName,
    required this.location,
    required this.shopUrl,
    required this.profileUrl,
    required this.licenseUrl,
    required this.coordinates,
    required this.holidays,
    required this.services,
    required this.workingHours,
    required this.status,
  });

  factory SaloonApprovedModel.fromMap(Map<String, dynamic> map, Map<String, dynamic> data) {
    return SaloonApprovedModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      saloonName: map['saloonName'] ?? '',
      location: map['location'] ?? '',
      shopUrl: map['shopUrl'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
      licenseUrl: map['licenseUrl'] ?? '',
      coordinates: Map<String, dynamic>.from(map['coordinates'] ?? {}),
      holidays: List<dynamic>.from(map['holidays'] ?? []),
      services: List<dynamic>.from(map['services'] ?? []),
      workingHours: Map<String, dynamic>.from(map['workingHours'] ?? {}),
      status: map['status'] ?? '',
    );
  }
}