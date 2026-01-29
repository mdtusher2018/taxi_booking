import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/controllers/driver_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/controller/wallet_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/views/wallet_without_car_driver_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/widgets/resueable_widgets.dart';

class WalletWithCarDriverView extends ConsumerStatefulWidget {
  const WalletWithCarDriverView({super.key, required this.name});
  final String name;

  @override
  ConsumerState<WalletWithCarDriverView> createState() => _WalletViewState();
}

class _WalletViewState extends ConsumerState<WalletWithCarDriverView>
    with WalletReuseableWidgets {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(walletControllerProvider.notifier).fetchWalletData();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(myDriversControllerProvider.notifier).load();
      });

      scrollController.addListener(() {
        if (scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 200) {
          ref.read(myDriversControllerProvider.notifier).loadMore();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final mydrivers = ref.watch(myDriversControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        surfaceTintColor: Colors.transparent,
        title: const CustomText(
          title: "Wallet",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        controller: scrollController,
        child: Column(
          children: [
            _driverCard(walletState, name: widget.name),
            const SizedBox(height: 16),

            _statsRow(walletState),
            const SizedBox(height: 16),
            _trendCard(walletState),
            const SizedBox(height: 16),
            mydrivers.when(
              data: (data) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data.items.length,
                  itemBuilder: (context, index) {
                    final myDriver = data.items[index].driverId.user;
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return WalletWithoutCarDriverView(
                                id: myDriver.id,
                                name: myDriver.name,
                              );
                            },
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: NetworkImage(myDriver.image ?? ""),
                        onBackgroundImageError: (exception, stackTrace) =>
                            const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            ),
                      ),
                      title: Text(myDriver.email),
                      subtitle: Text(myDriver.phone),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16,
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) =>
                  CustomText(title: "Could not fetch drivers data"),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- DRIVER CARD ----------------
  Widget _driverCard(WalletState state, {required String name}) {
    if (state.loadingSummary) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.summaryError != null) {
      return CustomText(title: state.summaryError!);
    }

    final summary = state.summary;

    return driverCard(
      name: name,
      totalEarn: summary?.data.totalRevenue.toInt() ?? 0,
    );
  }

  // ---------------- STATS ROW ----------------
  Widget _statsRow(WalletState state) {
    final summary = state.summary?.data;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: smallStatCard(
                icon: Icons.attach_money_outlined,
                title: "Monthly Revenue",
                value: "\$${summary?.monthlyRevenue ?? 0}",
                sub:
                    "+ ${((summary?.monthlyGrowth ?? 0) / (((summary?.monthlyRevenue ?? 1) <= 0) ? 1 : summary?.monthlyRevenue ?? 1) * 100).toStringAsFixed(2)}%",
                subColor: Color(0xFF00BC59),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: smallStatCard(
                icon: Icons.group_outlined,
                title: "Active Drivers",

                value: "${summary?.activeDrivers ?? 0}",
                sub: "+${summary?.newDrivers ?? 0} new",
                subColor: Color(0xFF006DFF),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: smallStatCard(
                icon: Icons.local_taxi,
                title: "Fleet Utilization",
                value: "${summary?.fleetUtilization ?? 0}",
                sub: "⭐ ${0} avg rating",
                subColor: Color(0xFF7A00FF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: smallStatCard(
                icon: Icons.arrow_outward_sharp,
                title: "Total Trips",
                value: "\$${summary?.totalTrips ?? 0}",
                sub: "+${summary?.newTrips ?? 0}%",
                subColor: Color(0xFF29D943),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------- TREND ----------------
  Widget _trendCard(WalletState state) {
    if (state.loadingChart) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.chartError != null) {
      return CustomText(title: state.chartError!);
    }
    return graphChart(state.chart?.data ?? []);
  }
}
