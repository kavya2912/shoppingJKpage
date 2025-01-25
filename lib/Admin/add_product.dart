import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shoppingjkpage/sevices/database.dart'; // Replace with your Database method
import 'package:shoppingjkpage/widgets/support_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController pricecontroller = new TextEditingController();
  TextEditingController detailcontroller = new TextEditingController();
  String? value;

  // Categories for dropdown
  final List<String> categoryitem = [
    'stone',
    'Pottery',
    'woodwork',
    'Metalwork',
  ];

  // To pick the image from gallery
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  // Upload item to Supabase
  Future uploadItem() async {
    if (selectedImage != null && namecontroller.text != "") {
      String addId = randomAlphaNumeric(10);
      final filePath = 'product-images/$addId.jpg'; // Path where image will be saved

      try {
        // Upload file to Supabase Storage
        final storageResponse = await Supabase.instance.client.storage
            .from('product-images') // Your Supabase bucket name
            .upload(filePath, selectedImage!);

        // // Check for errors
        // if (storageResponse.error != null) {
        //   throw Exception('Error uploading file: ${storageResponse.error!.message}');
        // }

        // Get the uploaded file's public URL
        final imageUrl = Supabase.instance.client.storage
            .from('product-images')
            .getPublicUrl(filePath);

        String firstletter= namecontroller.text.substring(0,1).toUpperCase();

        // Add the product to the database with the image URL
        Map<String, dynamic> addProduct = {
          "Name": namecontroller.text,
          "Image": imageUrl,
          "SearchKey": firstletter,
          "UpdatedName": namecontroller.text.toUpperCase(),
          "Price": pricecontroller.text,
          "Detail": detailcontroller.text,
        };

        await DatabaseMethod().addProduct(addProduct, value!).then((_) async {
         await DatabaseMethod().addAllProducts(addProduct);
          setState(() {
            selectedImage = null;
            namecontroller.text = "";
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.purple[500],
              content: Text(
                "Product has been uploaded successfully!",
                style: TextStyle(fontSize: 20.0),
              ),
            ));
          });

          // // Show success message
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   backgroundColor: Colors.purple[500],
          //   content: Text(
          //     "Product has been uploaded successfully!",
          //     style: TextStyle(fontSize: 20.0),
          //   ),
          // ));
        });
      } catch (e) {
        // Show error message if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Failed to upload product: $e",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text(
          "Add Product",
          style: AppWidget.semiboldTextFieldStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: 20.0,
            top: 20.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the Product Image",
                style: AppWidget.lightTextFieldStyle(),
              ),
              SizedBox(height: 20.0),
              selectedImage == null
                  ? GestureDetector(
                onTap: getImage,
                child: Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.camera_alt_outlined),
                  ),
                ),
              )
                  : Center(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Name", style: AppWidget.lightTextFieldStyle()),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffecefe8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Price", style: AppWidget.lightTextFieldStyle()),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffecefe8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(

                  controller: pricecontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Detail", style: AppWidget.lightTextFieldStyle()),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffecefe8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  maxLines: 6,
                  controller: pricecontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Category", style: AppWidget.lightTextFieldStyle()),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffecefe8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: categoryitem
                        .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: AppWidget.semiboldTextFieldStyle(),
                        )))
                        .toList(),
                    onChanged: (value) => setState(() {
                      this.value = value;
                    }),
                    dropdownColor: Colors.white,
                    hint: Text("Select Category"),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: value,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: uploadItem,
                  child: Text(
                    "Add Product",
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:random_string/random_string.dart';
// import 'package:shoppingjkpage/sevices/database.dart';
// import 'package:shoppingjkpage/widgets/support_widget.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class AddProduct extends StatefulWidget {
//   const AddProduct({super.key});
//
//   @override
//   State<AddProduct> createState() => _AddProductState();
// }
//
// class _AddProductState extends State<AddProduct> {
//   final ImagePicker _picker= ImagePicker();
//   File? selectedImage;
//   TextEditingController namecontroller = new TextEditingController();
//
//   Future getImage()async{
//     var image= await _picker.pickImage(source: ImageSource.gallery);
//     selectedImage = File(image!.path);
//     setState(() {
//
//     });
//   }
//   uploadItem()async{
//   if(selectedImage!=null && namecontroller.text!=""){
//     String addId = randomAlphaNumeric(10);
//     Reference firebaseStorageRef= FirebaseStorage.instance.ref().child("blogImage").child(addId);
//   final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
//   var dowloadUrl = await (await task).ref.getDownloadURL();
//
//   Map<String,dynamic> addProduct={
//     "Name": namecontroller.text,
//     "Image": dowloadUrl,
//   };
//   await DatabaseMethod().addProduct(addProduct, value!).then((value) {
//    selectedImage=null;
//    namecontroller.text="";
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       backgroundColor: Colors.purple[500],
//       content: Text("Product has been uploaded Successfully!!", style: TextStyle(fontSize: 20.0,),),));
//
//   });
//   }
//   }
//   String? value;
//
//   final List<String> categoryitem = [
//     'stone',
//     'Pottery',
//     'woodwork',
//     'Metalwork',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.arrow_back_ios_new_outlined)),
//         title: Text(
//           "Add Product",
//           style: AppWidget.semiboldTextFieldStyle(),
//         ),
//       ),
//       body: Container(
//         margin: EdgeInsets.only(
//           left: 20.0,
//           top: 20.0,
//           right: 20.0,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Uploaded the Product Image",
//               style: AppWidget.lightTextFieldStyle(),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             selectedImage==null?GestureDetector(
//               onTap: (){
//                 getImage() ;
//               },
//               child: Center(
//                 child: Container(
//                   height: 150,
//                   width: 150,
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 1.5),
//                       borderRadius: BorderRadius.circular(20),),
//                   child: Icon(
//                     Icons.camera_alt_outlined,
//                   ),
//                 ),
//               ),
//             ): Center(
//               child: Material(elevation: 4.0,
//               borderRadius: BorderRadius.circular(20),
//                 child: Container(
//                   height: 150,
//                   width: 150,
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 1.5),
//                       borderRadius: BorderRadius.circular(20)),
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//
//                       child: Image.file(selectedImage!, fit: BoxFit.cover,)),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             Text("Product Name", style: AppWidget.lightTextFieldStyle(),),
//             SizedBox(
//               height: 20.0,
//             ),
//
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20.0),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Color(0xffecefe8),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: TextField(
//                 controller: namecontroller,
//                 decoration: InputDecoration(border: InputBorder.none),
//               ),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             Text("Product Category", style: AppWidget.lightTextFieldStyle(),),
//             SizedBox(
//               height: 20.0,
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 10.0,
//               ),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Color(0xffecefe8),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   items: categoryitem
//                       .map((item) => DropdownMenuItem(
//                           value: item,
//                           child: Text(
//                             item,
//                             style: AppWidget.semiboldTextFieldStyle(),
//                           )))
//                       .toList(),
//                   onChanged: ((value) => setState(() {
//                         this.value = value;
//                       })),
//                   dropdownColor: Colors.white,
//                   hint: Text("Select Category"),
//                   iconSize: 36,
//                   icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
//                 value: value,
//                 ),
//               ),
//             ), SizedBox(
//               height: 30.0,
//             ),
//             Center(
//               child: ElevatedButton(onPressed: (){
//                 uploadItem();
//               }, child: Text("Add Product",style: TextStyle(fontSize: 22.0,),),
//               )
//             ),
//
//                   ]
//             ),
//         ),
//       );
//
//
//   }
// }
