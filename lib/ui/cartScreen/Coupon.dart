// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:dotted_border/dotted_border.dart';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:uber_eats_consumer/constants.dart';
// import 'package:uber_eats_consumer/model/CouponModel.dart';
// import 'package:uber_eats_consumer/services/FirebaseHelper.dart';
// import 'package:uber_eats_consumer/services/helper.dart';
// import 'package:uber_eats_consumer/ui/cartScreen/CartScreen.dart';

// class CouponCodeScreen extends StatefulWidget {
//      final  per;
//   CouponCodeScreen(this.per, {Key? key}) : super(key: key);

//   @override
//   _CouponCodeScreenState createState() => _CouponCodeScreenState();
// }

// class _CouponCodeScreenState extends State<CouponCodeScreen> {

//   late Future<List<CouponModel>> coupon;
//   TextEditingController txt =TextEditingController();
//   FireStoreUtils _fireStoreUtils = FireStoreUtils();
//   var percentage,type;
//   @override
//   void initState() {
//     super.initState();
//    coupon =_fireStoreUtils.getAllCoupons();
//   }
//   @override
//   Widget build(BuildContext context) {
//     var _height = MediaQuery.of(context).size.height;
//     return Container(
//       padding: EdgeInsets.only(bottom: _height/3.6,left: 25,right: 25),
//         height: MediaQuery.of(context).size.height * 0.90,

//         decoration: BoxDecoration(

//             color: Colors.transparent,
//             border: Border.all(style: BorderStyle.none)),
//         child:
//         FutureBuilder<List<CouponModel>>(
//           future: coupon,
//           initialData: [],
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting)
//               return Container(
//                 child: Center(
//                   child: CircularProgressIndicator.adaptive(
//                     valueColor: AlwaysStoppedAnimation(AppThemeData.primary300),
//                   ),
//                 ),
//               );
//             if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
//               return Center(
//                 child: showEmptyState(
//                     'No Previous Orders'.tr(), 'Let\'s orders food!'.tr()),
//               );
//             } else {
//               // coupon = snapshot.data as Future<List<CouponModel>> ;
//               return
//       Column(children: [

//           InkWell(
//               onTap: () => Navigator.pop(context),
//               child: Container(
//                 height: 45,
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white, width: 0.3),
//                     color: Colors.transparent,
//                     shape: BoxShape.circle),

//                 // radius: 20,
//                 child: Center(
//                   child: Icon(
//                     Icons.close,
//                     color: Colors.white,size: 28,
//                   ),
//                 ),
//               )),
//           SizedBox(
//             height: 25,
//           ),
//           Expanded(child:
//           Container(

//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
//             color: Colors.white
//             ),
//             alignment: Alignment.center,
//             child: Column(children: [
//               Container( padding: EdgeInsets.only(top: 40),
//                 child:
//                 Image(image: AssetImage('assets/images/redeem_coupon.png')
//                 ,width: 100,)
//               ),

//               Container(padding: EdgeInsets.only(top: 30),
//                 child:
//               Text('Redeem Your Coupons',
//               style: TextStyle(),
//               )),

//               Container(padding: EdgeInsets.only(top: 30),
//                 child:
//               Text('Enter your Voucher or Coupon code to \n'
//               'get the discount on all over the budget',
//               style: TextStyle(),
//               )),
//                Container(padding: EdgeInsets.only(left: 20,right: 20,top: 40),
//                 height: 120,
//                  child:
//               DottedBorder(borderType: BorderType.RRect,
//               radius: Radius.circular(12),
//                  dashPattern: [4,4],

//                 child: ClipRRect(
//     borderRadius: BorderRadius.all(Radius.circular(12)),
//     child: Center(child:
//               TextFormField(
//                   textAlign: TextAlign.center,
//                   controller: txt,
//               // textAlignVertical: TextAlignVertical.center,
//               decoration: InputDecoration(
//               border: InputBorder.none,
//                hintText: 'Write Coupon Code',
//               //  hintTextDirection: TextDecoration.lineThrough
//               // contentPadding: EdgeInsets.only(left: 80,right: 30),
//               ),

//               ))
//                 ) )),
//             Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 40),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 15),
//            backgroundColor: AppThemeData.primary300,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           onPressed: () => {

//             setState(() {
//               // print(widget.percentage);
//       Navigator.pop(context);
//  })
//           },
//           child: Text(
//             'REDEEM NOW',
//             style: TextStyle(
//                 color: isDarkMode(context) ? Colors.black : Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16),
//           ),
//         ),
//       ),
//             ],),
//           )
//           ),
//           Container(height: 0,
//             child:
//           ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {

//            return buildcouponItem(snapshot.data![index]);

//                   })),
//         ]);

//               }
//           }
//   ));
//   }

// buildcouponItem(CouponModel couponModel){

// //   var time = DateTime.fromMicrosecondsSinceEpoch(couponModel.exipreAt.microsecondsSinceEpoch);
// // //  print(txt.text);
// //  print(time);
// //  var nowtime =DateTime.now();
// // //   print(couponModel.code);
// // print(nowtime.compareTo(time));
// //  print(couponModel.exipreAt);
//       if(txt.text == couponModel.code || couponModel.isEnable == true ||
//       couponModel.discountType == 'Percent'
//        ){
//           percentage = couponModel.discount;
//         print(couponModel.discount);
//         // widget.per =couponModel.discount;
//          }
//          else if(couponModel.discountType == 'fixed')
//          { type = couponModel.discount;

//           //  print(couponModel.discount);
//          }
//          else{
//            print("No");
//          }

//   return Text('');
// }

// }
