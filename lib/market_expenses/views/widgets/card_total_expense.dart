import 'package:flutter/material.dart';

class CardTotalsExpense extends StatefulWidget {
  const CardTotalsExpense({
    Key? key,
    required this.totalString,
    required this.color,
  }) : super(key: key);

  final String totalString;
  final Color color;

  @override
  State<CardTotalsExpense> createState() => _CardTotalsExpenseState();
}

class _CardTotalsExpenseState extends State<CardTotalsExpense> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        color: widget.color,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        elevation: 10,
        shadowColor: const Color.fromARGB(255, 64, 157, 166),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Text(
            widget.totalString,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
