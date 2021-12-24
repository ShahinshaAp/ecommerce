// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, must_be_immutable, prefer_final_fields, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screen/product_page.dart';
import 'package:ecommerce_app/sevices/firebase_services.dart';
import 'package:ecommerce_app/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  SearchTab({Key key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        if (_searchString.isNotEmpty)
          FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productsRef
                  .where('name', isGreaterThanOrEqualTo: _searchString)
                  .get(),
              // .orderBy('name')
              // .startAt([_searchString]).endAt(['$_searchString\uf8ff']).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error : ${snapshot.error}'),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_searchString.isEmpty) {}
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 12),
                    child: ListView(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.09,
                          bottom: MediaQuery.of(context).size.height * 0.02),
                      children: snapshot.data.docs.map((document) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) => ProductPage(
                                          productId: document.id,
                                        )));
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    document['images'][0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 12,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${document['name']}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    // Padding(
                                    //     padding: EdgeInsets.symmetric(
                                    //   vertical: 2,
                                    // )),
                                    // Text(
                                    //   'Size - ${document['size']}',
                                    //   style: TextStyle(
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.w600),
                                    // ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                      vertical: 2,
                                    )),
                                    Text(
                                      '\$${document['price']}',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
        if (_searchString.isEmpty)
          Container(
            child: Center(
              child: Text(
                'Search Here..',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CustomInput(
              hinttext: "Search here..",
              onChanged: (value) {
                setState(() {
                  _searchString = value;
                });
              }),
        ),
      ],
    ));
  }
}
