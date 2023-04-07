import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idez_peza_market/market_expenses/models/market_expenses_model.dart';
import 'package:idez_peza_market/market_expenses/views/widgets/card_total_expense.dart';

import 'widgets/dialog_confirm_delete.dart';
import 'widgets/field_add_products.dart';

class MarketExpensesPage extends StatefulWidget {
  const MarketExpensesPage({Key? key}) : super(key: key);

  @override
  State<MarketExpensesPage> createState() => _MarketExpensesPageState();
}

class _MarketExpensesPageState extends State<MarketExpensesPage> {
  @override
  void initState() {
    getProducts();
    super.initState();
  }

  CollectionReference marketCollection =
      FirebaseFirestore.instance.collection('marketExpense');

  final productNameController = TextEditingController();
  final priceController = TextEditingController();

  double totalPurchases = 0;

  Future<void> addProduct() async {
    if (productNameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Os campos não podem ficar vazios'),
        ),
      );
      return;
    }

    RegExp regex = RegExp(r'[^\d,]+');
    String cleanText =
        priceController.text.replaceAll(regex, '').replaceAll(',', '.');

    marketCollection
        .add(
          ProductsModel(
                  productName: productNameController.text,
                  price: double.tryParse(cleanText) ?? 0)
              .toMap(),
        )
        .then((value) => debugPrint("Product add"))
        .whenComplete(
      () {
        priceController.clear();
        productNameController.clear();
        getProducts();
      },
    ).catchError(
      (error) => debugPrint("Failed to add Product: $error"),
    );
  }

  Future<void> deleteProduct(String id) async {
    marketCollection
        .doc(id)
        .delete()
        .then((value) => debugPrint("Expense Deleted"))
        .whenComplete(() => getProducts())
        .catchError(
          (error) => debugPrint("Failed to delete product: $error"),
        );
  }

  List<ProductsModel> productsList = [];
  Future<void> getProducts() async {
    return FirebaseFirestore.instance.collection('marketExpense').get().then(
      (QuerySnapshot querySnapshot) {
        productsList = [];
        totalPurchases = 0;

        for (var doc in querySnapshot.docs) {
          final products = ProductsModel(
              id: doc.reference.id,
              productName: doc['productName'],
              price: double.tryParse(doc['price'].toString()) ?? 0);

          totalPurchases += products.price;

          productsList.add(products);
        }

        productsList.sort((a, b) => b.price.compareTo(a.price));
      },
    ).whenComplete(() => setState(() {}));
  }

  List<ProductsModel> productsSearch = [];

  final searchController = TextEditingController();
  void searchProduct(String value) {
    productsSearch = productsList.where((element) {
      return element.productName.toLowerCase().contains(value.toLowerCase());
    }).toList();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(40, 29, 124, 213),
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding:
              const EdgeInsets.only(top: 15.0, left: 20, right: 20, bottom: 15),
          child: TextField(
            cursorColor: Colors.black,
            controller: searchController,
            onChanged: (value) {
              searchProduct(value);
              setState(() {});
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
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          addProduct();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          FieldsAddProduct(
            productNameController: productNameController,
            priceController: priceController,
          ),
          Expanded(
            child: Visibility(
              visible: productsList.isEmpty,
              replacement: ListView.builder(
                shrinkWrap: true,
                itemCount: productsSearch.isNotEmpty
                    ? productsSearch.length
                    : productsList.length,
                itemBuilder: (context, index) {
                  var product = productsList[index];
                  if (productsSearch.isEmpty) {
                    product = productsList[index];
                  } else {
                    product = productsSearch[index];
                  }
                  return ListTile(
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 17),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogConfirmDelete(
                                text: "Tem certeza que deseja excluir produto?",
                                onPressedDelete: () {
                                  deleteProduct(product.id!);

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
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              CardTotalsExpense(
                totalString: "TOTAL = ${totalPurchases.obterReal()}",
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
