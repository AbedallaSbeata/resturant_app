import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturant_app/Customer/customer_page.dart';
import 'package:resturant_app/cubit/states.dart';

import '../../home/AppColors.dart';
import '../../cubit/cubit.dart';
import '../menu_page.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        int totalPrice = getTotalPrice(cubit.listFoodCart);
        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 45,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
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
                    //this container is temp
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff89dad0)),
                      child: IconButton(
                        icon: const Icon(Icons.restaurant_menu_rounded),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Menu()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 100,
                left: 15,
                right: 15,
                bottom: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cubit.listFoodCart.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              //item image..
                              Container(
                                margin:
                                    const EdgeInsets.only(bottom: 13, left: 5),
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                    color: const Color(0xff69c5df),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 184, 182, 182),
                                        blurRadius: 3.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          cubit.listFoodCart[index][3]),
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 13, right: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 110,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 184, 182, 182),
                                        blurRadius: 3.0,
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        cubit.listFoodCart[index][4],
                                        style: GoogleFonts.cairo(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        cubit.listFoodCart[index][2],
                                        style: GoogleFonts.cairo(
                                            fontSize: 12,
                                            color: AppColors.textColor),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${cubit.listFoodCart[index][5]}\$",
                                              style: GoogleFonts.cairo(
                                                  fontSize: 20,
                                                  color: AppColors.priceColor),
                                            ),
                                            Text(
                                              'x${int.parse(cubit.listFoodCart[index][5]) ~/ int.parse(cubit.listFoodCart[index][6])}',
                                              style: GoogleFonts.cairo(
                                                  fontSize: 20,
                                                  color: AppColors.paraColor),
                                            ),
                                          ])
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Text(
                    'Total: $totalPrice\$',
                    style: GoogleFonts.cairo(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    for (int index = 0;
                        index < cubit.listFoodCart.length;
                        index++) {
                      String uid = cubit.generateRandomString();
                      var list = cubit.listFoodCart[index];
                      DateTime now = DateTime.now();
                      String formattedDate = DateFormat('HH:mm:ss').format(now);
                      cubit.addFoodToChef(data: [
                        "$formattedDate#$tableNumberofCustomer",
                        uid,
                        list[2],
                        list[3],
                        list[4],
                        list[5],
                        list[6],
                        (int.parse(list[5]) ~/ int.parse(list[6])).toString(),
                        formattedDate
                      ]);
                    }
                    for (int index = 0;
                        index < cubit.listFoodCart.length;
                        index++) {
                      String uid = cubit.generateRandomString();
                      var list = cubit.listFoodCart[index];
                      cubit.addFoodToOrder(data: [
                        tableNumberofCustomer!,
                        uid,
                        list[2],
                        list[3],
                        list[4],
                        list[5],
                        list[6],
                        (int.parse(list[5]) ~/ int.parse(list[6])).toString()
                      ]);
                    }
                    for (int index = 0;
                        index < cubit.listFoodCart.length;
                        index++) {
                      var list = cubit.listFoodCart[index];
                      cubit.deleteFromCart(
                          tableNum: tableNumberofCustomer!, uid: list[0]);
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
                    child: const Text(
                      //in this text it should be = (tiem price) * itemNum + " | Add to cart"
                      "Check out",
                      style: TextStyle(color: Colors.white, fontSize: 17),
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

  int getTotalPrice(List<List<dynamic>> list) {
    int totalPrice = 0;
    for (int i = 0; i < list.length; i++) {
      totalPrice += int.parse(list[i][5]);
    }
    return totalPrice;
  }
}
