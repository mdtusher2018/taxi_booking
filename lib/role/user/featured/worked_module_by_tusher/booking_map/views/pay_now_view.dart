// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:taxi_booking/app/core/utilitis/launch_url.dart';
// import 'package:taxi_booking/app/resource/common_widget/custom_app_bar.dart';
// import '../../../resource/common_widget/custom_button.dart';
// import '../../../resource/common_widget/custom_network_image.dart';
// import '../../../resource/utilitis/custom_toast.dart';
// import '../../chat/views/message_view.dart';
// import '../controllers/booking_map_controller.dart';
// import '../sheet/processed_to_pay_sheet.dart';

// class PayNowView extends GetView {
//   const PayNowView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<BookingMapController>();
//     // final driver = controller.selectedDriver.value;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(title: 'Pay Now', centerTitle: true),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Driver Info
//             Row(
//               children: [
//                 CustomNetworkImage(
//                   imageUrl: driver?.profileImage ?? '',
//                   height: 50,
//                   width: 50,
//                   fit: BoxFit.cover,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             driver?.name ?? '',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Spacer(),
//                           const Icon(Icons.star, color: Colors.amber, size: 16),
//                           const SizedBox(width: 4),
//                           Text(
//                             "(${driver?.rating})",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Text(
//                             driver?.car ?? '',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           const Spacer(),
//                           Text(
//                             driver?.distance ?? '',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Pickup
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Icons.circle, size: 14, color: Colors.orange),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Pickup point",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         controller.pickupLocationController.text,
//                         style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 24),

//             // Drop-off
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Icons.location_on, size: 16, color: Colors.grey),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Pick Off",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         controller.dropLocationController.text,
//                         style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Booking Amount Label
//             Row(
//               children: const [
//                 Expanded(child: Divider(thickness: 1)),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Text(
//                     "Booking Amount",
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                 ),
//                 Expanded(child: Divider(thickness: 1)),
//               ],
//             ),
//             const SizedBox(height: 8),

//             // Price
//             Text(
//               "${driver?.price ?? '0.0'}",
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.orange,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Pay Now Button
//             SizedBox(
//               width: double.infinity,
//               child: CustomButton(
//                 onTap: () {
//                   Get.back();
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     backgroundColor: Colors.transparent,
//                     builder: (_) => const ProcessedToPaySheet(),
//                   );
//                 },
//                 title: 'Pay Now',
//                 widget: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Text(
//                       "Pay Now",
//                       style: TextStyle(fontSize: 16, color: Colors.black),
//                     ),
//                     SizedBox(width: 8),
//                     Icon(Icons.arrow_forward, color: Colors.black),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Action Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildActionButton(
//                   Icons.close,
//                   Colors.grey[200]!,
//                   Colors.grey[600]!,
//                   onTap: () {},
//                 ),

//                 _buildActionButton(
//                   Icons.chat_bubble_outline,
//                   const Color(0xffFFC107),
//                   Colors.white,
//                   onTap: () {
//                     // Handle chat action
//                     // Get.snackbar('Chat', 'Opening chat with ${driver.name}');
//                     Get.to(
//                       () => MessageView(
//                         userImage: driver?.profileImage ?? '',
//                         userName: driver?.name ?? '',
//                         targetUserId: '12345678',
//                       ),
//                     );
//                   },
//                 ),
//                 _buildActionButton(
//                   Icons.phone,
//                   const Color(0xffFFC107),
//                   Colors.white,
//                   onTap: () {
//                     // Handle phone call action
//                     CustomToast.showToast(
//                       message: 'Calling ${driver?.name}',
//                       isError: false,
//                     );
//                     // Add your phone call logic here
//                     LaunchUrlService().makePhoneCall(
//                       phoneNumber: '+8801889564894',
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget _buildActionButton(
//     IconData icon,
//     Color bgColor,
//     Color iconColor, {
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 50,
//         height: 50,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Icon(icon, color: iconColor),
//       ),
//     );
//   }
// }
