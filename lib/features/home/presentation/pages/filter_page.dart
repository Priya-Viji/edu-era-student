// import 'package:eduera_student/features/home/presentation/bloc/category/category_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class FilterPage extends StatefulWidget {
//   final List<String> initialCategories;
//   final List<String> initialLevels;
//   final bool? initialIsFree;
//   final double? initialRating;

//   const FilterPage({
//     super.key,
//     this.initialCategories = const [],
//     this.initialLevels = const [],
//     this.initialIsFree,
//     this.initialRating,
//   });

//   @override
//   State<FilterPage> createState() => _FilterPageState();
// }

// class _FilterPageState extends State<FilterPage> {
//   late List<String> selectedCategories;
//   late List<String> selectedLevels;
//   bool? selectedIsFree;
//   double? selectedRating;

//   final List<String> levels = ['Beginners', 'Intermediate', 'Advanced'];
//   final Map<String, double> ratingOptions = {
//     '4.5 & Up Above': 4.5,
//     '4.0 & Up Above': 4.0,
//     '3.5 & Up Above': 3.5,
//     '3.0 & Up Above': 3.0,
//   };

//   @override
//   void initState() {
//     super.initState();
//     selectedCategories = List.from(widget.initialCategories);
//     selectedLevels = List.from(widget.initialLevels);
//     selectedIsFree = widget.initialIsFree;
//     selectedRating = widget.initialRating;

//     context.read<CategoryBloc>().add(LoadCategoriesEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Filter',
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 selectedCategories.clear();
//                 selectedLevels.clear();
//                 selectedIsFree = null;
//                 selectedRating = null;
//               });
//             },
//             child: const Text(
//               'Clear',
//               style: TextStyle(
//                 color: Color(0xFF2196F3),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Categories Section
//                   BlocBuilder<CategoryBloc, CategoryState>(
//                     builder: (context, state) {
//                       if (state is CategoryLoading) {
//                         return const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20),
//                             child: CircularProgressIndicator(),
//                           ),
//                         );
//                       } else if (state is CategoryLoaded) {
//                         return _buildCheckboxSection(
//                           'Categories:',
//                           state.categories.map((c) => c.name).toList(),
//                           selectedCategories,
//                         );
//                       } else if (state is CategoryError) {
//                         return Text(
//                           "Error: ${state.message}",
//                           style: const TextStyle(color: Colors.red),
//                         );
//                       }
//                       return const SizedBox.shrink();
//                     },
//                   ),
//                   const SizedBox(height: 24),

//                   // Levels Section
//                   _buildCheckboxSection('Levels:', levels, selectedLevels),
//                   const SizedBox(height: 24),

//                   // Price Section
//                   _buildRadioSection(
//                     'Price:',
//                     ['Paid', 'Free'],
//                     selectedIsFree == null
//                         ? ''
//                         : selectedIsFree == true
//                         ? 'Free'
//                         : 'Paid',
//                     (value) {
//                       setState(() {
//                         selectedIsFree = value == 'Free';
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 24),

//                   // Rating Section
//                   _buildRatingSection(),
//                 ],
//               ),
//             ),
//           ),
//           _buildApplyButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildCheckboxSection(
//     String title,
//     List<String> options,
//     List<String> selectedList,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...options.map((option) {
//           final isSelected = selectedList.contains(option);
//           return InkWell(
//             onTap: () {
//               setState(() {
//                 isSelected
//                     ? selectedList.remove(option)
//                     : selectedList.add(option);
//               });
//             },
//             child: Row(
//               children: [
//                 Checkbox(
//                   value: isSelected,
//                   activeColor: const Color(0xFF00897B),
//                   onChanged: (_) {
//                     setState(() {
//                       isSelected
//                           ? selectedList.remove(option)
//                           : selectedList.add(option);
//                     });
//                   },
//                 ),
//                 Text(
//                   option,
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: isSelected
//                         ? FontWeight.w600
//                         : FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }

