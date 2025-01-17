import 'package:easy_localization/easy_localization.dart';
import 'package:emartconsumer/AppGlobal.dart';
import 'package:emartconsumer/model/CabOrderModel.dart';
import 'package:emartconsumer/services/FirebaseHelper.dart';
import 'package:emartconsumer/services/helper.dart';
import 'package:emartconsumer/theme/app_them_data.dart';
import 'package:emartconsumer/theme/round_button_fill.dart';
import 'package:flutter/material.dart';

class ComplainScreen extends StatefulWidget {
  final CabOrderModel order;

  const ComplainScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  final title = TextEditingController();
  final comment = TextEditingController();

  @override
  void initState() {
    getComplain();
    super.initState();
  }

  getComplain() async {
    await FireStoreUtils().getRideComplainData(widget.order.id).then((value) {
      if (value != null) {
        setState(() {
          title.text = value['title'];
          comment.text = value['description'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? AppThemeData.surfaceDark : AppThemeData.surface,
      appBar: AppGlobal.buildSimpleAppBar(context, "Complain".tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(
                hintText: 'Title'.tr(),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                hintStyle: const TextStyle(color: Color(0XFF8A8989)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppThemeData.primary300),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFFB1BCCA)),
                  // borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: comment,
              decoration: InputDecoration(
                hintText: 'Type Description....'.tr(),
                hintStyle: const TextStyle(color: Color(0XFF8A8989)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppThemeData.primary300),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFFB1BCCA)),
                  // borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedButtonFill(
              title: "Complain".tr(),
              color: AppThemeData.primary300,
              textColor: AppThemeData.grey50,
              onPress: () async {
                await showProgress("Please wait...".tr(), false);
                await FireStoreUtils().getRideComplain(widget.order.id).then((value) async {
                  if (value == false) {
                    hideProgress();
                    await FireStoreUtils()
                        .setRideComplain(
                        description: comment.text,
                        title: title.text,
                        customerID: widget.order.authorID,
                        customerName: "${widget.order.author.firstName} ${widget.order.author.lastName}",
                        driverID: widget.order.driverID.toString(),
                        driverName: "${widget.order.driver!.firstName} ${widget.order.driver!.lastName}",
                        orderId: widget.order.id)
                        .then((value) {
                      hideProgress();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Builder(builder: (context) {
                          return const Text(
                            "Your complaint has been submitted to admin ",
                          ).tr();
                        }),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ));
                    });
                  } else {
                    hideProgress();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Builder(builder: (context) {
                        return Text(
                          "Your complaint is already submitted".tr(),
                        ).tr();
                      }),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ));
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
