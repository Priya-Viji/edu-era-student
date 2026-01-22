// import 'package:eduera_student/core/constants/colors.dart';
// import 'package:eduera_student/core/constants/text_styles.dart';
// import 'package:flutter/material.dart';

// class Header extends StatelessWidget {
//   final String userName;
//   final VoidCallback onNotificationTap;

//   const Header({
//     super.key,
//     required this.userName,
//     required this.onNotificationTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Hi, ${userName.toUpperCase()}", style: AppTextStyles.headingLarge),
//               const SizedBox(height: 4),
//               Text("What would you like to learn Today?", style: AppTextStyles.bodyRegular),
//               Text("Search Below.", style: AppTextStyles.bodyRegular),
//             ],
//           ),
//         ),
//         GestureDetector(
//           onTap: onNotificationTap,
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: AppColors.primary,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.notifications, color: AppColors.textLight),
//           ),
//         ),
//       ],
//     );
//   }
// }