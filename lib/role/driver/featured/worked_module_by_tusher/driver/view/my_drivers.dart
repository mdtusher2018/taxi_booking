import 'package:taxi_booking/resource//app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/controllers/driver_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/models/my_drivers_response.dart';

class MyDriversView extends ConsumerStatefulWidget {
  const MyDriversView({super.key});

  @override
  ConsumerState<MyDriversView> createState() => _MyDriversViewState();
}

class _MyDriversViewState extends ConsumerState<MyDriversView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myDriversControllerProvider.notifier).load();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 200) {
        ref.read(myDriversControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myDriversControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Drivers",
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade100,
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: CustomText(
            title: e.toString(),
            style: CommonStyle.textStyleMedium(color: Colors.white),
          ),
        ),
        data: (response) {
          final drivers = response.items;
          if (drivers.isEmpty) return const _EmptyDriversView();

          return RefreshIndicator(
            onRefresh: () async =>
                ref.read(myDriversControllerProvider.notifier).refresh(),
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: drivers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final driver = drivers[index];
                return DriverCard(driver: driver);
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyDriversView extends StatelessWidget {
  const _EmptyDriversView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_4_rounded, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            CustomText(
              title: "No Drivers Found",
              style: CommonStyle.textStyleMedium(
                size: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            CustomText(
              title: "Add your drivers to get started",
              style: CommonStyle.textStyleSmall(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class DriverCard extends ConsumerWidget {
  final AssignedDriver driver;

  const DriverCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = driver.vehicleId;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderSection(driver: driver),
          const SizedBox(height: 12),
          _VehicleImageSection(vehicle: vehicle),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _ContactSection(user: driver),
          const SizedBox(height: 12),
          _ComplianceSection(vehicle: vehicle),
          const SizedBox(height: 12),
          _FooterSection(driver: driver),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: SizedBox(
              height: 40,

              child: FittedBox(
                child: CustomButton(
                  title: "Remove Driver",
                  onTap: () {
                    ref
                        .read(myDriversControllerProvider.notifier)
                        .removeDrver(
                          driverId: driver.driverId.id,
                          vehicaleId: driver.vehicleId.id,
                        );
                  },
                  width: 200,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final AssignedDriver driver;

  const _HeaderSection({required this.driver});

  @override
  Widget build(BuildContext context) {
    final user = driver.driverId.user;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DriverAvatar(isOnline: driver.isActive),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: user.email,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              // CustomText(
              //   title:
              //       "${driver.driverId.role} • Assigned by ${driver.assignedBy.user.email}",
              //   fontSize: 12,
              //   color: Colors.grey.shade600,
              // ),
              // const SizedBox(height: 6),
              Row(
                children: [
                  VerificationChip(isVerified: driver.isActive),
                  const SizedBox(width: 10),
                  AccountStatusChip(status: user.status),
                ],
              ),
            ],
          ),
        ),
        AvailabilityChip(status: driver.isActive ? "Available" : "Busy"),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  final AssignedDriver user;

  const _ContactSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(icon: Icons.phone, value: user.driverId.user.phone),
        _InfoRow(icon: Icons.email, value: user.driverId.user.email),
      ],
    );
  }
}

class _ComplianceSection extends StatelessWidget {
  final Vehicle vehicle;

  const _ComplianceSection({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(
          icon: Icons.directions_car,
          value: vehicle.id.isNotEmpty
              ? "Vehicle Assigned"
              : "No Vehicle Assigned",
        ),
      ],
    );
  }
}

class _FooterSection extends StatelessWidget {
  final AssignedDriver driver;

  const _FooterSection({required this.driver});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title:
              "Joined: ${driver.createdAt.toLocal().toString().split(' ').first}",
          fontSize: 11,
          color: Colors.grey,
        ),
        CustomText(
          title:
              "Assigned: ${driver.assignedAt.toLocal().toString().split(' ').first}",
          fontSize: 11,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _InfoRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: CustomText(title: value, fontSize: 12)),
        ],
      ),
    );
  }
}

class DriverAvatar extends StatelessWidget {
  final bool isOnline;

  const DriverAvatar({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.grey.shade300,
          child: const Icon(Icons.person, size: 30, color: Colors.white),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class AvailabilityChip extends StatelessWidget {
  final String status;

  const AvailabilityChip({super.key, required this.status});

  Color _color() {
    switch (status.toLowerCase()) {
      case "available":
        return AppColors.secondaryColor;
      case "busy":
        return AppColors.mainColor;
      default:
        return AppColors.black100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _color().withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomText(
        title: status.toUpperCase(),
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.blackColor,
      ),
    );
  }
}

class VerificationChip extends StatelessWidget {
  final bool isVerified;

  const VerificationChip({super.key, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(isVerified ? Icons.verified : Icons.error_outline, size: 14),
        const SizedBox(width: 4),
        CustomText(
          title: isVerified ? "Verified" : "Not Verified",
          fontSize: 11,
          color: AppColors.blackColor,
        ),
      ],
    );
  }
}

class AccountStatusChip extends StatelessWidget {
  final String status;

  const AccountStatusChip({super.key, required this.status});

  Color _bgColor() {
    switch (status.toUpperCase()) {
      case 'ACTIVE_WITH_CAR':
        return AppColors.greenLightHover;
      case 'APPROVED':
        return AppColors.blueDark.withOpacity(0.12);
      case 'PENDING_REVIEW':
        return AppColors.mainColor.withOpacity(0.18);
      case 'SUSPENDED':
        return Colors.red.withOpacity(0.12);
      default:
        return AppColors.darkHover.withOpacity(0.12);
    }
  }

  String _label() => status.replaceAll('_', ' ');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor().withOpacity(0.3),
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        title: _label(),
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.blackColor,
      ),
    );
  }
}

class _VehicleImageSection extends StatelessWidget {
  final Vehicle vehicle;

  const _VehicleImageSection({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final imageUrl = vehicle.photos.front;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Icon(
            Icons.directions_car,
            size: 48,
            color: Colors.grey.shade500,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        imageUrl,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: 160,
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (_, __, ___) {
          return Container(
            height: 160,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 40),
          );
        },
      ),
    );
  }
}
