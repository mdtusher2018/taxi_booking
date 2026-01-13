
import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import '../model/card_model.dart';

class AddCardWidget extends StatelessWidget {
  final List<CardModel> cards;
  final VoidCallback onAddCard;

  const AddCardWidget({
    super.key,
    required this.cards,
    required this.onAddCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header with Add Button ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Card List",
                style: CommonStyle.textStyleLarge(size: 18)),
            IconButton(
              onPressed: onAddCard,
              icon: const Icon(Icons.add_circle, color: Colors.orange, size: 28),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // --- Horizontal Card List ---
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: card.color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(card.bank,
                        style: CommonStyle.textStyleMedium(color: Colors.grey)),
                    Text(card.cardNumber,
                        style: CommonStyle.textStyleLarge(size: 18, color: Colors.white)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(card.holderName,
                            style: CommonStyle.textStyleSmall(size: 12, color: Colors.white)),
                        Text("Exp: ${card.expiry}",
                            style: CommonStyle.textStyleSmall(size: 12, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
