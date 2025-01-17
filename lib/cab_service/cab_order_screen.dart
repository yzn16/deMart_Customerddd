import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emartconsumer/cab_service/cab_review_screen.dart';
import 'package:emartconsumer/cab_service/complain_screen.dart';
import 'package:emartconsumer/constants.dart';
import 'package:emartconsumer/main.dart';
import 'package:emartconsumer/model/CabOrderModel.dart';
import 'package:emartconsumer/services/FirebaseHelper.dart';
import 'package:emartconsumer/services/helper.dart';
import 'package:emartconsumer/theme/app_them_data.dart';
import 'package:emartconsumer/theme/round_button_fill.dart';
import 'package:flutter/material.dart';

import 'cab_order_detail_screen.dart';

class CabOrderScreen extends StatefulWidget {
  const CabOrderScreen({Key? key}) : super(key: key);

  @override
  State<CabOrderScreen> createState() => _CabOrderScreenState();
}

class _CabOrderScreenState extends State<CabOrderScreen> {
  late Future<List<CabOrderModel>> ordersFuture;
  final FireStoreUtils _fireStoreUtils = FireStoreUtils();
  List<CabOrderModel> ordersList = [];

  @override
  void initState() {
    super.initState();
    ordersFuture =
        _fireStoreUtils.getCabDriverOrders(MyAppState.currentUser!.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: FutureBuilder<List<CabOrderModel>>(
          future: ordersFuture,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(
                      AppThemeData.primary300,
                    ),
                  ),
                ),
              );
            }
            if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
              return Center(
                child: showEmptyState('No Previous Orders'.tr(), context),
              );
            } else {
              ordersList = snapshot.data!;
              return ListView.builder(
                  itemCount: ordersList.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) =>
                      buildOrderItem(ordersList[index]));
            }
          }),
    );
  }

  Widget buildOrderItem(CabOrderModel orderModel) {
    String totalAmount =
        "${amountShow(amount: orderModel.subTotal!.toString())}";

    return InkWell(
      onTap: () => push(
          context,
          CabOrderDetailScreen(
            orderModel: orderModel,
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: isDarkMode(context) ? AppThemeData.grey900 : AppThemeData.grey50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 32,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                orderModel.driver != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              height: 50,
                              width: 50,
                              imageUrl: getImageVAlidUrl(
                                  orderModel.driver!.profilePictureURL),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation(
                                    AppThemeData.primary300),
                              )),
                              errorWidget: (context, url, error) => ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    height: 50,
                                    width: 50,
                                    placeholderImage,
                                    fit: BoxFit.cover,
                                  )),
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          orderModel.driver!.firstName +
                                              " " +
                                              orderModel.driver!.lastName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          totalAmount,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AppThemeData.primary300),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderDate(orderModel.createdAt)
                                              .trim(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Container(
                                            width: 7,
                                            height: 7,
                                            decoration: const BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                        Text(
                                          orderModel.paymentStatus
                                              ? "Paid".tr()
                                              : "UnPaid".tr(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: orderModel.paymentStatus
                                                  ? Colors.green
                                                  : Colors.deepOrangeAccent),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),

                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/ic_pic_drop_location.png",
                      height: 80,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  orderModel.sourceLocationName.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  orderModel.destinationLocationName.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: orderModel.status == ORDER_STATUS_COMPLETED
                      ? true
                      : false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: RoundedButtonFill(
                            title: "Add Review".tr(),
                            color: AppThemeData.primary300,
                            textColor: AppThemeData.grey50,
                            onPress: () async {
                              push(context,
                                  CabReviewScreen(order: orderModel));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child:   RoundedButtonFill(
                            title: "Complain".tr(),
                            color: AppThemeData.primary300,
                            textColor: AppThemeData.grey50,
                            onPress: () async {
                              push(
                                  context, ComplainScreen(order: orderModel));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: Text(
                //     'Order status - ${orderModel.status}',
                //     style: TextStyle(color: Colors.grey.shade800,),
                //   ),
                // ),
                // const SizedBox(height: 16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Text(
                //       'Total:'.tr()+symbol+(double.parse(orderModel.subTotal!.toString()) - double.parse(orderModel.discount!.toString())+ double.parse(orderModel.tipValue!.toString()) + taxCalculation(orderModel)).toStringAsFixed(decimal),
                //       style: const TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  double taxCalculation(CabOrderModel orderModel) {
    double totalTax = 0.0;

    if (orderModel.taxType!.isNotEmpty) {
      if (orderModel.taxType == "percent") {
        totalTax = (double.parse(orderModel.subTotal.toString()) -
                double.parse(orderModel.discount.toString())) *
            double.parse(orderModel.tax.toString()) /
            100;
      } else {
        totalTax = double.parse(orderModel.tax.toString());
      }
    }
    return totalTax;
  }
}
