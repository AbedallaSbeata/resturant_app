import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturant_app/cubit/cubit.dart';
import 'package:resturant_app/cubit/states.dart';
import '../home/AppColors.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
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
                    Text(
                      'My Orders',
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
                child: cubit.listFoodOrder.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: cubit.listFoodOrder.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    //item image..
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 13, left: 5),
                                      height: 110,
                                      width: 110,
                                      decoration: BoxDecoration(
                                          color: AppColors.blueColor,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20)),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 184, 182, 182),
                                              blurRadius: 3.0,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                cubit.listFoodOrder[index][3]),
                                          )),
                                    ),
                                    //item details
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 13, right: 5),
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 10),
                                        height: 110,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 184, 182, 182),
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
                                              cubit.listFoodOrder[index][4],
                                              style: GoogleFonts.cairo(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              cubit.listFoodOrder[index][2],
                                              style: GoogleFonts.cairo(
                                                  fontSize: 12,
                                                  color: AppColors.textColor),
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${cubit.listFoodOrder[index][5]}\$",
                                                    style: GoogleFonts.cairo(
                                                        fontSize: 20,
                                                        color: AppColors
                                                            .priceColor),
                                                  ),
                                                  Text(
                                                    'x${cubit.listFoodOrder[index][7]}',
                                                    style: GoogleFonts.cairo(
                                                        fontSize: 20,
                                                        color: AppColors
                                                            .paraColor),
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
                      )
                    : Center(
                        child: Text(
                          'There are no orders',
                          style: GoogleFonts.cairo(
                              fontSize: 20, color: AppColors.titleColor),
                        ),
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
