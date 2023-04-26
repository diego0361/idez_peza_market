import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idez_peza_market/app/models/views/market_expenses_controller.dart';
import 'package:idez_peza_market/app/models/views/widgets/card_total_expense.dart';

import 'widgets/dialog_confirm_delete.dart';
import 'widgets/field_add_products.dart';

class MarketExpensesPage extends StatelessWidget {
  final controller = Get.put(MarketExpensesController());

  MarketExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(40, 29, 124, 213),
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(
            top: 15.0,
            left: 20,
            right: 20,
            bottom: 15,
          ),
          child: GetBuilder<MarketExpensesController>(
            builder: (controller) {
              return TextField(
                controller: controller.searchController,
                onChanged: (value) {
                  controller.searchProduct(value);
                },
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 12, 12, 12),
                  ),
                  labelText: 'Pesquisar',
                  filled: true,
                  fillColor: const Color.fromARGB(40, 29, 124, 213),
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GetBuilder<MarketExpensesController>(
        builder: (controller) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              controller.addProduct();
            },
          );
        },
      ),
      body: GetBuilder<MarketExpensesController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              FieldsAddProduct(
                productNameController: controller.productNameController,
                priceController: controller.priceController,
              ),
              Expanded(
                child: Visibility(
                  visible: controller.productsList.isEmpty,
                  replacement: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.productsSearch.isNotEmpty
                        ? controller.productsSearch.length
                        : controller.productsList.length,
                    itemBuilder: (context, index) {
                      var product = controller.productsList[index];
                      if (controller.productsSearch.isEmpty) {
                        product = controller.productsList[index];
                      } else {
                        product = controller.productsSearch[index];
                      }
                      return ListTile(
                        trailing: Padding(
                          padding: const EdgeInsets.only(top: 17),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogConfirmDelete(
                                    text:
                                        "Tem certeza que deseja excluir produto?",
                                    onPressedDelete: () {
                                      controller.deleteProduct(product.id!);

                                      Navigator.of(context).pop(true);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              product.productName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(product.price.obterReal()),
                          ],
                        ),
                      );
                    },
                  ),
                  child: const Center(
                    child: Text(
                      'Nenhum produto adicionado',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                children: [
                  CardTotalsExpense(
                    totalString:
                        "TOTAL = ${controller.totalPurchases.obterReal()}",
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
