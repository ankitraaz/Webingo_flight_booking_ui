import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_models.dart';
import '../services/flight_api_service.dart';

// API Service Provider
final flightApiServiceProvider = Provider((ref) => FlightApiService());

// Form State Providers
final fromAirportProvider = StateProvider<Airport?>((ref) => Airport(code: 'CGK', city: 'Jakarta', flightCount: 10));
final toAirportProvider = StateProvider<Airport?>((ref) => Airport(code: 'NRT', city: 'Tokyo', flightCount: 10));
final departureDateProvider = StateProvider<DateTime>((ref) => DateTime.now().add(const Duration(days: 2)));
final passengersProvider = StateProvider<int>((ref) => 3);

// Search Query Provider
final searchAirportsQueryProvider = StateProvider<String>((ref) => '');

// Bottom Nav State Provider
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// Filter & Sort Providers
final flightSortByProvider = StateProvider<String>((ref) => 'price_asc');
final flightFiltersProvider = StateProvider<FlightFilters>((ref) => FlightFilters());

// FutureProviders for Metadata
final airlinesProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(flightApiServiceProvider).getAirlines();
});

final aircraftTypesProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(flightApiServiceProvider).getAircraftTypes();
});

// FutureProviders for Airport Search
final departureAirportsProvider = FutureProvider<List<Airport>>((ref) async {
  final query = ref.watch(searchAirportsQueryProvider);
  return ref.read(flightApiServiceProvider).getDepartureAirports(query);
});

final arrivalAirportsProvider = FutureProvider<List<Airport>>((ref) async {
  final query = ref.watch(searchAirportsQueryProvider);
  return ref.read(flightApiServiceProvider).getArrivalAirports(query);
});

// Flight Search Results FutureProvider
final flightSearchResultsProvider = FutureProvider<List<Flight>>((ref) async {
  final from = ref.watch(fromAirportProvider);
  final to = ref.watch(toAirportProvider);
  final date = ref.watch(departureDateProvider);
  final passengers = ref.watch(passengersProvider);
  final sortBy = ref.watch(flightSortByProvider);
  final filters = ref.watch(flightFiltersProvider);

  if (from == null || to == null) return [];

  return ref.read(flightApiServiceProvider).searchFlights(
    fromCode: from.code,
    toCode: to.code,
    passengers: passengers,
    sortBy: sortBy,
    filters: filters,
    travelDate: "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  );
});

class SavedPassesNotifier extends StateNotifier<List<FlightDetailsResponse>> {
  SavedPassesNotifier() : super([]);

  void savePass(FlightDetailsResponse pass) {
    // Save only if it hasn't been saved already
    if (!state.any((p) => p.flightDetails.id == pass.flightDetails.id)) {
      state = [...state, pass];
    }
  }
}

// Dedicated StateNotifierProvider for perfectly saving exact passes
final savedPassesProvider = StateNotifierProvider<SavedPassesNotifier, List<FlightDetailsResponse>>((ref) {
  return SavedPassesNotifier();
});

// Details FutureProvider
final flightDetailsProvider = FutureProvider.family<FlightDetailsResponse, int>((ref, flightId) async {
  final passengers = ref.watch(passengersProvider);
  return ref.read(flightApiServiceProvider).getFlightDetails(flightId, passengers: passengers);
});
