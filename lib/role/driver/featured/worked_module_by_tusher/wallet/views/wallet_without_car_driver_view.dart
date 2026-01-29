import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/controller/wallet_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/wallet_by_driver_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/widgets/resueable_widgets.dart';

class WalletWithoutCarDriverView extends ConsumerStatefulWidget {
  const WalletWithoutCarDriverView({
    super.key,
    required this.id,
    required this.name,
  });
  final String id;
  final String name;
  @override
  ConsumerState<WalletWithoutCarDriverView> createState() => _WalletViewState();
}

class _WalletViewState extends ConsumerState<WalletWithoutCarDriverView>
    with WalletReuseableWidgets {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(walletControllerProvider.notifier)
          .driverWalletByIdData(driverId: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);

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
        child: Column(
          children: [
            _driverCard(walletState, name: widget.name),
            const SizedBox(height: 16),
            _thisMonthCard(walletState),
            const SizedBox(height: 16),
            _statsRow(walletState),
            const SizedBox(height: 16),
            _trendCard(walletState),
            const SizedBox(height: 16),
            _recentTrips(walletState),
          ],
        ),
      ),
    );
  }

  // ---------------- DRIVER CARD ----------------
  Widget _driverCard(WalletState state, {required String name}) {
    if (state.loadingByDriverId) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.driverWalletByIdError != null) {
      return CustomText(title: state.driverWalletByIdError!);
    }

    final driverWalletByIdData = state.driverWalletByIdData;

    return driverCard(
      name: name,
      totalEarn: driverWalletByIdData?.data.driverTotalEarning ?? 0,
    );
  }

  // ---------------- THIS MONTH CARD ----------------
  Widget _thisMonthCard(WalletState state) {
    if (state.loadingByDriverId) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.driverWalletByIdError != null) {
      return CustomText(title: state.driverWalletByIdError!);
    }

    final driverWalletByIdData = state.driverWalletByIdData;

    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(title: "This Month"),
          CustomText(title: DateFormat.MMMM().format(DateTime.now())),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AmountTile(
                title: "Gross",
                value:
                    "\$${(driverWalletByIdData?.data.isMonthEarningSummary.gross ?? 0).toStringAsFixed(2)}",
              ),
              _AmountTile(
                title: "Commission",
                value:
                    "-\$${(driverWalletByIdData?.data.isMonthEarningSummary.commission ?? 0).toStringAsFixed(2)}",
                color: Colors.red,
              ),
              _AmountTile(
                title: "Net",
                value:
                    "\$${(driverWalletByIdData?.data.isMonthEarningSummary.net ?? 0).toStringAsFixed(2)}",
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- STATS ROW ----------------
  Widget _statsRow(WalletState state) {
    if (state.loadingByDriverId) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.driverWalletByIdError != null) {
      return CustomText(title: state.driverWalletByIdError!);
    }

    final data = state.driverWalletByIdData;

    return Row(
      children: [
        Expanded(
          child: smallStatCard(
            icon: Icons.location_on,
            title: "Trips",
            value: "${data?.data.isMonthSummary.totalTrips ?? 0}",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: smallStatCard(
            icon: Icons.star,
            title: "Avg. rating",
            value: (data?.data.isMonthSummary.avgRating ?? 0.0).toStringAsFixed(
              1,
            ),

            subColor: AppColors.btnColor,
          ),
        ),
      ],
    );
  }

  // ---------------- TREND ----------------
  Widget _trendCard(WalletState state) {
    if (state.loadingByDriverId) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.driverWalletByIdError != null) {
      return CustomText(title: state.chartError!);
    }
    return graphChart(state.driverWalletByIdData?.data.fullYearData ?? []);
  }

  // ---------------- RECENT TRIPS ----------------
  Widget _recentTrips(WalletState state) {
    if (state.loadingByDriverId) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.driverWalletByIdError != null) {
      return CustomText(title: state.driverWalletByIdError!);
    }

    final List<RecentTrip> data =
        state.driverWalletByIdData?.data.recentTrips ?? [];

    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            title: "Recent Trips",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          ...List.generate(data.length, (index) {
            final trip = data[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Trip id + time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title:
                            "#${trip.id.substring(trip.id.length - 4)}  "
                            "${DateFormat('HH:mm').format(trip.createdAt)}",
                      ),
                      CustomText(title: trip.status),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// Addresses
                  CustomText(title: "📍 ${trip.pickupAddress}", maxLines: 1),
                  CustomText(title: "📍 ${trip.dropOffAddress}", maxLines: 1),

                  const SizedBox(height: 6),

                  /// Amounts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title:
                            "Distance:  ${trip.distanceKm.toStringAsFixed(2)} KM  ",
                      ),
                      CustomText(
                        title: "Earn: \$${(trip.tipAmount).toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _AmountTile({
    required this.title,
    required this.value,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          title: value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        CustomText(title: title),
      ],
    );
  }
}
