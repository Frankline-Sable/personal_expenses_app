import 'package:flutter/foundation.dart';

class Transactions{
  final String id;
  final String title;
  final DateTime date;
  final double amount;

  Transactions(
      @required this.id,
      @required this.title,
      @required this.date,
      @required this.amount);
}