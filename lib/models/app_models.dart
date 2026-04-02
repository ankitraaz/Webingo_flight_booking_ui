class Airport {
  final String code;
  final String city;
  final int flightCount;

  Airport({required this.code, required this.city, required this.flightCount});

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      code: json['airport_code'] ?? '',
      city: json['city'] ?? '',
      flightCount: json['flight_count'] ?? 0,
    );
  }
}

class FlightTime {
  final String time;
  final String airportCode;
  final String city;

  FlightTime({required this.time, required this.airportCode, required this.city});

  factory FlightTime.fromJson(Map<String, dynamic> json) {
    return FlightTime(
      time: (json['time'] as String?)?.split(':').take(2).join(':') ?? '',
      airportCode: json['airport_code'] ?? '',
      city: json['city'] ?? '',
    );
  }
}

class Price {
  final double amount;
  final String currency;

  Price({required this.amount, required this.currency});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
    );
  }
}

class Flight {
  final int id;
  final String airlineName;
  final String airlineLogo;
  final String flightNumber;
  final FlightTime departure;
  final FlightTime arrival;
  final String duration;
  final Price price;
  final String aircraftType;
  final int stops;

  Flight({
    required this.id,
    required this.airlineName,
    required this.airlineLogo,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.price,
    required this.aircraftType,
    required this.stops,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'] ?? 0,
      airlineName: json['airline_name'] ?? '',
      airlineLogo: json['airline_logo'] ?? '',
      flightNumber: json['flight_number'] ?? '',
      departure: FlightTime.fromJson(json['departure'] ?? {}),
      arrival: FlightTime.fromJson(json['arrival'] ?? {}),
      duration: json['duration'] ?? '',
      price: Price.fromJson(json['price'] ?? {}),
      aircraftType: json['aircraft_type'] ?? '',
      stops: json['stops'] ?? 0,
    );
  }
}

class Passenger {
  final int number;
  final String title;
  final String name;
  final String seat;
  final String profilePicture;

  Passenger({
    required this.number,
    required this.title,
    required this.name,
    required this.seat,
    required this.profilePicture,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      number: json['passenger_number'] ?? 0,
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      seat: json['seat'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
    );
  }
}

class BookingInfo {
  final int totalPassengers;
  final String bookingReference;
  final String bookingDate;
  final String barcode; // SVG string

  BookingInfo({
    required this.totalPassengers,
    required this.bookingReference,
    required this.bookingDate,
    required this.barcode,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      totalPassengers: json['total_passengers'] ?? 0,
      bookingReference: json['booking_reference'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      barcode: json['barcode'] ?? '',
    );
  }
}

class DetailedFlightInfo {
  final int id;
  final String airlineName;
  final String airlineLogo;
  final String flightId;
  final String flightNumber;
  final FlightTime departure;
  final FlightTime arrival;
  final String duration;
  final String aircraftType;
  final int stops;
  final String terminal;
  final String gate;
  final String flightClass;

  DetailedFlightInfo({
    required this.id,
    required this.airlineName,
    required this.airlineLogo,
    required this.flightId,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.aircraftType,
    required this.stops,
    required this.terminal,
    required this.gate,
    required this.flightClass,
  });

  factory DetailedFlightInfo.fromJson(Map<String, dynamic> json) {
    return DetailedFlightInfo(
      id: json['id'] ?? 0,
      airlineName: json['airline_name'] ?? '',
      airlineLogo: json['airline_logo'] ?? '',
      flightId: json['flight_id'] ?? '',
      flightNumber: json['flight_number'] ?? '',
      departure: FlightTime.fromJson(json['departure'] ?? {}),
      arrival: FlightTime.fromJson(json['arrival'] ?? {}),
      duration: json['duration'] ?? '',
      aircraftType: json['aircraft_type'] ?? '',
      stops: json['stops'] ?? 0,
      terminal: json['terminal'] ?? '',
      gate: json['gate'] ?? '',
      flightClass: json['class'] ?? '',
    );
  }
}

class FlightDetailsResponse {
  final DetailedFlightInfo flightDetails;
  final List<Passenger> passengers;
  final BookingInfo bookingInfo;

  FlightDetailsResponse({
    required this.flightDetails,
    required this.passengers,
    required this.bookingInfo,
  });

  factory FlightDetailsResponse.fromJson(Map<String, dynamic> json) {
    return FlightDetailsResponse(
      flightDetails: DetailedFlightInfo.fromJson(json['flight_details'] ?? {}),
      passengers: (json['passengers'] as List<dynamic>?)
              ?.map((e) => Passenger.fromJson(e))
              .toList() ??
          [],
      bookingInfo: BookingInfo.fromJson(json['booking_info'] ?? {}),
    );
  }
}

class FlightFilters {
  final String airline;
  final double priceMin;
  final double priceMax;
  final int stops;
  final String aircraftType;

  FlightFilters({
    this.airline = '',
    this.priceMin = 0.0,
    this.priceMax = 1000.0,
    this.stops = 0,
    this.aircraftType = '',
  });

  FlightFilters copyWith({
    String? airline,
    double? priceMin,
    double? priceMax,
    int? stops,
    String? aircraftType,
  }) {
    return FlightFilters(
      airline: airline ?? this.airline,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      stops: stops ?? this.stops,
      aircraftType: aircraftType ?? this.aircraftType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "airline": airline,
      "price_min": priceMin.toInt(),
      "price_max": priceMax.toInt(),
      "stops": stops,
      "aircraft_type": aircraftType,
    };
  }

  bool get isDefault =>
      airline.isEmpty &&
      priceMin == 0.0 &&
      priceMax == 1000.0 &&
      stops == 0 &&
      aircraftType.isEmpty;
}
