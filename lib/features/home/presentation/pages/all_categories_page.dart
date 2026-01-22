import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          'All Categories',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        //centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No categories found'));
                  }

                  final allCategories = snapshot.data!.docs;

                  // Local filter (search by label)

                  final filteredCategories = allCategories.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final label = (data['label'] ?? '')
                        .toString()
                        .toLowerCase();
                    return label.contains(searchQuery);
                  }).toList();

                  if (filteredCategories.isEmpty) {
                    return const Center(child: Text('No matching categories'));
                  }

                  return GridView.builder(
                    itemCount: filteredCategories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemBuilder: (context, index) {
                      final data =
                          filteredCategories[index].data()
                              as Map<String, dynamic>;
                      final label = data['label'] ?? 'Unknown';
                      final iconName = data['icon'] ?? 'category';
                      final icon = _getIconFromName(iconName);
                      return _buildCategoryCard(label, icon);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for...',
                hintStyle: TextStyle(color: AppColors.primary, fontSize: 14),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.green[900]),
            ),
          ),
        ),
        // const SizedBox(width: 12),
        // ElevatedButton(
        //   onPressed: () {},
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: const Color(0xFF209326),
        //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //   ),
        //   child: const Text('Search'),
        // ),
      ],
    );
  }

  Widget _buildCategoryCard(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Return selected category to HomePage
        Navigator.pop(context, label);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(33, 150, 83, 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFF209326)),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                //color: Color(0xFF209326),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconFromName(String name) {
    switch (name) {
      case 'view_in_ar':
        return Icons.view_in_ar;
      case 'design_services':
        return Icons.design_services;
      case 'code':
        return Icons.code;
      case 'trending_up':
        return Icons.trending_up;
      case 'account_balance':
        return Icons.account_balance;
      case 'person':
        return Icons.person;
      case 'settings':
        return Icons.settings;
      case 'group':
        return Icons.group;
      default:
        return Icons.category;
    }
  }
}
