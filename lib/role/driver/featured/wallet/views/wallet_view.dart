// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import '../widget/transection_item.dart';

class WalletView extends StatelessWidget {
  WalletView({super.key});

  var lifetimeIncome = 520351.0;
  var todayIncome = 5203.0;
  var totalTrips = 652;

  var transactions = <Map<String, dynamic>>[];
  var allTransactions = <Map<String, dynamic>>[];

  void fetchWalletData() {
    allTransactions = [
      {
        'name': 'Esther Howard',
        'distance': '15.6 km',
        'time': '2025-08-17 09:20',
        'amount': '+253.0',
      },
      {
        'name': 'Balance Withdraw',
        'distance': '',
        'time': '2025-08-16 09:20',
        'amount': '-1256.0',
      },
      {
        'name': 'Theresa Webb',
        'distance': '15.6 km',
        'time': '2025-08-16 09:20',
        'amount': '+253.0',
      },
    ];
    transactions = allTransactions;
  }

  void filterTransactionsByDate(DateTime date) {
    final filtered =
        allTransactions.where((tx) {
          DateTime txDate = DateTime.parse(tx['time'].toString().split(" ")[0]);
          return txDate.year == date.year &&
              txDate.month == date.month &&
              txDate.day == date.day;
        }).toList();

    transactions = filtered;

    // Update todayIncome dynamically
    double income = 0;
    for (var tx in filtered) {
      income += double.tryParse(tx['amount']) ?? 0;
    }
    todayIncome = income;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Wallet'),
      body: Column(
        children: [
          /// Lifetime Income
          LifetimeIncomeCard(lifetimeIncome: lifetimeIncome),

          /// Today Income + Total Trips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TodayIncomeCard(
                filterTransactionsByDate: (date) {
                  if (date != null) {
                    filterTransactionsByDate(date);
                  }
                },
                todayIncome: todayIncome,
              ),
              TotalTripCard(totalTrips: double.parse(totalTrips.toString())),
            ],
          ),

          /// Transactions
          Expanded(child: TransactionList(transactions: transactions)),
        ],
      ),
    );
  }
}

///////////////////////
/// Custom Widgets ///
///////////////////////

class LifetimeIncomeCard extends StatelessWidget {
  num lifetimeIncome;
  LifetimeIncomeCard({required this.lifetimeIncome, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mainColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Life Time Income',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                '\$${lifetimeIncome}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Image.asset(
            AppImages.badgeIcon,
            width: MediaQuery.sizeOf(context).width / 12,
          ),
        ],
      ),
    );
  }
}

class TodayIncomeCard extends StatelessWidget {
  TodayIncomeCard({
    super.key,
    required this.todayIncome,
    required this.filterTransactionsByDate,
  });
  double todayIncome;
  Function(DateTime?) filterTransactionsByDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.mainColor,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          filterTransactionsByDate(pickedDate);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        width: 150,
        decoration: BoxDecoration(
          color: AppColors.mainColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Income',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(width: 5),
                Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ],
            ),
            Text(
              '\$$todayIncome',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class TotalTripCard extends StatelessWidget {
  double totalTrips;
  TotalTripCard({super.key, required this.totalTrips});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: 150,
      decoration: BoxDecoration(
        color: AppColors.mainColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Total Trip',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            '$totalTrips',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  List<Map<String, dynamic>> transactions;

  TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionItem(transaction: transaction);
      },
    );
  }
}
