import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../theme/app_colors.dart';
import 'flight_path_widget.dart';
import 'ticket_clipper.dart';
import 'dash_divider.dart';
import '../screens/flight_details_screen.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;

  const FlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FlightDetailsScreen(flightId: flight.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), // Subtle shadow
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipPath(
          clipper: TicketClipper(holeRadius: 14, holePosition: 0.63),
          child: Container(
            color: AppColors.cardBackground,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header: Circular Logo + Airline Name
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.borderGrey.withValues(alpha: 0.5),
                          width: 1.0,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          flight.airlineLogo,
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.flight,
                            color: AppColors.primaryBlue,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      flight.airlineName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Flight Route
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAirportColumn(
                      flight.departure.time,
                      flight.departure.airportCode,
                      flight.departure.city,
                      CrossAxisAlignment.start,
                    ),
                    FlightPathWidget(duration: flight.duration),
                    _buildAirportColumn(
                      flight.arrival.time,
                      flight.arrival.airportCode,
                      flight.arrival.city,
                      CrossAxisAlignment.start,
                    ),
                  ],
                ),
                const SizedBox(height: 34),

                // Divider (Dashed)
                const DashDivider(height: 1.5, color: AppColors.borderGrey),
                const SizedBox(height: 12),

                // Footer: Price & Select flight
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${flight.price.amount.toInt()}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const Text(
                          '/person',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.subtextGrey,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FlightDetailsScreen(flightId: flight.id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentBlack,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Select flight',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAirportColumn(
    String time,
    String code,
    String city,
    CrossAxisAlignment alignment,
  ) {
    String formattedTime = time;
    if (time.contains(':')) {
      List<String> parts = time.split(':');
      if (parts.length >= 2) formattedTime = "${parts[0]}:${parts[1]}";
    }

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: code,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                  fontFamily: 'Inter',
                ),
              ),
              const TextSpan(text: ' '),
              TextSpan(
                text: '($city)',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subtextGrey,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
