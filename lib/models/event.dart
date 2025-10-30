class Event {
  final int id;
  final int categoryId;
  final String name;
  final String startTime;
  final String endTime;
  final String date;
  final Address address;
  final String descricao;
  final String distance;
  final double distanceInMeters;

  Event({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.address,
    required this.descricao,
    required this.distance,
    required this.distanceInMeters,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      categoryId: json['categoryId'],
      name: json['name'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      date: json['date'],
      address: Address.fromJson(json['address']),
      descricao: json['descricao'],
      distance: json['distance'],
      distanceInMeters: (json['distanceInMeters'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'address': address.toJson(),
      'descricao': descricao,
      'distance': distance,
      'distanceInMeters': distanceInMeters,
    };
  }
}

class Address {
  final String zipCode;
  final String street;
  final String number;
  final String logradouro;
  final String neighborhood;
  final String city;
  final String state;
  final double latitude;
  final double longitude;

  Address({
    required this.zipCode,
    required this.street,
    required this.number,
    required this.logradouro,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      zipCode: json['zipCode'],
      street: json['street'],
      number: json['number'],
      logradouro: json['logradouro'],
      neighborhood: json['neighborhood'],
      city: json['city'],
      state: json['state'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zipCode': zipCode,
      'street': street,
      'number': number,
      'logradouro': logradouro,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
