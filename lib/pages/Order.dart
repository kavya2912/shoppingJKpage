import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingjkpage/sevices/database.dart';
import 'package:shoppingjkpage/sevices/shared_pref.dart';
import 'package:shoppingjkpage/widgets/support_widget.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? email;




  getthesharedpref() async {
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
    setState(() {});
  }

  Stream? orderStream;

  getontheload() async {
    await getthesharedpref();
    orderStream = await DatabaseMethod().getOrders(email!);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,

                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 20.0,
                            top: 10.0,
                            bottom: 10.0,
                          ),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Image.network(
                                ds["ProductImage"],
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SizedBox(
                                    //   width: 30.0,
                                    // ),
                                    Text(
                                      ds["Image"],
                                      style: AppWidget.semiboldTextFieldStyle(),
                                    ),
                                    Text(
                                      "\$" + ds["Price"],
                                      // "\$100",
                                      style: TextStyle(
                                        color: Color.fromARGB(135, 145, 47, 162),
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.bold,), ),

                                    Text(
                                      "Status :" +   ds["Status"],
                                       //   ds["Price"],
                                      // "\$100",
                                      style: TextStyle(
                                        color: Color.fromARGB(135, 145, 47, 162),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,), ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecefe8),
      appBar: AppBar(
        backgroundColor: Color(0xffecefe8),
        title: Text(
          "Current Orders",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        child: Column(
          children: [Expanded(child: allOrders())],
        ),
      ),
    );
  }
}
