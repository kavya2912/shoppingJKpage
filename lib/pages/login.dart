import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppingjkpage/pages/bottomnav.dart';
import 'package:shoppingjkpage/pages/home.dart';
import 'package:shoppingjkpage/pages/signup.dart';
import 'package:shoppingjkpage/widgets/support_widget.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email="",password="";


  TextEditingController mailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey= GlobalKey<FormState>();

  ueserLogin()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    
    Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNav()));
    }on FirebaseAuthException catch(e){
      if(e.code=='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.purple[500],
          content: Text("No User Found for that Email", style: TextStyle(fontSize: 20.0,),),));

      }
      else if(e.code=="wrong-password"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.purple[500],
          content: Text(
            "Wrong Password Provided by User",
            style: TextStyle(fontSize: 20.0,),),));

      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            top: 40.0,
            left: 20.0,
            right: 20.0,
            bottom: 40.0,
          ),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "images/login.png",
                    //                   // width: 300,
                    //                   //height: 300,
                    //                   // fit: BoxFit.cover,
                ),
                Center(
                  child: Text(
                    "Sign In",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Please enter the details below to\n                      continue",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Email",
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                SizedBox(
                  height: 20.0,
                ),
            Container(
                       padding: EdgeInsets.only(
                         left: 20.0,
                       ),
                       decoration: BoxDecoration(
                          color: Color(0xffecefe8),
                          borderRadius: BorderRadius.circular(10)
                       ),
              child: TextFormField(
                validator: (value){
                  if(value==null||value.isEmpty){
                    return 'Please Enter your Email';
                  }
                  //else
                  return null;
                },
                controller: mailcontroller,
                decoration: InputDecoration(border: InputBorder.none, hintText: "Enter your Email",),),
                           ),
            SizedBox(
                       height: 20.0,
                     ),
                     Text(
                       "Password",
                       style: AppWidget.semiboldTextFieldStyle(),
                     ),
                     SizedBox(
                       height: 20.0,
                     ),
                Container(
                  padding: EdgeInsets.only(
                    left: 20.0,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xffecefe8),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextFormField(

                    obscureText: true,
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Please Enter your Password';
                      }
                      //else
                      return null;
                    },
                    controller: passwordcontroller,
                    decoration: InputDecoration(border: InputBorder.none, hintText: "Enter your Password",),),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password?",style: TextStyle(color: Color.fromARGB(135, 145, 47, 162),fontWeight: FontWeight.w500,fontSize: 18.0,),),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
            GestureDetector(
              onTap: (){
                if(_formkey.currentState!.validate()){
                  setState(() {

                    email= mailcontroller.text;
                    password= passwordcontroller.text;
                  });
                }
                ueserLogin();
              },
              child: Center(
                child: Container(
                               width: MediaQuery.of(context).size.width / 2,
                               padding: EdgeInsets.all(18),
                               decoration: BoxDecoration(
                                   color: Color.fromARGB(
                                     135,
                                     145,
                                     47,
                                     162,
                                   ),borderRadius: BorderRadius.circular(10),
                      
                               ),
                  child: Center(child: Text("LOGIN",style: TextStyle(color: Colors.white,fontSize: 18.0, fontWeight: FontWeight.bold, ),)),
                ),
              ),
            ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Don't have an account?",style: AppWidget.lightTextFieldStyle(),),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                      },
                      child: Text("Sign Up",style: TextStyle(color: Color.fromARGB(135, 145, 47, 162),fontWeight: FontWeight.w500,fontSize: 18.0,),)),
                ],
                )
                    
              ],
            ),
          ),
        ),
      ),
    );
  }
}

