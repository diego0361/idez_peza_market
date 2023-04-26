import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idez_peza_market/app/models/data/models/market_expenses_model.dart';

class MarketExpensesController extends GetxController {
  CollectionReference marketCollection =
      FirebaseFirestore.instance.collection('marketExpense');

  final productNameController = TextEditingController();
  final priceController = TextEditingController();

  double totalPurchases = 0;

  @override
  void onInit() {
    super.onInit();
    getProducts();
    update();
  }

  Future<void> addProduct() async {
    if (productNameController.text.isEmpty || priceController.text.isEmpty) {
      Get.showSnackbar(const GetSnackBar(
        title: 'Erro',
        message: 'Os campos não podem ficar vazios',
      ));
      return;
    }

    RegExp regex = RegExp(r'[^\d,]+');
    String cleanText =
        priceController.text.replaceAll(regex, '').replaceAll(',', '.');

    marketCollection
        .add(ProductsModel(
                productName: productNameController.text,
                price: double.tryParse(cleanText) ?? 0)
            .toMap())
        .then((value) => debugPrint("Product add"))
        .whenComplete(
      () {
        priceController.clear();
        productNameController.clear();
        getProducts();
        update();
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
    ).whenComplete(() => update());
  }

  List<ProductsModel> productsSearch = [];

  final searchController = TextEditingController();
  void searchProduct(String value) {
    productsSearch = productsList.where((element) {
      return element.productName.toLowerCase().contains(value.toLowerCase());
    }).toList();

    update();
  }
}
