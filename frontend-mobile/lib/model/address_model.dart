class Address {
  final String? id;
  final String userId;
  final String name;
  final String phone;
  final String street;
  final String city;
  final String country;
  final String? postalCode;
  final bool isDefault;

  Address({
    this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.country,
    this.postalCode,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phone': phone,
      'street': street,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id']?.toString(),
      userId: map['userId']?.toString() ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      postalCode: map['postalCode']?.toString(),
      isDefault: map['isDefault'] == true || map['isDefault'] == 1,
    );
  }

  Address copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? street,
    String? city,
    String? country,
    String? postalCode,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get fullAddress => '$street, $city, $country';
}
