import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/controller/wallet_controller.dart';

class WalletWithCarDriverView extends ConsumerStatefulWidget {
  const WalletWithCarDriverView({super.key});

  @override
  ConsumerState<WalletWithCarDriverView> createState() => _WalletViewState();
}

class _WalletViewState extends ConsumerState<WalletWithCarDriverView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(walletControllerProvider.notifier).fetchWalletData();
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
            _driverCard(walletState),
            const SizedBox(height: 16),

            _statsRow(walletState),
            const SizedBox(height: 16),
            _trendCard(walletState),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ---------------- DRIVER CARD ----------------
  Widget _driverCard(WalletState state) {
    if (state.loadingSummary) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.summaryError != null) {
      return CustomText(title: state.summaryError!);
    }

    final summary = state.summary;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: "Name",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          CustomText(title: "Fleet owner . ${5} vehicales"),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffFFF3CC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(title: "Total Revenue", fontSize: 16),
                    const SizedBox(height: 4),
                    CustomText(
                      title: "\$${summary?.data.totalRevenue.toInt() ?? 0}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
              child: _smallStatCard(
                icon: Icons.attach_money_outlined,
                title: "Monthly Revenue",
                value: "\$${summary?.monthlyRevenue ?? 0}",
                sub: "+ ${summary?.monthlyGrowth ?? 0}%",
                subColor: Color(0xFF00BC59),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _smallStatCard(
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
              child: _smallStatCard(
                icon: Icons.local_taxi,
                title: "Fleet Utilization",
                value: "${0}",
                sub: "⭐ ${0} avg rating",
                subColor: Color(0xFF7A00FF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _smallStatCard(
                icon: Icons.arrow_outward_sharp,
                title: "Total Trips",
                value: "\$${summary?.totalTrips ?? 0}",
                sub: "+${summary?.monthlyRevenue ?? 0}%",
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

    final chart = state.chart?.data ?? [];

    if (chart.isEmpty) {
      return const CustomText(title: "No chart data available");
    }

    const double maxBarHeight = 120; // leave space for month text

    // 🔥 Find maximum revenue safely
    final maxRevenue = chart
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            title: "6 month Trends",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chart.map((e) {
                final normalizedHeight = maxRevenue == 0
                    ? 4.0
                    : (e.revenue / maxRevenue) * maxBarHeight;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: normalizedHeight.clamp(4, maxBarHeight),
                      width: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomText(title: e.month),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- REUSABLE ----------------
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _smallStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String sub,
    Color subColor = Colors.grey,
  }) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: subColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: subColor),
          ),
          const SizedBox(height: 8),
          CustomText(title: title, fontSize: 14),
          CustomText(
            title: value,
            fontSize: 14,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          CustomText(
            title: sub,
            style: TextStyle(color: subColor),
          ),
        ],
      ),
    );
  }
}
