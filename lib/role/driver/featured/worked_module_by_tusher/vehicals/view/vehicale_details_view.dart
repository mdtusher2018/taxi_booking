import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_network_image.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/controller/delete_vehicale_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/controller/vehicale_details_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/vehicale_details_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/view/edit_vehicale_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';

enum _MenuAction { edit, delete }

class VehicleDetailsView extends ConsumerStatefulWidget {
  final String vehicaleId;
  const VehicleDetailsView({super.key, required this.vehicaleId});

  @override
  ConsumerState<VehicleDetailsView> createState() => _VehicleDetailsViewState();
}

class _VehicleDetailsViewState extends ConsumerState<VehicleDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(vehicaleDetailsControllerProvider.notifier)
          .vehicaleDetails(vehicaleId: widget.vehicaleId);
    });
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
            ),
            title: CustomText(
              title: "Delete Vehicle",
              fontSize: 16,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            content: CustomText(
              title: "Are you sure you want to delete this vehicle?",
              fontSize: 14,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: CustomText(title: "Cancel", fontSize: 14),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .watch(deleteVehicaleControllerProvider.notifier)
                      .deleteVehicale(vehicaleId: widget.vehicaleId);
                },
                child: CustomText(
                  title: "Delete",
                  fontSize: 14,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicleResponse = ref.watch(vehicaleDetailsControllerProvider);

    return vehicleResponse.when(
      data: (vehicleResponse) {
        if (vehicleResponse == null) {
          return Scaffold(
            appBar: CustomAppBar(title: "Vehicle Details"),
            body: Center(
              child: CustomText(
                title: "No vehicle details available",
                style: CommonStyle.textStyleMedium(),
              ),
            ),
          );
        } else {
          final vehicle = vehicleResponse.data;
          final owner = vehicle.vehicleOwner;

          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: CustomAppBar(
              title: "Vehicle Details",
              actions: [
                PopupMenuButton<_MenuAction>(
                  icon: const Icon(Icons.more_vert, size: 28),
                  onSelected: (value) {
                    switch (value) {
                      case _MenuAction.edit:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditVehicleView(vehicle: vehicle),
                          ),
                        );
                        break;

                      case _MenuAction.delete:
                        _showDeleteConfirmDialog(context);
                        break;
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: _MenuAction.edit,
                          child: Row(
                            children: const [
                              Icon(RemixIcons.edit_2_fill, size: 20),
                              SizedBox(width: 10),
                              Text("Edit"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: _MenuAction.delete,
                          child: Row(
                            children: const [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Delete"),
                            ],
                          ),
                        ),
                      ],
                ),
                SizedBox(width: 12),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  /// Photos Carousel
                  _VehiclePhotos(photos: vehicle.photos),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        /// Vehicle Header
                        _VehicleHeader(vehicle: vehicle),

                        const SizedBox(height: 16),

                        /// Vehicle Specs
                        _InfoSection(
                          title: "Vehicle Information",
                          children: [
                            _InfoRow("Make", vehicle.vehicleMake),
                            _InfoRow("Model", vehicle.model),
                            _InfoRow("Year", vehicle.year.toString()),
                            _InfoRow("Color", vehicle.color),
                            _InfoRow("Seats", vehicle.numberOfSeats.toString()),
                            _InfoRow(
                              "Registration",
                              vehicle.registrationNumber,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// Documents
                        _InfoSection(
                          title: "Verification",
                          children: [
                            Row(
                              children: [
                                Icon(Icons.verified, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomText(
                                    title:
                                        "This vehicle has been verified by our compliance team. All required documents are valid and up to date.",
                                    style: CommonStyle.textStyleSmall(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        /// Owner Info (Conditional)
                        ...[
                          const SizedBox(height: 16),
                          _OwnerSection(owner: owner),
                        ],

                        const SizedBox(height: 24),

                        CustomButton(
                          title: "Manage Vehicle",
                          onTap: () {
                            // Navigate to edit / manage page
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      error: (error, stackTrace) {
        return Scaffold(
          appBar: CustomAppBar(title: "Vehicle Details"),
          body: Center(
            child: CustomText(
              title: "Error: ${error.toString()}",
              style: CommonStyle.textStyleMedium(color: Colors.red),
            ),
          ),
        );
      },
      loading: () {
        return Scaffold(
          appBar: CustomAppBar(title: "Vehicle Details"),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _VehiclePhotos extends StatefulWidget {
  final VehiclePhotos photos;

  const _VehiclePhotos({required this.photos});

  @override
  State<_VehiclePhotos> createState() => _VehiclePhotosState();
}

class _VehiclePhotosState extends State<_VehiclePhotos> {
  late final PageController _controller;
  int _currentIndex = 0;

  List<String> get _images =>
      [
        widget.photos.front,
        widget.photos.rear,
        widget.photos.interior,
      ].where((e) => e.isNotEmpty).toList();

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _controller,
            itemCount: _images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, index) {
              return CustomNetworkImage(
                imageUrl: _images[index],
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
        ),

        /// Left Arrow
        if (_currentIndex > 0)
          _ArrowButton(
            alignment: Alignment.centerLeft,
            icon: Icons.chevron_left,
            onTap: () => _goTo(_currentIndex - 1),
          ),

        /// Right Arrow
        if (_currentIndex < _images.length - 1)
          _ArrowButton(
            alignment: Alignment.centerRight,
            icon: Icons.chevron_right,
            onTap: () => _goTo(_currentIndex + 1),
          ),

        /// Indicator Dots
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: _currentIndex == index ? 16 : 6,
                decoration: BoxDecoration(
                  color:
                      _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final Alignment alignment;
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.alignment,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          color: Colors.black.withOpacity(0.35),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleHeader extends StatelessWidget {
  final VehicleData vehicle;

  const _VehicleHeader({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: "${vehicle.vehicleMake} ${vehicle.model}",
            style: CommonStyle.textStyleMedium(
              size: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          CustomText(
            title: "${vehicle.year} • ${vehicle.color}",
            style: CommonStyle.textStyleSmall(color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _StatusChip(
                label: vehicle.isActive ? "Active" : "Inactive",
                color: vehicle.isActive ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              _StatusChip(label: vehicle.rentStatus, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: title,
            style: CommonStyle.textStyleMedium(
              size: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            title: label,
            style: CommonStyle.textStyleSmall(color: Colors.grey),
          ),
          CustomText(
            title: value,
            style: CommonStyle.textStyleSmall(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _OwnerSection extends StatelessWidget {
  final VehicleOwner owner;

  const _OwnerSection({required this.owner});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoSection(
          title: "Owner Information",
          children: [
            _InfoRow("Name", owner.fullName),
            _InfoRow("Phone", owner.phone),
            _InfoRow("Status", _formatStatus(owner.status)),
          ],
        ),

        ...[
          const SizedBox(height: 16),
          _InfoSection(
            title: "Business & License",
            children: [
              _InfoRow(
                "Business Type",
                owner.businessLicenseDetails.businessType
                    .replaceAll('_', ' ')
                    .toUpperCase(),
              ),
              _InfoRow(
                "License Number",
                owner.businessLicenseDetails.licenseNumber,
              ),
              _InfoRow(
                "Issued By",
                owner.businessLicenseDetails.issuingMunicipality,
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _formatStatus(String status) {
    return status.replaceAll('_', ' ');
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Status Dot / Icon
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          const SizedBox(width: 6),

          /// Label
          CustomText(
            title: _formatLabel(label),
            style: CommonStyle.textStyleSmall(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLabel(String value) {
    return value
        .replaceAll('-', ' ')
        .split(' ')
        .map((e) => e.isEmpty ? e : e[0].toUpperCase() + e.substring(1))
        .join(' ');
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
