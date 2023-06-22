import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturant_app/cubit/cubit.dart';
import 'package:resturant_app/cubit/states.dart';
import '../home/AppColors.dart';

class ShowReadyOrder extends StatefulWidget {
  const ShowReadyOrder({super.key});

  @override
  State<ShowReadyOrder> createState() => _ShowReadyOrderState();
}

class _ShowReadyOrderState extends State<ShowReadyOrder> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
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
                const SizedBox(width: 50),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Text(
                    'Total Price: \$ ${getTotalPrice(cubit.listFoodWaitersGuide)}',
                    style: GoogleFonts.cairo(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                const SizedBox(width: 50),
              ],
            ),
          ),
          //Text("Total Price:\$ ${getTotalPrice(cubit.listFoodWaitersGuide)}"),
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
                    Text(
                      'Order',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(width: 50)
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
                        itemCount: cubit.listFoodWaitersGuide.length,
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
                                    color: Color(0xff69c5df),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    boxShadow: [
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
                                          cubit.listFoodWaitersGuide[index][3]),
                                    )),
                              ),
                              //item details
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 13, right: 5),
                                  padding: EdgeInsets.only(left: 5, right: 10),
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
                                        cubit.listFoodWaitersGuide[index][4],
                                        style: GoogleFonts.cairo(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${cubit.listFoodWaitersGuide[index][2]}",
                                        style: GoogleFonts.cairo(
                                            fontSize: 12,
                                            color: AppColors.textColor),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${cubit.listFoodWaitersGuide[index][5]}\$",
                                              style: GoogleFonts.cairo(
                                                  fontSize: 17,
                                                  color: AppColors.priceColor),
                                            ),
                                            Text(
                                              "x${cubit.listFoodWaitersGuide[index][7]}",
                                              style: GoogleFonts.cairo(
                                                  fontSize: 17,
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
              ),
            ],
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