//     Widget _buildRadioSection(
//     String title,
//     List<String> options,
//     String selectedValue,
//     Function(String) onChanged,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...options.map((option) {
//           final isSelected = selectedValue == option;
//           return InkWell(
//             onTap: () => onChanged(option),
//             child: Row(
//               children: [
//                 Radio<String>(
//                   value: selectedValue,
//                   groupValue: selectedValue,
//                   activeColor: const Color(0xFF00897B),
//                   onChanged: (val) {
//                     if (val != null) onChanged(val);
//                   },
//                 ),
//                 Text(
//                   option,
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: isSelected
//                         ? FontWeight.w600
//                         : FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildRatingSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Rating:',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...ratingOptions.entries.map((entry) {
//           final isSelected = selectedRating == entry.value;
//           return InkWell(
//             onTap: () {
//               setState(() {
//                 selectedRating = entry.value;
//               });
//             },
//             child: Row(
//               children: [
//                 Radio<double>(
//                   value: entry.value,
//                   groupValue: selectedRating,
//                   activeColor: const Color(0xFF00897B),
//                   onChanged: (val) {
//                     if (val != null) {
//                       setState(() {
//                         selectedRating = val;
//                       });
//                     }
//                   },
//                 ),
//                 Text(
//                   entry.key,
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: isSelected
//                         ? FontWeight.w600
//                         : FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }
  
