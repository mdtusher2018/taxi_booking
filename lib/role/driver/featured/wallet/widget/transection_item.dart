import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> transaction;
  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isNegative = transaction['amount'].toString().startsWith('-');
    return ListTile(
      leading: Icon(
        Icons.attach_money,
        color: isNegative ? Colors.red : Colors.green,
      ),
      title: Text(transaction['name']),
      subtitle: Text('${transaction['distance']} ${transaction['time']}'),
      trailing: Text(
        '\$${transaction['amount']}',
        style: TextStyle(
          color: isNegative ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
