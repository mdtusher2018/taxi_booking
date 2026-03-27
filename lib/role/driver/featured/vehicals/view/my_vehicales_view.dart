import 'package:flutter/material.dart';
import 'package:taxi_booking/core/utilitis/enum/payment_status_enums.dart';
import 'package:taxi_booking/resource/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_network_image.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/common/featured/setting/controller/profile_controller.dart';
import 'package:taxi_booking/role/common/featured/setting/model/profile_response.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/role/driver/featured/vehicals/controller/my_vehicales_controller.dart';
import 'package:taxi_booking/role/driver/featured/vehicals/model/my_vehicals_response.dart'
    show Vehicle;
import 'package:taxi_booking/role/driver/featured/vehicals/view/add_vehicale_view.dart';
import 'package:taxi_booking/role/driver/featured/vehicals/view/stripe_connect_webview.dart';
import 'package:taxi_booking/role/driver/featured/vehicals/view/vehicale_details_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyVehiclesView extends ConsumerStatefulWidget {
  final bool isForAssign;
  final String? driverId;
  const MyVehiclesView({super.key, required this.isForAssign, this.driverId});

  @override
  ConsumerState<MyVehiclesView> createState() => _MyVehiclesViewState();
}

class _MyVehiclesViewState extends ConsumerState<MyVehiclesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myVehiclesControllerProvider.notifier).load();
      ref.read(profileControllerProvider.notifier).getProfile();
    });

    final controller = ref.read(myVehiclesControllerProvider.notifier);
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myVehiclesControllerProvider);
    final profileState = ref.watch(profileControllerProvider);
    final stripeConnectState = ref.watch(
      stripeConnectWebviewControllerProvider,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(title: "My Vehicles"),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.yellow.shade900,
        icon: const Icon(Icons.add, color: Colors.white),
        label: ValueListenableBuilder(
          valueListenable: stripeConnectState.isLoading,
          builder: (context, value, child) {
            if (value) return Center(child: CircularProgressIndicator());
            return CustomText(
              title: "Add Vehicle",
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            );
          },
        ),
        onPressed: () {
          _addVehicle(profileState, ref);
        },
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: CustomText(
            title: e.toString(),
            style: CommonStyle.textStyleMedium(color: Colors.white),
          ),
        ),
        data: (response) {
          final vehicles = response.items;

          if (vehicles.isEmpty) {
            return const _EmptyVehiclesView();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(myVehiclesControllerProvider.notifier).refresh();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),

              itemCount:
                  response.items.length + (response.isLoadingMore ? 1 : 0),
              controller: scrollController,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (_, index) {
                if (index == response.items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return VehicleCard(
                  vehicle: vehicles[index],
                  isForAssign: widget.isForAssign,
                  driverId: widget.driverId ?? "",
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class VehicleCard extends ConsumerWidget {
  final Vehicle vehicle;
  final bool isForAssign;
  final String driverId;
  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.isForAssign,
    required this.driverId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(isForAssign ? 8 : 1),
      decoration: BoxDecoration(
        color: AppColors.black100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VehicleDetailsView(
                    vehicaleId: vehicle.id,
                    isMyVehicale: true,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  /// Vehicle Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomNetworkImage(
                      imageUrl: vehicle.photos.front,
                      height: 80,
                      width: 80,
                    ),
                  ),
                  const SizedBox(width: 14),

                  /// Vehicle Info
                  Expanded(
                    child: Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: "${vehicle.vehicleMake} ${vehicle.model}",
                          style: CommonStyle.textStyleMedium(
                            size: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(),
                        CustomText(
                          title: "${vehicle.year} • ${vehicle.color}",
                          style: CommonStyle.textStyleSmall(color: Colors.grey),
                        ),

                        CustomText(
                          title: "Reg No: ${vehicle.registrationNumber}",
                          style: CommonStyle.textStyleSmall(
                            color: Colors.grey.shade700,
                          ),
                        ),

                        _StatusChip(
                          label: vehicle.rentStatus.replaceAll("-", " "),
                        ),
                      ],
                    ),
                  ),

                  /// Status
                ],
              ),
            ),
          ),

          if (isForAssign && vehicle.isAvailable) ...[
            SizedBox(height: 8),
            CustomButton(
              title: "Assign this car",
              onTap: () {
                ref
                    .read(myVehiclesControllerProvider.notifier)
                    .assignDriver(vehicalId: vehicle.id, driverId: driverId);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          title: "Status: ",
          style: CommonStyle.textStyleSmall(
            size: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomText(
          title: _formatLabel(label),
          style: CommonStyle.textStyleSmall(color: Colors.grey.shade700),
        ),
      ],
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

class _EmptyVehiclesView extends ConsumerWidget {
  const _EmptyVehiclesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final stripeConnectState = ref.watch(
      stripeConnectWebviewControllerProvider,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_filled,
              size: 72,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            CustomText(
              title: "No Vehicles Found",
              style: CommonStyle.textStyleMedium(
                size: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            CustomText(
              title: "Add your vehicle to start receiving trips",
              style: CommonStyle.textStyleSmall(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: stripeConnectState.isLoading,
              builder: (context, value, child) {
                return CustomButton(
                  title: "Add Vehicle",
                  isLoading: value,
                  onTap: () {
                    _addVehicle(profileState, ref);
                  },
                );
              },
            ),
            profileState.when(
              data: (data) {
                if (data?.data.stripeAccountId == null) {
                  return Column(
                    children: [
                      const SizedBox(height: 6),
                      CustomText(
                        title:
                            "Note: To add your own vehicale you have to connect your Stripe Account frist",
                        style: CommonStyle.textStyleSmall(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
              error: (error, stackTrace) => SizedBox(),
              loading: () => SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

void _addVehicle(AsyncValue<ProfileResponse?> profileState, WidgetRef ref) {
  profileState.when(
    data: (data) async {
      if (data?.data.stripeAccountId != null) {
        Navigator.push(
          ref.context,
          MaterialPageRoute(builder: (_) => AddVehicleView()),
        );
        return;
      }

      // ✅ Has stripe account — launch webview
      final value = await ref
          .read(stripeConnectWebviewControllerProvider)
          .connectStripe();

      if (value == null) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text("Failed to launch Stripe WebView")),
        );
        return;
      }

      // ✅ Push webview and wait for result
      final result = await Navigator.push<StripeResult>(
        ref.context,
        MaterialPageRoute(
          builder: (_) => StripeConnectWebViewPage(checkoutUrl: value),
        ),
      );

      if (result == StripeResult.success) {
        Navigator.push(
          ref.context,
          MaterialPageRoute(builder: (_) => AddVehicleView()),
        );
      } else {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text("Payment failed or was cancelled")),
        );
      }
    },
    loading: () {
      ScaffoldMessenger.of(
        ref.context,
      ).showSnackBar(const SnackBar(content: Text("Profile is loading...")));
    },
    error: (_, _) {
      ScaffoldMessenger.of(
        ref.context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load profile")));
    },
  );
}
