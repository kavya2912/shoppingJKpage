import 'package:flutter/material.dart';
import 'package:shoppingjkpage/Admin/add_product.dart';
import 'package:shoppingjkpage/Admin/all_orders.dart';

import '../widgets/support_widget.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecefe8),
      appBar: AppBar(
        backgroundColor: Color(0xffecefe8),
        title: Text(
          "Home Admin",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 50.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        "Add Product",
                        style: AppWidget.boldTextFieldStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80.0,
            ),
            GestureDetector(
              onTap:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllOrders()));
              } ,
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 50.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        "All Orders",
                        style: AppWidget.boldTextFieldStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