//   Widget _buildApplyButton() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: SizedBox(
//         width: double.infinity,
//         height: 56,
//         child: ElevatedButton(
//           onPressed: () {
//             final filters = {
//               "categories": selectedCategories,
//               "levels": selectedLevels,
//               "isFree": selectedIsFree,
//               "rating": selectedRating,
//             };
//             Navigator.pop(context, filters); // ✅ return filters to caller
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF2196F3),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//           ),
//           child: const Text(
//             'Apply',
//             style: TextStyle(
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:eduera_student/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterPage extends StatefulWidget {
  final List initialCategories;
  final List initialLevels;
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

class _FilterPageState extends State<FilterPage> with TickerProviderStateMixin {
  late List selectedCategories;
  late List selectedLevels;
  bool? selectedIsFree;
  double? selectedRating;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<String> levels = ['Beginners', 'Intermediate', 'Advanced'];

  final Map<String, double> ratingOptions = {
    '4.5 & above': 4.5,
    '4.0 & above': 4.0,
    '3.5 & above': 3.5,
    '3.0 & above': 3.0,
  };

  // Color palette
  static const Color _bg = Color(0xFF0F0F14);
  static const Color _surface = Color(0xFF1A1A24);
  static const Color _card = Color(0xFF22222E);
  static const Color _accent = Color(0xFF6C63FF);
  static const Color _accentSoft = Color(0x336C63FF);
  static const Color _teal = Color(0xFF00D4AA);
  static const Color _textPrimary = Color(0xFFF0F0F8);
  static const Color _textSecondary = Color(0xFF8888A8);
  static const Color _divider = Color(0xFF2E2E3E);

  int get _activeFilterCount =>
      selectedCategories.length +
      selectedLevels.length +
      (selectedIsFree != null ? 1 : 0) +
      (selectedRating != null ? 1 : 0);

  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.initialCategories);
    selectedLevels = List.from(widget.initialLevels);
    selectedIsFree = widget.initialIsFree;
    selectedRating = widget.initialRating;

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _slideController.forward();
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoriesSection(),
                    const SizedBox(height: 28),
                    _buildLevelsSection(),
                    const SizedBox(height: 28),
                    _buildPriceSection(),
                    const SizedBox(height: 28),
                    _buildRatingSection(),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 12,
        20,
        16,
      ),
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(bottom: BorderSide(color: _divider)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _divider),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: _textPrimary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Filter',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 8),
          if (_activeFilterCount > 0)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_activeFilterCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedCategories.clear();
                selectedLevels.clear();
                selectedIsFree = null;
                selectedRating = null;
              });
            },
            child: Text(
              'Reset all',
              style: TextStyle(
                color: _activeFilterCount > 0 ? _accent : _textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const Spacer(),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Categories'),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return Container(
                height: 56,
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _accent,
                    ),
                  ),
                ),
              );
            } else if (state is CategoryLoaded) {
              return _buildChipGroup(
                options: state.categories.map((c) => c.name).toList(),
                selected: selectedCategories,
                onToggle: (val) {
                  setState(() {
                    selectedCategories.contains(val)
                        ? selectedCategories.remove(val)
                        : selectedCategories.add(val);
                  });
                },
              );
            } else if (state is CategoryError) {
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF4A2020)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      state.message,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildChipGroup({
    required List<String> options,
    required List selected,
    required Function(String) onToggle,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return GestureDetector(
          onTap: () => onToggle(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected ? _accentSoft : _card,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? _accent : _divider,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? _accent : _textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                letterSpacing: 0.2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLevelsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Level'),
        ...levels.asMap().entries.map((entry) {
          final i = entry.key;
          final level = entry.value;
          final isSelected = selectedLevels.contains(level);
          final icons = [
            Icons.spa_outlined,
            Icons.trending_up_rounded,
            Icons.rocket_launch_outlined,
          ];
          return Padding(
            padding: EdgeInsets.only(bottom: i < levels.length - 1 ? 8 : 0),
            child: _buildToggleTile(
              label: level,
              icon: icons[i],
              isSelected: isSelected,
              isCheckbox: true,
              onTap: () => setState(() {
                isSelected
                    ? selectedLevels.remove(level)
                    : selectedLevels.add(level);
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Price'),
        Row(
          children: [
            Expanded(
              child: _buildSegmentButton(
                label: 'All',
                icon: Icons.all_inclusive_rounded,
                isSelected: selectedIsFree == null,
                onTap: () => setState(() => selectedIsFree = null),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSegmentButton(
                label: 'Free',
                icon: Icons.card_giftcard_rounded,
                isSelected: selectedIsFree == true,
                onTap: () => setState(() => selectedIsFree = true),
                accentColor: _teal,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSegmentButton(
                label: 'Paid',
                icon: Icons.credit_card_rounded,
                isSelected: selectedIsFree == false,
                onTap: () => setState(() => selectedIsFree = false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    Color accentColor = _accent,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha:0.15) : _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? accentColor : _divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? accentColor : _textSecondary,
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? accentColor : _textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Minimum Rating'),
        ...ratingOptions.entries.toList().asMap().entries.map((mapEntry) {
          final i = mapEntry.key;
          final entry = mapEntry.value;
          final isSelected = selectedRating == entry.value;
          final entries = ratingOptions.entries.toList();
          return Padding(
            padding: EdgeInsets.only(bottom: i < entries.length - 1 ? 8 : 0),
            child: _buildToggleTile(
              label: entry.key,
              isSelected: isSelected,
              isCheckbox: false,
              trailing: _buildStars(entry.value),
              onTap: () => setState(() => selectedRating = entry.value),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return const Icon(
            Icons.star_rounded,
            color: Color(0xFFFFB800),
            size: 14,
          );
        } else if (i < rating) {
          return const Icon(
            Icons.star_half_rounded,
            color: Color(0xFFFFB800),
            size: 14,
          );
        }
        return const Icon(
          Icons.star_border_rounded,
          color: Color(0xFF4A4A5A),
          size: 14,
        );
      }),
    );
  }

  Widget _buildToggleTile({
    required String label,
    required bool isSelected,
    required bool isCheckbox,
    required VoidCallback onTap,
    IconData? icon,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? _accentSoft : _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? _accent : _divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? _accent : _textSecondary,
                size: 18,
              ),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _textPrimary : _textSecondary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (trailing != null) ...[trailing, const SizedBox(width: 10)],
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? _accent : Colors.transparent,
                borderRadius: isCheckbox
                    ? BorderRadius.circular(6)
                    : BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? _accent : _textSecondary.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(
                      isCheckbox ? Icons.check_rounded : Icons.circle,
                      color: Colors.white,
                      size: isCheckbox ? 13 : 8,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: _surface,
        border: const Border(top: BorderSide(color: _divider)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.4),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_activeFilterCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: Text(
                '$_activeFilterCount filter${_activeFilterCount > 1 ? 's' : ''} active',
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                final filters = {
                  'categories': selectedCategories,
                  'levels': selectedLevels,
                  'isFree': selectedIsFree,
                  'rating': selectedRating,
                };
                Navigator.pop(context, filters);
              },
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Apply Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
