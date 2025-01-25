
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shoppingjkpage/sevices/database.dart';
import 'package:shoppingjkpage/sevices/shared_pref.dart';
import 'package:shoppingjkpage/widgets/support_widget.dart';
import 'package:http/http.dart' as http;

import '../sevices/constant.dart';

class ProductDetail extends StatefulWidget {
  String image, name, detail, price;
  ProductDetail({
    required this.detail,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends
State<ProductDetail> {
  String? name, mail, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    mail = await SharedPreferenceHelper().getUserEmail();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {

    });
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecefe8),
      body: Container(
        padding: EdgeInsets.only(top: 30.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 20.0),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(30)),
                      child: Icon(Icons.arrow_back_ios_new_outlined)),
                ),
                Center(
                  child: Image.network(
                    //"images/Blue_pottery_-removebg-preview.png",
                    widget.image,
                    height: 400,
                    // width: 400,
                    //fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: AppWidget.boldTextFieldStyle(),
                        ),
                        Text(
                          "\$" + widget.price,
                          // "\$100",
                          style: TextStyle(
                            color: Color.fromARGB(135, 145, 47, 162),
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                          ), //0xffd6f3e
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Details",
                      style: AppWidget.semiboldTextFieldStyle(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(widget.detail
                      // "Blue pottery is a traditional craft originating from Jaipur, "
                      //   "known for its vibrant colors and intricate patterns. The pottery "
                      //   "is made using quartz, not clay, which gives it a unique finish. ",
                      //"Each piece is handcrafted by skilled artisans, making it a perfect ",
                      //"addition to your home decor or a thoughtful gift for loved ones.",
                      // style: AppWidget.lightTextFieldStyle(),
                    ),
                    SizedBox(
                      height: 90.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        makePayment(widget.price);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(135, 145, 47, 162),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Center(
                            child: Text(
                              "Buy Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<void> makePayment(String price) async {
    try {
      // Create payment intent
      paymentIntent = await createPaymentIntent(price, 'INR');
      if (paymentIntent == null || paymentIntent!['client_secret'] == null) {
        throw Exception("Failed to retrieve client secret from payment intent.");
      }

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: const PaymentSheetGooglePay(
            testEnv: true,
            currencyCode: "INR",
            merchantCountryCode: "IN",
          ),
          merchantDisplayName: 'Flutterwings',
        ),
      );

      // Present payment sheet
      await displayPaymentSheet();
    } catch (e) {
      print("Payment exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    }
  }

  displayPaymentSheet() async {
    try {
      // "Display payment sheet";
      await Stripe.instance.presentPaymentSheet();
      // Show when payment is done
      // Displaying snackbar for it
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paid successfully")),
      );
      paymentIntent = null;
    } on StripeException catch (e) {
      // If any error comes during payment 
      // so payment will be cancelled
      print('Error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(" Payment Cancelled")),
      );
    } catch (e) {
      print("Error in displaying");
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      // Define request body
      Map<String, dynamic> body = {
        'amount': (int.parse(amount) * 100).toString(),
        // Stripe uses smallest currency unit
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      // Define secret key
      var secretKey = "sk_test_51QgtzI8y4M7XlhR7UzoRuL2ZLkyystOFtdQnFcLNcAu14BqMWF6aIeezIYZgcWH043q3ugmCPJYCc8Muc1bPINVh00XQEgBlKB";

      // Make HTTP request to Stripe API
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      // Check response status
      if (response.statusCode != 200) {
        throw Exception("Failed to create payment intent: ${response.body}");
      }

      // Decode and return the response body
      return jsonDecode(response.body);
    } catch (err) {
      print('Error creating payment intent: $err');
      return null;
    }
  }


// displayPaymentSheet() async {
//   try {
//     await Stripe.instance.presentPaymentSheet().then((value) async {
//       Map<String, dynamic>orderInfoMap = {
//         "Product": widget.name,
//         "Price": widget.price,
//         "Name": name,
//         "Email": mail,
//         "Image": image,
//         "ProductImage": widget.image,
//         "Status": "on the way "
//       };
//       await DatabaseMethod().orderDetails(orderInfoMap);
//       showDialog(
//           context: context,
//           builder: (_) =>
//               AlertDialog(
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.check_circle,
//                           color: Colors.purpleAccent,
//                         ),
//                         Text("Payment Successfull")
//                       ],
//                     )
//                   ],
//                 ),
//               ));
//       paymentIntent = null;
//     }).onError((error, stackTrace) {
//       print("Error is :---> $error $stackTrace");
//     });
//   } on StripeException catch (e) {
//     print("Error is:----> $e");
//     showDialog(
//         context: context,
//         builder: (_) =>
//             AlertDialog(
//               content: Text("Cancelled"),
//             ));
//   } catch (e) {
//     print('$e');

//   }
// }


//   createPaymentIntent(String amount, String currency)
//   async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           "Authorization": 'Bearer $secretkey',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//   }
//
//   calculateAmount(String amount) {
//     final calculatedAmount = (int.parse(amount)*100);
//     return calculatedAmount.toString();
//   }
// }
}
