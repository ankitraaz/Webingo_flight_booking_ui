import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_models.dart';

class FlightApiService {
  static const String baseUrl = 'https://flight.wigian.in/flight_api.php';

  Future<List<Flight>> searchFlights({
    required String fromCode,
    required String toCode,
    int passengers = 1,
    String sortBy = 'price_asc',
    String travelDate = '',
    FlightFilters? filters,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "from": fromCode,
        "to": toCode,
        "date": travelDate,
        "passengers": passengers,
        "sort_by": sortBy,
        "filters": (filters ?? FlightFilters()).toJson(),
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> flightsJson = jsonResponse['data']['flights'];
        return flightsJson.map((f) => Flight.fromJson(f)).toList();
      }
    }
    throw Exception('Failed to load flights');
  }

  Future<List<Airport>> getDepartureAirports(String searchQuery) async {
    return _getAirports('$baseUrl/airports/from', searchQuery);
  }

  Future<List<Airport>> getArrivalAirports(String searchQuery) async {
    return _getAirports('$baseUrl/airports/to', searchQuery);
  }

  Future<List<Airport>> _getAirports(String url, String searchQuery) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "search": searchQuery,
        "limit": 50,
        "page": 1
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> airportsJson = jsonResponse['data']['airports'];
        return airportsJson.map((a) => Airport.fromJson(a)).toList();
      }
    }
    throw Exception('Failed to load airports');
  }

  Future<FlightDetailsResponse> getFlightDetails(int flightId, {int passengers = 1}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/flight'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": flightId,
        "passengers": passengers
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return FlightDetailsResponse.fromJson(jsonResponse['data']);
      }
    }
    throw Exception('Failed to load flight details');
  }

  Future<List<String>> getAirlines() async {
    final response = await http.post(
      Uri.parse('$baseUrl/airlines'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> airlinesJson = jsonResponse['data']['airlines'];
        return airlinesJson.map((e) => e['airline'] as String).toList();
      }
    }
    return [];
  }

  Future<List<String>> getAircraftTypes() async {
    final response = await http.post(
      Uri.parse('$baseUrl/aircraft-types'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> aircraftJson = jsonResponse['data']['aircraft_types'];
        return aircraftJson.map((e) => e['aircraft'] as String).toList();
      }
    }
    return [];
  }
}
