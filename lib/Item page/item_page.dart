import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturant_app/home/AppColors.dart';
import 'package:resturant_app/Customer/Cart/cart_page.dart';
import 'package:resturant_app/cubit/cubit.dart';
import 'package:resturant_app/cubit/states.dart';
import '../Customer/customer_page.dart';

class FoodDetail extends StatefulWidget {
  static double screenHeight = Get.context!.height;
  String image = "";
  String name = "";
  String price = "";
  String type = "";

  FoodDetail({
    required this.image,
    required this.name,
    required this.price,
    required this.type,
  });

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  bool _isToastDisplayed = false;
  int itemNumber = 1;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AddFoodToCartSuccessState && !_isToastDisplayed) {
          Fluttertoast.showToast(
              msg: "The item has been added to the cart",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            _isToastDisplayed = true;
          });
        }
        if (state is UpdateCartSuccessState && !_isToastDisplayed) {
          Fluttertoast.showToast(
              msg: "The number of the item in the cart has been updated",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            _isToastDisplayed = true;
          });
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  width: double.maxFinite,
                  height: 350,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.image))),
                ),
              ),
              Positioned(
                top: 45,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff89dad0)),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff89dad0)),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart_checkout),
                        onPressed: () {
                          AppCubit.get(context).listFoodCart = [];
                          AppCubit.get(context).getDataCart();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: (FoodDetail.screenHeight / 2.6),
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Table Number: ${tableNumberofCustomer}",
                              style: GoogleFonts.cairo(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainColor),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.name,
                              style: GoogleFonts.cairo(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: Container(
            height: 120,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Color.fromARGB(255, 230, 230, 230),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (itemNumber > 1) {
                            setState(() {
                              itemNumber--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove, color: AppColors.signColor),
                      ),
                      const SizedBox(width: 5),
                      Text('$itemNumber', style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            itemNumber++;
                          });
                        },
                        icon: Icon(Icons.add, color: AppColors.signColor),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    String uid = cubit.generateRandomString();
                    int totalPrice = int.parse(widget.price) * itemNumber;
                    String totalPriceString = totalPrice.toString();
                    if (checkExist(
                            AppCubit.get(context).listFoodCart, widget.name) !=
                        -1) {
                      itemNumber += (int.parse(
                                  AppCubit.get(context).listFoodCart[checkExist(
                                      AppCubit.get(context).listFoodCart,
                                      widget.name)][5]) /
                              int.parse(AppCubit.get(context).listFoodCart[
                                  checkExist(AppCubit.get(context).listFoodCart,
                                      widget.name)][6]))
                          .toInt();
                      int totalPriceB = 0;
                      totalPriceB += int.parse(widget.price) * itemNumber;
                      String totalPriceString = totalPriceB.toString();
                      AppCubit.get(context).updateCart(data: [
                        AppCubit.get(context).listFoodCart[checkExist(
                            AppCubit.get(context).listFoodCart,
                            widget.name)][0],
                        tableNumberofCustomer!,
                        widget.type,
                        widget.image,
                        widget.name,
                        totalPriceString,
                        widget.price
                      ]);
                    } else {
                      AppCubit.get(context).addFoodToCart(data: [
                        uid,
                        tableNumberofCustomer!,
                        widget.type,
                        widget.image,
                        widget.name,
                        totalPriceString,
                        widget.price
                      ]);
                    }
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(118, 247, 246, 244)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: Text(
                      //in this text it should be = (tiem price) * itemNum + " | Add to cart"
                      "${int.parse(widget.price) * itemNumber}\$ | Add to cart",
                      style: const TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

int checkExist(List<List<dynamic>> list, String name) {
  int index = -1;
  for (int i = 0; i < list.length; i++) {
    if (list[i][4] == name) {
      index = i;
      break;
    }
  }
  return index;
}
