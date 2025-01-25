import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingjkpage/pages/category_product.dart';
import 'package:shoppingjkpage/pages/product_detail.dart';
import 'package:shoppingjkpage/sevices/database.dart';
import 'package:shoppingjkpage/sevices/shared_pref.dart';
import 'package:shoppingjkpage/widgets/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  List categories = [
    "images/stone.png",
    "images/Pottery.png",
    "images/woodwork.png",
    "images/Metalwork.png",
  ];

  List Categoryname = [
    "Stone",
    "Pottery",
    "woodwork",
    "Metalwork",
  ];

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller= new TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var CapitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethod().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['UpdatedName'].startsWith(CapitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  String? name, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecefe8),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.only(
                top: 50.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Hey," + name!,
                              style: AppWidget.boldTextFieldStyle(),
                            ),
                            Text(
                              "Good Morning",
                              style: AppWidget.lightTextFieldStyle(),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            image!,
                            // "images/girl.jpg",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: searchcontroller,
                      onChanged: (value) {
                        initiateSearch(value.toUpperCase());
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Products",
                        hintStyle: AppWidget.lightTextFieldStyle(),
                        prefixIcon: search
                            ? GestureDetector(
                            onTap: (){
                              search=false;
                              tempSearchStore=[];
                              queryResultSet=[];
                              searchcontroller.text="";
                              setState(() {

                              });
                            },
                            child: Icon(Icons.close))
                            : Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  search
                      ? ListView(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          primary: false,
                          shrinkWrap: true,
                          children: tempSearchStore.map((element) {
                            return buildResultCard(element);
                          }).toList(),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Categories",
                                style: AppWidget.semiboldTextFieldStyle(),
                              ),
                              Text(
                                "see all",
                                style: TextStyle(
                                  color: Color.fromARGB(135, 145, 47, 162),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ), //0xffd6f3e
                              )
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 130,
                        padding: EdgeInsets.all(20.0),
                        margin: EdgeInsets.only(right: 20.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(135, 145, 47, 162),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "All",
                            style: TextStyle(
                              color: Colors.white,
                              // color: Color.fromARGB(135, 145, 47, 162),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          // margin: const EdgeInsets.only(
                          //   left: 20.0,
                          // ),
                          height: 130,

                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: categories.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CategoryTile(
                                image: categories[index],
                                name: Categoryname[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All Products",
                        style: AppWidget.semiboldTextFieldStyle(),
                      ),
                      const Text(
                        "see all",
                        style: TextStyle(
                          color: Color.fromARGB(135, 145, 47, 162),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ), //0xffd6f3e
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    //whitebox size
                    height: 240,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        //Blue Pottery
                        Container(
                          // height: 160,
                          // width: 160,
                          //it help to give gap between blue pottery
                          margin: EdgeInsets.only(
                            right: 20.0,
                          ),
                          //
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          //

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "images/Blue_pottery_-removebg-preview.png",
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                "Blue Pottery",
                                style: AppWidget.semiboldTextFieldStyle(),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$100",
                                    style: TextStyle(
                                      color: Color.fromARGB(135, 145, 47, 162),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30.0,
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(135, 145, 47, 162),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                        //Channapta
                        Container(
                          height: 160,
                          width: 160,
                          //it help to give gap between blue pottery
                          margin: EdgeInsets.only(
                            right: 20.0,
                          ),
                          //
                          //
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          //

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "images/channapta-removebg-preview.png",
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                "Channapta",
                                style: AppWidget.semiboldTextFieldStyle(),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$260",
                                    style: TextStyle(
                                      color: Color.fromARGB(135, 145, 47, 162),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(135, 145, 47, 162),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                  //......

                                  //.......
                                ],
                              )
                            ],
                          ),
                        ),
                        //Meenakri
                        Container(
                          height: 160,
                          width: 160,
                          //it help to give gap between blue pottery
                          margin: EdgeInsets.only(
                            right: 20.0,
                          ),
                          //
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          //

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "images/Meenakri-removebg-preview.png",
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                "Meenakri",
                                style: AppWidget.semiboldTextFieldStyle(),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$300",
                                    style: TextStyle(
                                      color: Color.fromARGB(135, 145, 47, 162),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(135, 145, 47, 162),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                        //............
                        Container(
                          height: 160,
                          width: 160,
                          //it help to give gap between blue pottery
                          margin: EdgeInsets.only(
                            right: 20.0,
                          ),
                          //
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          //

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "images/Madhubani_-removebg-preview.png",
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                "Madhubani",
                                style: AppWidget.semiboldTextFieldStyle(),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$100",
                                    style: TextStyle(
                                      color: Color.fromARGB(135, 145, 47, 162),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(135, 145, 47, 162),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),

                        //........
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                    detail: data["Detail"],
                    image: data["Image"],
                    name: data["Name"],
                    price: data["Price"])));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 100,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data["Image"],
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              data["Name"],
              style: AppWidget.semiboldTextFieldStyle(),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  String image, name;
  CategoryTile({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProduct(category: name)));
      },
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
