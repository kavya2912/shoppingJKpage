import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shoppingjkpage/pages/Order.dart';
import 'package:shoppingjkpage/pages/Profile.dart';
import 'package:shoppingjkpage/pages/home.dart';
//it for bottom navigation
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  late Home HomePage;
  late Order order;
  late Profile profile;
  int currentTableIndex = 0;

  @override
  void initState() {
    HomePage = Home();
    order = Order();
    profile = Profile();
    pages = [HomePage, order, profile];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        //65
        backgroundColor: Color(0xfff2f2f2),
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index ){
          setState(() {
            currentTableIndex=index;
          });
        },
        items: [
          Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.person_outlined,
            color: Colors.white,
          ),
        ],
      ),
      body: pages[currentTableIndex],
    );
  }
}
