import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_models.dart';
import '../providers/flight_providers.dart';
import '../theme/app_colors.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late FlightFilters _currentFilters;

  @override
  void initState() {
    super.initState();
    _currentFilters = ref.read(flightFiltersProvider);
  }

  @override
  Widget build(BuildContext context) {
    final airlinesAsync = ref.watch(airlinesProvider);
    final aircraftAsync = ref.watch(aircraftTypesProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textMain),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentFilters = FlightFilters();
                  });
                },
                child: const Text('Reset', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Price Range
          _buildSectionHeader('Price Range'),
          RangeSlider(
            values: RangeValues(_currentFilters.priceMin, _currentFilters.priceMax),
            min: 0,
            max: 2000,
            divisions: 20,
            activeColor: AppColors.primaryBlue,
            inactiveColor: AppColors.primaryBlue.withValues(alpha: 0.1),
            labels: RangeLabels(
              '\$${_currentFilters.priceMin.toInt()}',
              '\$${_currentFilters.priceMax.toInt()}',
            ),
            onChanged: (values) {
              setState(() {
                _currentFilters = _currentFilters.copyWith(
                  priceMin: values.start,
                  priceMax: values.end,
                );
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$0', style: TextStyle(color: AppColors.subtextGrey, fontSize: 12)),
              Text('\$2000', style: TextStyle(color: AppColors.subtextGrey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),

          // Stops
          _buildSectionHeader('Stops'),
          Row(
            children: [0, 1, 2].map((s) {
              final isSelected = _currentFilters.stops == s;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ChoiceChip(
                  label: Text(s == 0 ? 'Non-stop' : '$s Stop${s > 1 ? 's' : ''}'),
                  selected: isSelected,
                  selectedColor: AppColors.primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textMain,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _currentFilters = _currentFilters.copyWith(stops: s));
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Airline
          _buildSectionHeader('Airlines'),
          SizedBox(
            height: 40,
            child: airlinesAsync.when(
              data: (airlines) => ListView(
                scrollDirection: Axis.horizontal,
                children: airlines.map((a) {
                  final isSelected = _currentFilters.airline == a;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(a),
                      selected: isSelected,
                      selectedColor: AppColors.primaryBlue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textMain,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (val) {
                        setState(() => _currentFilters = _currentFilters.copyWith(airline: val ? a : ''));
                      },
                    ),
                  );
                }).toList(),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('Error loading airlines'),
            ),
          ),
          const SizedBox(height: 24),

          // Aircraft
          _buildSectionHeader('Aircraft Type'),
          SizedBox(
            height: 40,
            child: aircraftAsync.when(
              data: (types) => ListView(
                scrollDirection: Axis.horizontal,
                children: types.map((t) {
                  final isSelected = _currentFilters.aircraftType == t;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(t),
                      selected: isSelected,
                      selectedColor: AppColors.primaryBlue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textMain,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (val) {
                        setState(() => _currentFilters = _currentFilters.copyWith(aircraftType: val ? t : ''));
                      },
                    ),
                  );
                }).toList(),
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ),
          const SizedBox(height: 32),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                ref.read(flightFiltersProvider.notifier).state = _currentFilters;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlack,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textMain),
      ),
    );
  }
}
