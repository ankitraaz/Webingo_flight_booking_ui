import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/flight_providers.dart';
import '../theme/app_colors.dart';
import '../widgets/flight_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../models/app_models.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  int _selectedFilter = 0;

  final List<String> _filters = ['Lowest to Highest', 'Preferred airlines', 'Flight duration'];
  final List<String> _sortValues = ['price_asc', 'price_desc', 'duration_asc'];

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = ref.watch(flightSearchResultsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE8EEFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8EEFF),
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.accentBlack, size: 22),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        title: const Text(
          'Flight result',
          style: TextStyle(
            color: AppColors.accentBlack,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.accentBlack, size: 18),
                padding: EdgeInsets.zero,
                onPressed: () {},
              ),
            ),
          ),
        ],
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
        child: Column(
        children: [
          const SizedBox(height: 8),
          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(_filters.length, (index) {
                final isSelected = index == _selectedFilter;
                return Padding(
                  padding: EdgeInsets.only(right: index < _filters.length - 1 ? 10 : 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedFilter = index);
                      ref.read(flightSortByProvider.notifier).state = _sortValues[index];
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryBlue : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryBlue : AppColors.borderGrey,
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [],
                      ),
                      child: Text(
                        _filters[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textMain,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Clear Filters Indicator
          Consumer(
            builder: (context, ref, _) {
              final filters = ref.watch(flightFiltersProvider);
              if (filters.isDefault) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.filter_alt, size: 14, color: AppColors.primaryBlue),
                          const SizedBox(width: 6),
                          const Text('Filters applied', style: TextStyle(fontSize: 12, color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => ref.read(flightFiltersProvider.notifier).state = FlightFilters(),
                            child: const Icon(Icons.close, size: 14, color: AppColors.primaryBlue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Flight Results List
          Expanded(
            child: searchResultsAsync.when(
              data: (flights) {
                if (flights.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flight_outlined, size: 60, color: AppColors.subtextGrey.withOpacity(0.4)),
                        const SizedBox(height: 12),
                        const Text(
                          'No flights found',
                          style: TextStyle(
                            color: AppColors.subtextGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 20),
                  itemCount: flights.length,
                  itemBuilder: (context, index) {
                    return FlightCard(flight: flights[index]);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryBlue),
              ),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: AppColors.subtextGrey),
                    const SizedBox(height: 12),
                    Text(
                      'Something went wrong',
                      style: TextStyle(color: AppColors.subtextGrey, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.refresh(flightSearchResultsProvider),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: Consumer(
        builder: (context, ref, _) {
          final filters = ref.watch(flightFiltersProvider);
          final hasFilters = !filters.isDefault;

          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const FilterBottomSheet(),
              );
            },
            backgroundColor: const Color(0xFFB3C8FF),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.filter_alt_outlined, color: AppColors.primaryBlue, size: 24),
                if (hasFilters)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
