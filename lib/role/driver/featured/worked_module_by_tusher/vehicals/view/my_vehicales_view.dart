import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_network_image.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/controller/my_vehicales_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/my_vehicals_response.dart'
    show Vehicle;
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/view/add_vehicale_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/view/vehicale_details_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MyVehiclesView extends ConsumerStatefulWidget {
  const MyVehiclesView({super.key});

  @override
  ConsumerState<MyVehiclesView> createState() => _MyVehiclesViewState();
}

class _MyVehiclesViewState extends ConsumerState<MyVehiclesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myVehiclesControllerProvider.notifier).load();
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

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(title: "My Vehicles"),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.yellow.shade900,
        icon: const Icon(Icons.add, color: Colors.white),
        label: CustomText(
          title: "Add Vehicle",
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddVehicleView()),
          );
        },
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => Center(
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
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, index) {
                if (index == response.items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return VehicleCard(vehicle: vehicles[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VehicleDetailsView(vehicaleId: vehicle.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
              borderRadius: BorderRadius.circular(14),
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

                  _StatusChip(label: vehicle.rentStatus.replaceAll("-", " ")),
                ],
              ),
            ),

            /// Status
          ],
        ),
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

class _EmptyVehiclesView extends StatelessWidget {
  const _EmptyVehiclesView();

  @override
  Widget build(BuildContext context) {
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
            CustomButton(
              title: "Add Vehicle",
              onTap: () {
                // Navigate to add vehicle
              },
            ),
          ],
        ),
      ),
    );
  }
}
