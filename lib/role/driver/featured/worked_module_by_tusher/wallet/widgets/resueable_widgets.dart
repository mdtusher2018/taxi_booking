import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/monthly_revenue_model.dart';

mixin WalletReuseableWidgets {
  // ---------------- REUSABLE ----------------
  Widget card({required Widget child}) {
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

  Widget smallStatCard({
    required IconData icon,
    required String title,
    required String value,
    String? sub,
    Color subColor = Colors.grey,
  }) {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: subColor.withOpacity(0.15),
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
          if (sub != null)
            CustomText(
              title: sub,
              style: TextStyle(color: subColor),
            ),
        ],
      ),
    );
  }

  Widget graphChart(List<MonthlyRevenue> chart) {
    if (chart.isEmpty) {
      return const CustomText(title: "No chart data available");
    }

    const double maxBarHeight = 120; // leave space for month text

    // 🔥 Find maximum revenue safely
    final maxRevenue = chart
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return card(
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

  // ---------------- DRIVER CARD ----------------
  Widget driverCard({required String name, required num totalEarn}) {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

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
                      title: "\$${totalEarn.toStringAsFixed(2)}",
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
}
