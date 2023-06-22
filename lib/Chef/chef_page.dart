import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturant_app/Chef/show_pending_order.dart';
import 'package:resturant_app/home/AppColors.dart';
import 'package:resturant_app/cubit/cubit.dart';
import 'package:resturant_app/cubit/states.dart';

class Chef extends StatefulWidget {
  const Chef({super.key});

  @override
  State<Chef> createState() => _ChefState();
}

class _ChefState extends State<Chef> {
  @override
  void initState() {
    // TODO: implement initState
    AppCubit.get(context).getAllTables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Pending Orders',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, AppColors.mainColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.only(top: 15),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: AppCubit.get(context).tables.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        //item image..
                        Container(
                          margin: const EdgeInsets.only(bottom: 15, left: 10),
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                              color: Color(0xff69c5df),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 184, 182, 182),
                                  blurRadius: 3.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("images/pendingOrder.png"),
                              )),
                        ),
                        //item details
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              AppCubit.get(context).getDataChef(
                                  tableNumber:
                                      AppCubit.get(context).dates[index] +
                                          "#" +
                                          AppCubit.get(context).tables[index]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowOrder()));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(bottom: 15, right: 10),
                              padding: const EdgeInsets.only(left: 8),
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 184, 182, 182),
                                    blurRadius: 3.0,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Table Number: ${AppCubit.get(context).tables[index]}",
                                        style: GoogleFonts.cairo(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        AppCubit.get(context).dates[index],
                                        style: GoogleFonts.cairo(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: IconButton(
                                        onPressed: () async {
                                          var cubit = AppCubit.get(context);
                                          await cubit.getDataChef(
                                              tableNumber: AppCubit.get(context)
                                                      .dates[index] +
                                                  "#" +
                                                  AppCubit.get(context)
                                                      .tables[index]);
                                          // for(int index = 0; index < AppCubit.get(context).listFoodChef.length; index++) {
                                          //   String uid = AppCubit.get(context).generateRandomString();
                                          //   var list = AppCubit.get(context).listFoodChef[index];
                                          //   AppCubit.get(context).AddFoodToWaiterGuide(data: [list[0],uid,list[2],list[3],list[4],list[5],list[6],((int.parse(list[5]))/(int.parse(list[6]))).toInt().toString()]);
                                          // }
                                          AppCubit.get(context).deleteFromChef(
                                              tableNum: AppCubit.get(context)
                                                      .dates[index] +
                                                  "#" +
                                                  AppCubit.get(context)
                                                      .tables[index]);
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Table ${AppCubit.get(context).tables[index]} order has been processed",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        },
                                        icon: const Icon(
                                          Icons.done_outline,
                                          color: Colors.green,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}
