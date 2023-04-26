import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldsAddProduct extends StatelessWidget {
  const FieldsAddProduct({
    Key? key,
    required this.productNameController,
    required this.priceController,
  }) : super(key: key);

  final TextEditingController productNameController;
  final TextEditingController priceController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Nome do Produto',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          controller: productNameController,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CentavosInputFormatter(moeda: true),
          ],
          decoration: InputDecoration(
            hintText: 'Preço do produto',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          controller: priceController,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
