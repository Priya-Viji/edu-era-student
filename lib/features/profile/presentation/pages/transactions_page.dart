import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/payment/presentation/pages/e_receipt_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatefulWidget {
  final String studentId;

  const TransactionsPage({super.key, required this.studentId});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  Future<List<Map<String, dynamic>>> fetchEnrollmentsWithCourseDetails() async {
    final enrollmentSnapshot = await FirebaseFirestore.instance
        .collection('enrollments')
        .where('studentId', isEqualTo: widget.studentId)
        .get();

    List<Map<String, dynamic>> enrichedData = [];

    for (var enrollmentDoc in enrollmentSnapshot.docs) {
      final enrollment = enrollmentDoc.data();
      final courseId = enrollment['courseId'];

      final courseSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();

      final courseData = courseSnapshot.data();

      if (courseData != null) {
        enrichedData.add({
          'courseTitle': courseData['title'],
          'category': courseData['category'],
          'thumbnailUrl': courseData['thumbnailUrl'],
          'price': enrollment['price'],
          'enrolledAt': enrollment['enrolledAt'],
        });
      }
    }

    return enrichedData;
  }

  String formatDate(Timestamp? ts) {
    if (ts == null) return '';
    final date = ts.toDate();
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search courses...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              )
            : Text(
                'Transactions',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                  searchQuery = "";
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchEnrollmentsWithCourseDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions found'));
          }

          final transactions = snapshot.data!;

          // Apply search filter
          final filteredTransactions = transactions.where((data) {
            final title = (data['courseTitle'] ?? '').toLowerCase();
            final category = (data['category'] ?? '').toLowerCase();
            return title.contains(searchQuery) ||
                category.contains(searchQuery);
          }).toList();

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: filteredTransactions.length,
            itemBuilder: (context, index) {
              final data = filteredTransactions[index];
              return GestureDetector(
                onTap: () async {
                  final studentInfo = await fetchStudentInfo(widget.studentId);
                  final paymentId = data['paymentId'] ?? 'UNKNOWN';
                  final barcodeNumber1 = paymentId.length >= 6
                      ? paymentId.substring(0, 6)
                      : paymentId;
                  final barcodeNumber2 = paymentId.length > 6
                      ? paymentId.substring(6)
                      : '';

                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EReceiptPage(
                        name: studentInfo?['name'] ?? 'Student',
                        email: studentInfo?['email'] ?? 'student@example.com',
                        course: data['courseTitle'] ?? 'Unknown Course',
                        category: data['category'] ?? 'Unknown Category',
                        transactionId: paymentId,
                        price: (data['price'] as num).toDouble(),
                        date: (data['enrolledAt'] as Timestamp).toDate(),
                        barcodeNumber1: barcodeNumber1,
                        barcodeNumber2: barcodeNumber2,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Row(
                      children: [
                        // Thumbnail
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: data['thumbnailUrl'] != null
                                ? Image.network(
                                    data['thumbnailUrl'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.school,
                                        size: 35,
                                        color: Colors.grey[400],
                                      );
                                    },
                                  )
                                : Icon(
                                    Icons.school,
                                    size: 35,
                                    color: Colors.grey[400],
                                  ),
                          ),
                        ),
                        SizedBox(width: 14),

                        // Course details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['courseTitle'] ?? 'Unknown Course',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                data['category'] ?? 'Category',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                formatDate(data['enrolledAt']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF00A67E),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Paid',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '₹${data['price']}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
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
              );
            },
          );
        },
      ),
    );
  }
}

Future<Map<String, dynamic>?> fetchStudentInfo(String studentId) async {
  final studentSnapshot = await FirebaseFirestore.instance
      .collection('students') // or 'users' depending on your schema
      .doc(studentId)
      .get();

  if (studentSnapshot.exists) {
    return studentSnapshot.data();
  }
  return null;
}
