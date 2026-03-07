import 'package:taxi_booking/core/utilitis/enum/driver_enums.dart';
import 'package:taxi_booking/core/utilitis/extension/ride_details_extensions_driver.dart';

class RideDetailsResponse {
  final bool? success;
  final num? statusCode;
  final String? message;
  final _RideData? data;

  RideDetailsResponse({this.success, this.statusCode, this.message, this.data});

  factory RideDetailsResponse.fromJson(Map<String, dynamic> json) {
    return RideDetailsResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? _RideData.fromJson(json['data']) : null,
    );
  }
}

class _RideData {
  final String? id;
  final _Location? pickupLocation;
  final _Location? dropOffLocation;
  final _Fare? fare;
  final _Commission? commission;
  final _Payment? payment;
  final _Passenger? passenger;
  final _Driver? driver;
  final _Vehicle? vehicle;
  final String? status;
  final double? estimatedDistanceKm;
  final double? estimatedDurationMin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  DriverStatus get driverStatus => mapApiStatusToDriverStatus(status);

  _RideData({
    this.id,
    this.pickupLocation,
    this.dropOffLocation,
    this.fare,
    this.commission,
    this.payment,
    this.passenger,
    this.driver,
    this.vehicle,
    this.status,
    this.estimatedDistanceKm,
    this.estimatedDurationMin,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory _RideData.fromJson(Map<String, dynamic> json) {
    return _RideData(
      id: json['_id'],
      pickupLocation: json['pickupLocation'] != null
          ? _Location.fromJson(json['pickupLocation'])
          : null,
      dropOffLocation: json['dropOffLocation'] != null
          ? _Location.fromJson(json['dropOffLocation'])
          : null,
      fare: json['fare'] != null ? _Fare.fromJson(json['fare']) : null,
      commission: json['commission'] != null
          ? _Commission.fromJson(json['commission'])
          : null,
      payment: json['payment'] != null
          ? _Payment.fromJson(json['payment'])
          : null,
      passenger: json['passengerId'] != null
          ? _Passenger.fromJson(json['passengerId'])
          : null,
      driver: json['driverId'] != null
          ? _Driver.fromJson(json['driverId'])
          : null,
      vehicle: json['vehicleId'] != null
          ? _Vehicle.fromJson(json['vehicleId'])
          : null,
      status: json['status'],
      estimatedDistanceKm: (json['estimatedDistanceKm'] as num?)?.toDouble(),
      estimatedDurationMin: (json['estimatedDurationMin'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}

class _Location {
  final String? type;
  final List<double>? coordinates;
  final String? address;

  _Location({this.type, this.coordinates, this.address});

  factory _Location.fromJson(Map<String, dynamic> json) {
    return _Location(
      type: json['type'],
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      address: json['address'],
    );
  }
}

class _Fare {
  final num? baseFare;
  final num? distanceFare;
  final num? timeFare;
  final num? surgeMultiplier;
  final num? totalFare;

  _Fare({
    this.baseFare,
    this.distanceFare,
    this.timeFare,
    this.surgeMultiplier,
    this.totalFare,
  });

  factory _Fare.fromJson(Map<String, dynamic> json) {
    return _Fare(
      baseFare: json['baseFare'],
      distanceFare: json['distanceFare'],
      timeFare: json['timeFare'],
      surgeMultiplier: json['surgeMultiplier'],
      totalFare: json['totalFare'],
    );
  }
}

class _Commission {
  final num? platformFee;
  final num? driverEarning;
  final num? fleetOwnerEarning;

  _Commission({this.platformFee, this.driverEarning, this.fleetOwnerEarning});

  factory _Commission.fromJson(Map<String, dynamic> json) {
    return _Commission(
      platformFee: json['platformFee'],
      driverEarning: json['driverEarning'],
      fleetOwnerEarning: json['fleetOwnerEarning'],
    );
  }
}

class _Payment {
  final String? status;
  final String? transactionId;
  final String? method;

  _Payment({this.status, this.transactionId, this.method});

  factory _Payment.fromJson(Map<String, dynamic> json) {
    return _Payment(
      status: json['status'],
      transactionId: json['transactionId'],
      method: json['method'],
    );
  }
}

class _Passenger {
  final String? id;
  final String? email;
  final String? phone;
  final String? role;
  final _PassengerUser? user;
  final bool? isActive;
  final bool? isDeleted;
  final bool? isOnline;

  _Passenger({
    this.id,
    this.email,
    this.phone,
    this.role,
    this.user,
    this.isActive,
    this.isDeleted,
    this.isOnline,
  });

  factory _Passenger.fromJson(Map<String, dynamic> json) {
    return _Passenger(
      id: json['_id'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      user: json['user'] != null ? _PassengerUser.fromJson(json['user']) : null,
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      isOnline: json['isOnline'],
    );
  }
}

class _PassengerUser {
  final String? id;
  final String? fullname;
  final String? image;
  final String? phone;
  final String? email;
  final String? status;

  _PassengerUser({
    this.id,
    this.fullname,
    this.image,
    this.phone,
    this.email,
    this.status,
  });

  factory _PassengerUser.fromJson(Map<String, dynamic> json) {
    return _PassengerUser(
      id: json['_id'],
      fullname: json['fullname'],
      image: json['image'],
      phone: json['phone'],
      email: json['email'],
      status: json['status'],
    );
  }
}

class _Driver {
  final String? id;
  final String? role;
  final String? status;
  final bool? isActive;
  final bool? isDeleted;
  final bool? isVerified;
  final bool? isOnline;
  final String? stripeAccountId;
  final _DriverUser? user; // nested user info

  _Driver({
    this.id,
    this.role,
    this.status,
    this.isActive,
    this.isDeleted,
    this.isVerified,
    this.isOnline,
    this.stripeAccountId,
    this.user,
  });

  factory _Driver.fromJson(Map<String, dynamic> json) {
    return _Driver(
      id: json['_id'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      isActive: json['isActive'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      isVerified: json['isVerified'] as bool?,
      isOnline: json['isOnline'] as bool?,
      stripeAccountId: json['stripeAccountId'] as String?,
      user: json['user'] != null
          ? _DriverUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

class _DriverUser {
  final String? id;
  final String? phone;
  final String? email;
  final String? name;
  final _Address? address;
  final String? status;

  _DriverUser({
    this.id,
    this.phone,
    this.email,
    this.address,
    this.status,
    this.name,
  });

  factory _DriverUser.fromJson(Map<String, dynamic> json) {
    return _DriverUser(
      id: json['_id'] as String?,
      phone: json['phone'] as String?,
      name: json['fullName'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String?,
      address: json['address'] != null
          ? _Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }
}

class _Address {
  final String? street;
  final String? postalCode;
  final String? city;
  final String? country;
  final String? id;

  _Address({this.street, this.postalCode, this.city, this.country, this.id});

  factory _Address.fromJson(Map<String, dynamic> json) {
    return _Address(
      street: json['street'] as String?,
      postalCode: json['postalCode'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      id: json['_id'] as String?,
    );
  }
}

class _Vehicle {
  final String? id;
  final String? model;
  final String? color;
  final _VehiclePhotos? photos;

  _Vehicle({this.id, this.model, this.color, this.photos});

  factory _Vehicle.fromJson(Map<String, dynamic> json) {
    return _Vehicle(
      id: json['_id'],
      model: json['model'],
      color: json['color'],
      photos: json['photos'] != null
          ? _VehiclePhotos.fromJson(json['photos'])
          : null,
    );
  }
}

class _VehiclePhotos {
  final String? front;
  final String? rear;
  final String? interior;

  _VehiclePhotos({this.front, this.rear, this.interior});

  factory _VehiclePhotos.fromJson(Map<String, dynamic> json) {
    return _VehiclePhotos(
      front: json['front'],
      rear: json['rear'],
      interior: json['interior'],
    );
  }
}
