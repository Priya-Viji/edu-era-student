import 'package:eduera_student/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterPage extends StatefulWidget {
  final List<String> initialCategories;
  final List<String> initialLevels;
  final bool? initialIsFree;
  final double? initialRating;

  const FilterPage({
    super.key,
    this.initialCategories = const [],
    this.initialLevels = const [],
    this.initialIsFree,
    this.initialRating,
  });

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late List<String> selectedCategories;
  late List<String> selectedLevels;
  bool? selectedIsFree;
  double? selectedRating;

  final List<String> levels = ['Beginners', 'Intermediate', 'Advanced'];
  final Map<String, double> ratingOptions = {
    '4.5 & Up Above': 4.5,
    '4.0 & Up Above': 4.0,
    '3.5 & Up Above': 3.5,
    '3.0 & Up Above': 3.0,
  };

  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.initialCategories);
    selectedLevels = List.from(widget.initialLevels);
    selectedIsFree = widget.initialIsFree;
    selectedRating = widget.initialRating;

    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedCategories.clear();
                selectedLevels.clear();
                selectedIsFree = null;
                selectedRating = null;
              });
            },
            child: const Text(
              'Clear',
              style: TextStyle(
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Section
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is CategoryLoaded) {
                        return _buildCheckboxSection(
                          'Categories:',
                          state.categories.map((c) => c.name).toList(),
                          selectedCategories,
                        );
                      } else if (state is CategoryError) {
                        return Text(
                          "Error: ${state.message}",
                          style: const TextStyle(color: Colors.red),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 24),

                  // Levels Section
                  _buildCheckboxSection('Levels:', levels, selectedLevels),
                  const SizedBox(height: 24),

                  // Price Section
                  _buildRadioSection(
                    'Price:',
                    ['Paid', 'Free'],
                    selectedIsFree == null
                        ? ''
                        : selectedIsFree == true
                        ? 'Free'
                        : 'Paid',
                    (value) {
                      setState(() {
                        selectedIsFree = value == 'Free';
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Rating Section
                  _buildRatingSection(),
                ],
              ),
            ),
          ),
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildCheckboxSection(
    String title,
    List<String> options,
    List<String> selectedList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...options.map((option) {
          final isSelected = selectedList.contains(option);
          return InkWell(
            onTap: () {
              setState(() {
                isSelected
                    ? selectedList.remove(option)
                    : selectedList.add(option);
              });
            },
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  activeColor: const Color(0xFF00897B),
                  onChanged: (_) {
                    setState(() {
                      isSelected
                          ? selectedList.remove(option)
                          : selectedList.add(option);
                    });
                  },
                ),
                Text(
                  option,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

    Widget _buildRadioSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...options.map((option) {
          final isSelected = selectedValue == option;
          return InkWell(
            onTap: () => onChanged(option),
            child: Row(
              children: [
                Radio<String>(
                  value: selectedValue,
                  groupValue: selectedValue,
                  activeColor: const Color(0xFF00897B),
                  onChanged: (val) {
                    if (val != null) onChanged(val);
                  },
                ),
                Text(
                  option,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rating:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...ratingOptions.entries.map((entry) {
          final isSelected = selectedRating == entry.value;
          return InkWell(
            onTap: () {
              setState(() {
                selectedRating = entry.value;
              });
            },
            child: Row(
              children: [
                Radio<double>(
                  value: entry.value,
                  groupValue: selectedRating,
                  activeColor: const Color(0xFF00897B),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedRating = val;
                      });
                    }
                  },
                ),
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
  
  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            final filters = {
              "categories": selectedCategories,
              "levels": selectedLevels,
              "isFree": selectedIsFree,
              "rating": selectedRating,
            };
            Navigator.pop(context, filters); // ✅ return filters to caller
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Apply',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
