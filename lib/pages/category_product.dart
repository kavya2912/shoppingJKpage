import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingjkpage/pages/product_detail.dart';
import 'package:shoppingjkpage/sevices/database.dart';
import 'package:shoppingjkpage/widgets/support_widget.dart';

class CategoryProduct extends StatefulWidget {
 String category;
 CategoryProduct({required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream? CategoryStream;

  getonthlod()async{
CategoryStream= await DatabaseMethod().getProducts(widget.category);
 setState(() {

 });
  }

  @override
  void initState() {
    getonthlod();
    super.initState();
  }

  Widget allProducts(){
    return StreamBuilder(stream: CategoryStream, builder: (context, AsyncSnapshot snapshot){
      return snapshot.hasData? GridView.builder(
        padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0),itemCount: snapshot.data.docs.length, itemBuilder: (context, index){
          DocumentSnapshot ds= snapshot.data.docs[index];

          return
            Container(
              // height: 160,
              // width: 160,
              //it help to give gap between blue pottery

              //
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0,),
              //

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10.0,),
                  Image.network(ds["Image"],height: 150, width: 150,fit: BoxFit.cover,),
                  SizedBox(height: 10.0,),
                  Text(
                    ds["Name"],
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  Spacer(),
                  // SizedBox(
                  //   height: 10.0,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${ds["Price"]}",
                        style: TextStyle(
                          color: Color.fromARGB(135, 145, 47, 162),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail(detail: ds["Detail"], image: ds["Image"], name: ds["Name"] , price: ds["Price"])));
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(135, 145, 47, 162),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )
                ],
              ),
            );

        //  );
      }): Container();

    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecefe8),
      appBar: AppBar(backgroundColor: Color(0xffecefe8),),
      body: Container(child: Column(children: [
        Expanded(child: allProducts()),

      ],),),
    );
  }
}
