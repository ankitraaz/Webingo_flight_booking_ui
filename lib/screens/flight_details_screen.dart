import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/app_models.dart';
import '../providers/flight_providers.dart';
import '../theme/app_colors.dart';
import '../widgets/dash_divider.dart';
import '../widgets/ticket_clipper.dart';
import '../widgets/flight_path_widget.dart';

class FlightDetailsScreen extends ConsumerWidget {
  final int flightId;

  const FlightDetailsScreen({super.key, required this.flightId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(flightDetailsProvider(flightId));

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8EEFF),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.accentBlack,
                size: 18,
              ),
            ),
          ),
        ),
        title: const Text(
          'Your flight details',
          style: TextStyle(
            color: AppColors.accentBlack,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8EEFF), // Halka blue top ke liye
              Color(0xFFF8F9FD), // Light greyish white niche ke liye
            ],
            stops: [0.0, 0.3], // Gradient finished in top 30%
          ),
        ),
        child: detailsAsync.when(
        data: (response) {
          final detail = response.flightDetails;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      // SECTION 1: Flight Details Card (Dynamic Height)
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipPath(
                          clipper: TicketClipper(
                            holeRadius: 15,
                            holePosition: 0.7,
                            borderRadius: 24,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            color: Colors.white,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Airline Header
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.borderGrey
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: Image.network(
                                              detail.airlineLogo,
                                              width: 32,
                                              height: 32,
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(
                                                    Icons.flight,
                                                    color:
                                                        AppColors.primaryBlue,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          detail.airlineName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textMain,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      detail.flightId.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.subtextGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),

                                // Flight Path
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildAirportCol(
                                      detail.departure.time,
                                      detail.departure.airportCode,
                                      detail.departure.city,
                                      CrossAxisAlignment.start,
                                    ),
                                    _buildAirplaneMiddle(detail.duration),
                                    _buildAirportCol(
                                      detail.arrival.time,
                                      detail.arrival.airportCode,
                                      detail.arrival.city,
                                      CrossAxisAlignment.end,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 46,
                                ),
                                const DashDivider(
                                  height: 1.2,
                                  color: AppColors.borderGrey,
                                ),
                                const SizedBox(height: 16),

                                // INFO Grid
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildInfoGroup(
                                        'TERMINAL',
                                        detail.terminal,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildInfoGroup(
                                        'GATE',
                                        detail.gate,
                                        alignCenter: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildInfoGroup(
                                        'CLASS',
                                        detail.flightClass,
                                        alignEnd: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16), // Card gap: 16 px
                      // SECTION 2 & 3: Passenger & Barcode Pass
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipPath(
                          clipper: TicketClipper(
                            holeRadius: 15,
                            holePositionFromBottom: 118, // Dynamic Alignment: Fixed from bottom
                            borderRadius: 24,
                          ),
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Passenger Info Section
                                const Text(
                                  'Passengers Info',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textMain,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ...response.passengers.asMap().entries.map((entry) {
                                  int idx = entry.key;
                                  var p = entry.value;
                                  return Column(
                                    children: [
                                      _buildPassengerRow(p),
                                      if (idx < response.passengers.length - 1)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: Divider(
                                            height: 1,
                                            thickness: 0.5,
                                            color: AppColors.borderGrey.withOpacity(0.5),
                                          ),
                                        ),
                                    ],
                                  );
                                }),

                                 const SizedBox(
                                  height: 34, // Recalibrated for 134px bottom offset
                                ), 
                                const DashDivider(
                                  height: 1.2,
                                  color: AppColors.borderGrey,
                                ),
                                const SizedBox(height: 30),

                                // BARCODE TRY (As per your suggestion)
                                Center(
                                  child: Container(
                                    height: 70,
                                    width: double.infinity,
                                    child: ClipRect(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        heightFactor: 0.6, // Ensures numbers at bottom are always hidden
                                        child: response.bookingInfo.barcode.isNotEmpty
                                          ? SvgPicture.string(
                                              response.bookingInfo.barcode,
                                              width: double.infinity,
                                              height: 120, // Taller internal for cover effect
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/UPC-A-036000291452.svg/1200px-UPC-A-036000291452.svg.png',
                                              width: double.infinity,
                                              height: 120,
                                              fit: BoxFit.cover,
                                              color: Colors.black,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Consumer(
                  builder: (context, ref, _) {
                    final savedPasses = ref.watch(savedPassesProvider);
                    final isSaved = savedPasses.any(
                      (p) => p.flightDetails.id == detail.id,
                    );

                    return ElevatedButton(
                      onPressed: isSaved
                          ? null
                          : () {
                              ref
                                  .read(savedPassesProvider.notifier)
                                  .savePass(response);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pass saved successfully!'),
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSaved
                            ? Colors.grey.shade400
                            : AppColors.accentBlack,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: isSaved ? 0 : 4,
                      ),
                      child: Text(
                        isSaved ? 'Pass Saved' : 'Download & Save pass',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    ),
  );
}

  Widget _buildAirplaneMiddle(String duration) {
    return FlightPathWidget(duration: duration);
  }

  Widget _buildAirportCol(
    String time,
    String code,
    String city,
    CrossAxisAlignment align,
  ) {
    // Format time to AM/PM
    String formattedTime = time;
    try {
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      final min = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      formattedTime = '${hour.toString().padLeft(2, '0')}:$min $period';
    } catch (_) {}

    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          formattedTime,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              code,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '($city)',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.subtextGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoGroup(
    String label,
    String value, {
    bool alignEnd = false,
    bool alignCenter = false,
  }) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : (alignCenter
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start),
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.subtextGrey,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textMain,
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerRow(Passenger p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              p.profilePicture,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 44,
                height: 44,
                color: AppColors.primaryBlue.withOpacity(0.1),
                child: const Icon(Icons.person, color: AppColors.primaryBlue),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PASSENGER ${p.number}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.subtextGrey,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${p.title} ${p.name}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'SEAT',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.subtextGrey,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                p.seat,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
