import 'package:flutter/material.dart';
import 'package:taxi_booking/role/user/featured/payment/views/add_card_view.dart';
import '../model/card_model.dart';
import '../model/transection_model.dart';
import '../widget/add_card_widget.dart';
import '../widget/transection_history_card.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late final List<TransectionModel> transactions;
  late final List<CardModel> cards;

  @override
  void initState() {
    super.initState();

    transactions = [
      TransectionModel(
        dateTime: 'Saturday, 12/12/2024, 05:41 PM',
        amount: '\$52.90',
        pickup: '6391 Elgin St. Delaware 10299',
        dropoff: '8502 Preston, Inglewood, Maine.',
        imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        rating: 4.8,
      ),
      TransectionModel(
        dateTime: 'Saturday, 12/12/2024, 05:41 PM',
        amount: '\$52.90',
        pickup: '6391 Elgin St. Delaware 10299',
        dropoff: '8502 Preston, Inglewood, Maine.',
        imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        rating: 4.8,
      ),
    ];

    cards = [
      CardModel(
        bank: 'ADRBank',
        cardNumber: '8763 2736 9873 0329',
        holderName: 'Ronald Richards',
        expiry: '10/28',
        color: Colors.greenAccent,
      ),
      CardModel(
        bank: 'ADRBank',
        cardNumber: '8763 2736 2345 6789',
        holderName: 'Marvin McKinney',
        expiry: '12/25',
        color: Colors.deepPurpleAccent,
      ),
      CardModel(
        bank: 'ADRBank',
        cardNumber: '1234 5678 9012 3456',
        holderName: 'Theresa Webb',
        expiry: '08/26',
        color: Colors.teal,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ADD CARD
            AddCardWidget(
              cards: cards,
              onAddCard: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddCardView()),
                );
              },
            ),

            const SizedBox(height: 24),

            const Text(
              "Transaction History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            /// TRANSACTIONS
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionHistoryCard(
                    transection: transactions[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
