import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/controller/wallet_controller.dart';

class WalletWithoutCarDriverView extends ConsumerStatefulWidget {
  const WalletWithoutCarDriverView({super.key});

  @override
  ConsumerState<WalletWithoutCarDriverView> createState() => _WalletViewState();
}

class _WalletViewState extends ConsumerState<WalletWithoutCarDriverView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(walletControllerProvider.notifier).fetchWalletData();
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
            _thisMonthCard(walletState),
            const SizedBox(height: 16),
            _statsRow(walletState),
            const SizedBox(height: 16),
            _trendCard(walletState),
            const SizedBox(height: 16),
            _recentTrips(),
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
            title: "—",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          CustomText(title: "Driver . ID : ${"summary"}"),
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
                    const CustomText(title: "Total Earning"),
                    const SizedBox(height: 4),
                    CustomText(
                      title: "\$${summary?.data.totalRevenue ?? 0}",
                      style: const TextStyle(
                        fontSize: 22,
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

  // ---------------- THIS MONTH CARD ----------------
  Widget _thisMonthCard(WalletState state) {
    final summary = state.summary;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(title: "This Month"),
          CustomText(title: "summary?.data.month"),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AmountTile(
                title: "Gross",
                value: "\$${summary?.data.monthlyGrowth ?? 0}",
              ),
              _AmountTile(
                title: "Commission",
                value: "-\$${0}",
                color: Colors.red,
              ),
              _AmountTile(title: "Net", value: "\$${0}", color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- STATS ROW ----------------
  Widget _statsRow(WalletState state) {
    final summary = state.summary;

    return Row(
      children: [
        Expanded(
          child: _smallStatCard(
            icon: Icons.location_on,
            title: "Trips",
            value: "${0}",
            sub: "⭐ ${0} avg rating",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _smallStatCard(
            icon: Icons.attach_money,
            title: "Monthly Revenue",
            value: "\$${summary?.data.monthlyRevenue ?? 0}",
            sub: "+${summary?.data.monthlyRevenue ?? 0}%",
            subColor: Colors.green,
          ),
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
              children: chart.map((e) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: e.revenue.toDouble(), // normalize if needed
                      width: 10,
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

  // ---------------- RECENT TRIPS ----------------
  Widget _recentTrips() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            title: "Recent Trips",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...List.generate(3, (index) => _tripTile()),
        ],
      ),
    );
  }

  Widget _tripTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(title: "#001  14:30"),
              CustomText(title: "⭐ 4.8"),
            ],
          ),
          SizedBox(height: 6),
          CustomText(title: "📍 Downtown"),
          CustomText(title: "📍 Airport"),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(title: "\$25.60  -\$4.60"),
              CustomText(
                title: "\$24.22 net",
                style: TextStyle(color: Colors.green),
              ),
            ],
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
          Icon(icon, color: Colors.green),
          const SizedBox(height: 8),
          CustomText(title: title),
          CustomText(
            title: value,
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
