import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../providers/flight_providers.dart';
import '../models/app_models.dart';
import '../theme/app_colors.dart';
import '../widgets/ticket_clipper.dart';
import '../widgets/dash_divider.dart';
import '../widgets/dotted_line_painter.dart';
import 'search_results_screen.dart';
import 'flight_details_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);

    // List of pages as per your snippet
    final List<Widget> pages = [
      _buildHomeContent(context, ref), // Original search/trips content
      const Center(child: Text('Flights', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
      const Center(child: Text('Explore', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
      const Center(child: Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: pages[selectedIndex],
      bottomNavigationBar: _buildBottomNav(context, ref),
    );
  }

  Widget _buildHomeContent(BuildContext context, WidgetRef ref) {
    final fromAirport = ref.watch(fromAirportProvider);
    final toAirport = ref.watch(toAirportProvider);
    final depDate = ref.watch(departureDateProvider);
    final passengers = ref.watch(passengersProvider);

    String formatAirport(Airport? airport, String defaultStr) {
      if (airport == null) return defaultStr;
      return '${airport.city} (${airport.code})';
    }

    return Stack(
      children: [
        // Background Blue gradient
        Container(
          height: 480,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4A80F0), // Vibrant Blue
                Colors.white,       // Smooth fade to white
              ],
              stops: [0.0, 0.7],
            ),
          ),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Plan your trip',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30, width: 2),
                        color: Colors.white24,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://picsum.photos/200/200',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Main Booking Card with Glassmorphism
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // From & To Inputs + Swap Button
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Column(
                                children: [
                                  _buildAirportInput(
                                    context: context,
                                    ref: ref,
                                    label: 'From',
                                    value: formatAirport(
                                      fromAirport,
                                      'Select Departure',
                                    ),
                                    isFrom: true,
                                  ),
                                  _buildAirportInput(
                                    context: context,
                                    ref: ref,
                                    label: 'To',
                                    value: formatAirport(
                                      toAirport,
                                      'Select Destination',
                                    ),
                                    isFrom: false,
                                  ),
                                ],
                              ),
                              // Swap Button
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.cardBackground,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.subtextGrey.withOpacity(0.25),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.swap_vert,
                                    color: Color(0xFF9CA3AF),
                                    size: 22,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    final temp = ref.read(fromAirportProvider);
                                    ref.read(fromAirportProvider.notifier).state =
                                        ref.read(toAirportProvider);
                                    ref.read(toAirportProvider.notifier).state =
                                        temp;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),

                          // Departure & Amount row
                          Row(
                            children: [
                              Expanded(
                                child: _buildDateInput(context, ref, depDate),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildPassengerDropdown(
                                    context, ref, passengers),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // Search flights button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: (fromAirport != null && toAirport != null)
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const SearchResultsScreen(),
                                        ),
                                      );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentBlack,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text(
                                'Search flights',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Saved Trips Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Saved trips',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentBlack,
                      ),
                    ),
                    Text(
                      'See more',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Saved Trips Horizontal List
                SizedBox(
                  height: 215,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final savedPasses = ref.watch(savedPassesProvider);
                      if (savedPasses.isEmpty) {
                        return const Center(
                          child: Text(
                            'No downloaded passes yet.\nSave a pass to view it here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.subtextGrey, fontSize: 14),
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: savedPasses.length,
                        itemBuilder: (context, index) {
                          return _buildSavedTripCard(context, savedPasses[index]);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSavedTripCard(BuildContext context, FlightDetailsResponse pass) {
    final flight = pass.flightDetails;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailsScreen(flightId: flight.id),
          ),
        );
      },
      child: Container(
      width: 320, // Increased to provide proper spacing and barely show the next card
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipPath(
        clipper: TicketClipper(holeRadius: 14, holePosition: 0.63), 
        child: Container(
          color: AppColors.cardBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    Image.network(
                      flight.airlineLogo,
                      height: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Text(
                        flight.airlineName.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.greenAccent,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Departure
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flight.departure.time,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${flight.departure.airportCode} ',
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.textMain, fontFamily: 'Inter'),
                                  ),
                                  TextSpan(
                                    text: '(${flight.departure.city})',
                                    style: const TextStyle(fontSize: 10, color: AppColors.subtextGrey, fontFamily: 'Inter'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        // Center Flight Path (Line passing through icon)
                        SizedBox(
                          width: 48,
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  SizedBox(
                                    width: 48,
                                    height: 24,
                                    child: CustomPaint(
                                      painter: DottedLinePainter(
                                        color: AppColors.dashLine.withValues(alpha: 0.5),
                                        dashWidth: 2,
                                        dashSpace: 2,
                                        isArc: true,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10, // Perfectly centered on the smaller arc
                                    child: Transform.rotate(
                                      angle: 1.1,
                                      child: const Icon(Icons.airplanemode_active, color: AppColors.primaryBlue, size: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                flight.duration,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMain,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Arrival
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flight.arrival.time,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${flight.arrival.airportCode} ',
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.textMain, fontFamily: 'Inter'),
                                  ),
                                  TextSpan(
                                    text: '(${flight.arrival.city})',
                                    style: const TextStyle(fontSize: 10, color: AppColors.subtextGrey, fontFamily: 'Inter'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 28),

              // Divider
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: DashDivider(height: 1.5, color: AppColors.borderGrey),
              ),
              
              const SizedBox(height: 16),

              // Bottom Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DATE',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.subtextGrey,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(DateTime.parse(pass.bookingInfo.bookingDate)),
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textMain),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'CLASS',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.subtextGrey,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          flight.flightClass.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.primaryBlue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildAirportInput({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required String value,
    required bool isFrom,
  }) {
    return InkWell(
      onTap: () {
        _showAirportSearchSheet(context, ref, isFrom);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 12), // Only top padding, divider is at bottom
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.subtextGrey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 1.3, color: AppColors.borderGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInput(BuildContext context, WidgetRef ref, DateTime date) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryBlue,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: AppColors.textMain,
                ),
              ),
              child: child!,
            );
          },
        );
        if (d != null) {
          ref.read(departureDateProvider.notifier).state = d;
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Departure',
            style: TextStyle(
              color: AppColors.subtextGrey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('EEE, d MMM').format(date),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.subtextGrey,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1.3, color: AppColors.borderGrey),
        ],
      ),
    );
  }

  Widget _buildPassengerDropdown(
    BuildContext context,
    WidgetRef ref,
    int passengers,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount',
          style: TextStyle(
            color: AppColors.subtextGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () {
            _showPassengerPicker(context, ref, passengers);
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$passengers ${passengers == 1 ? 'person' : 'people'}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: AppColors.subtextGrey,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1.3, color: AppColors.borderGrey),
      ],
    );
  }

  void _showPassengerPicker(
    BuildContext context,
    WidgetRef ref,
    int currentPassengers,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Passengers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(7, (index) {
                final count = index + 1;
                final isSelected = count == currentPassengers;
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryBlue.withOpacity(0.1)
                          : AppColors.scaffoldBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color: isSelected
                            ? AppColors.primaryBlue
                            : AppColors.subtextGrey,
                        size: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    '$count ${count == 1 ? 'Person' : 'People'}',
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.textMain,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primaryBlue,
                          size: 22,
                        )
                      : null,
                  onTap: () {
                    ref.read(passengersProvider.notifier).state = count;
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(ref, Icons.home_rounded, 0, selectedIndex),
              _navItem(ref, Icons.flight_rounded, 1, selectedIndex),
              _navItem(ref, Icons.map_outlined, 2, selectedIndex),
              _navItem(ref, Icons.person_outline_rounded, 3, selectedIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(WidgetRef ref, IconData icon, int index, int selectedIndex) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A73E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Transform.rotate(
          angle: index == 1 ? math.pi / 2 : 0, 
          child: Icon(
            icon,
            size: 24,
            color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
          ),
        ),
      ),
    );
  }

  void _showAirportSearchSheet(
    BuildContext context,
    WidgetRef ref,
    bool isFrom,
  ) {
    // Reset search query before opening
    ref.read(searchAirportsQueryProvider.notifier).state = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Consumer(
            builder: (context, ref, _) {
              final airportsAsync = isFrom
                  ? ref.watch(departureAirportsProvider)
                  : ref.watch(arrivalAirportsProvider);

              return Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isFrom
                        ? 'Select Departure Airport'
                        : 'Select Arrival Airport',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search airport or city...',
                          hintStyle: const TextStyle(
                            color: AppColors.subtextGrey,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.subtextGrey,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                        ),
                        onChanged: (val) {
                          ref.read(searchAirportsQueryProvider.notifier).state =
                              val;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Airport List
                  Expanded(
                    child: airportsAsync.when(
                      data: (airports) {
                        if (airports.isEmpty) {
                          return const Center(
                            child: Text(
                              'No airports found',
                              style: TextStyle(color: AppColors.subtextGrey),
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: airports.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            indent: 70,
                            color: AppColors.borderGrey,
                          ),
                          itemBuilder: (context, index) {
                            final airport = airports[index];
                            return ListTile(
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(
                                    0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.flight_takeoff,
                                    color: AppColors.primaryBlue,
                                    size: 20,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${airport.city} (${airport.code})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                '${airport.flightCount} flights available',
                                style: const TextStyle(
                                  color: AppColors.subtextGrey,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: AppColors.subtextGrey,
                                size: 20,
                              ),
                              onTap: () {
                                if (isFrom) {
                                  ref.read(fromAirportProvider.notifier).state =
                                      airport;
                                } else {
                                  ref.read(toAirportProvider.notifier).state =
                                      airport;
                                }
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      error: (err, _) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.subtextGrey,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error loading airports',
                              style: TextStyle(color: AppColors.subtextGrey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      ref.read(searchAirportsQueryProvider.notifier).state = '';
    });
  }
}

