import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shoppingjkpage/Admin/add_product.dart';
import 'package:shoppingjkpage/Admin/admin_login.dart';
import 'package:shoppingjkpage/Admin/all_orders.dart';
import 'package:shoppingjkpage/Admin/home_admin.dart';
import 'package:shoppingjkpage/pages/bottomnav.dart';
import 'package:shoppingjkpage/pages/home.dart';
import 'package:shoppingjkpage/pages/login.dart';
import 'package:shoppingjkpage/pages/signup.dart';
import 'package:shoppingjkpage/sevices/constant.dart';
import 'package:shoppingjkpage/superbase/superbase.dart'; // Update with the correct path.

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey=publishablekey;
  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNav(),
    );
  }
}
