// Card Model

import 'package:flutter/cupertino.dart';

class CardModel {
  final String bank;
  final String cardNumber;
  final String holderName;
  final String expiry;
  final Color color;

  CardModel({
    required this.bank,
    required this.cardNumber,
    required this.holderName,
    required this.expiry,
    required this.color,
  });
}
