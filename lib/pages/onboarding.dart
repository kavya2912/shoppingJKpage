import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
   const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xffecefe8),
      body: Container(
        margin:  EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("images/Bidriware_-remo.png",
              fit: BoxFit.cover,
             //  height: 450,
            //  width: 500,
            ),
     Padding(
               // padding: EdgeInsets.all(8.0),
               padding: EdgeInsets.only(left: 30.0),
               child: Text(
                 'Explore\n The Best\n Artstic Products',
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 35.00,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ),
              SizedBox(
               height: 10.0,
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 Container(
                   margin:  EdgeInsets.only(
                     right: 20.0,
                   ),
                   padding:  EdgeInsets.all(30.0),
                   decoration:  BoxDecoration(
                       color: Colors.black, shape: BoxShape.circle
                     //  borderRadius: BorderRadius.circular(120),
                   ),
                   child:  Text(
                     "Next",
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 20.00,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
     );
   }
 }

//           ],
//         ),
//       ),
//     );
//
//   }
// }

// class Onboarding extends StatefulWidget {
//   const Onboarding({super.key});
//
//   @override
//   State<Onboarding> createState() => _OnboardingState();
// }
//
// class _OnboardingState extends State<Onboarding> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffecefe8),
//       body: Container(
//         margin: const EdgeInsets.only(
//           top: 40.0,
//           // left: 20.0,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               "images/Rajput.jpg",
//              // width: 400,
//               height: 400,
//             ),
//             const Padding(
//               // padding: EdgeInsets.all(8.0),
//               padding: EdgeInsets.only(left: 30.0),
//               child: Text(
//                 'Explore\n The Best\n Artstic Products',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 40.00,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(
//                     right: 20.0,
//                   ),
//                   padding: const EdgeInsets.all(20.0),
//                   decoration: const BoxDecoration(
//                       color: Colors.black, shape: BoxShape.circle
//                     //  borderRadius: BorderRadius.circular(120),
//                   ),
//                   child: const Text(
//                     "Next",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.00,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
