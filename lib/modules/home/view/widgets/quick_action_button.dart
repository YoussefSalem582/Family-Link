// import 'package:flutter/material.dart';

// class QuickActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback onTap;

//   const QuickActionButton({
//     Key? key,
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: 70,
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 28),
//             ),
//             SizedBox(height: 8),
//             Text(
//               label,
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
