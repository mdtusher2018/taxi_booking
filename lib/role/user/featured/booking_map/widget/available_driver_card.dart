// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taxi_booking/app/resource/utilitis/custom_toast.dart';

// import '../../../resource/common_widget/custom_button.dart';
// import '../../../resource/common_widget/custom_network_image.dart';
// import '../controllers/booking_map_controller.dart';
// import '../model/driver_info_model.dart';

// class AvailableDriverCard extends StatelessWidget {
//   final String name;
//   final double rating;
//   final String car;
//   final String distance;
//   final String price;
//   final String profileImage;
//   const AvailableDriverCard({
//     super.key,
//     required this.name,
//     required this.rating,
//     required this.car,
//     required this.distance,
//     required this.price,
//     required this.profileImage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<BookingMapController>();
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               // Profile Image
//               CustomNetworkImage(
//                 imageUrl: profileImage, // Fixed: use profileImage
//                 height: 50,
//                 width: 50,
//                 fit: BoxFit.cover,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               const SizedBox(width: 12),
//               // Driver Info
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           name,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const Spacer(),
//                         const Icon(Icons.star, color: Colors.amber, size: 16),
//                         Text(
//                           '($rating)',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Text(
//                           car,
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           distance,
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const Divider(height: 20),
//           // Buttons
//           Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: CustomButton(
//                   title: 'history',
//                   widget: const Icon(Icons.history),
//                   buttonColor: const Color(0xffF2F4F7),
//                   onTap: () {},
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 flex: 9,
//                 child: CustomButton(
//                   title: 'Book Now ($price)',
//                   onTap: () {
//                     CustomToast.showToast(message: 'Booked Successfully');
//                     controller.bookDriver(
//                       DriverInfo(
//                         name: name,
//                         rating: rating,
//                         car: car,
//                         distance: distance,
//                         price: price,
//                         profileImage: profileImage,
//                       ),
//                     );
//                     Get.back(); 
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }