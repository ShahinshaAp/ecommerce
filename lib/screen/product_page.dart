// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_final_fields, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screen/constants.dart';
import 'package:ecommerce_app/widgets/custom_action_bar.dart';

import 'package:ecommerce_app/widgets/image_swipe.dart';
import 'package:ecommerce_app/widgets/product_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  const ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection('products');

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('Users');

  User _user = FirebaseAuth.instance.currentUser;

  SnackBar snackbar;

  Future addCart() {
    return _userRef
        .doc(_user.uid)
        .collection('Cart')
        .doc(widget.productId)
        .set({
      "Size": _selectedProductSize,
      "image": _imagepic,
      "price": _price,
      "name": _productName
    });
  }

  Future savedPage() {
    return _userRef
        .doc(_user.uid)
        .collection('Saved')
        .doc(widget.productId)
        .set({
      "Size": _selectedProductSize,
      "image": _imagepic,
      "price": _price,
      "name": _productName
    });
  }

  String _selectedProductSize = '0';
  String _imagepic = '0';
  String _price = '0';
  String _productName = '0';

  final SnackBar _snackBar =
      SnackBar(content: Text('Product Added To The Cart '));
  final SnackBar _snackBar1 = SnackBar(content: Text('Product Saved '));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          FutureBuilder(
              future: _productRef.doc(widget.productId).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error : ${snapshot.error}'),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> documentData = snapshot.data.data();
                  List imageList = documentData['images'];
                  List productSize = documentData['size'];
                  String priceList = documentData['price'];
                  String productName = documentData['name'];
                  _selectedProductSize = productSize[0];
                  _imagepic = imageList[0];
                  _price = priceList;
                  _productName = productName;

                  return ListView(
                    children: [
                      ImageSwipe(
                        imageList: imageList,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 24, right: 24, left: 24, bottom: 4),
                        child: Text(
                          documentData['name'],
                          style: Constants.regularHeading,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 24),
                        child: Text(
                          ' \$ ${documentData['price']}',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24),
                        child: Text(
                          documentData['desc'],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 24),
                        child: Text(
                          "Select Size",
                          style: Constants.regularDarktext,
                        ),
                      ),
                      ProductSize(
                        productSize: productSize,
                        onSelected: (size) {
                          _selectedProductSize = size;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await savedPage();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(_snackBar1);
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Color(0xFFDCDCDC),
                                    borderRadius: BorderRadius.circular(12)),
                                alignment: Alignment.center,
                                child: Image(
                                  image:
                                      AssetImage('assets/images/tab_saved.png'),
                                  width: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await addCart();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(_snackBar);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 16),
                                  // width: MediaQuery.of(context).size.width * 0.70,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Text(
                                    'Add To Cart',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
          CustomActionBar(
            hasBackArrow: true,
            hastitle: false,
            hasgradient: false,
          )
        ],
      )),
    );
  }
}
