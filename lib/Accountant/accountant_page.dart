import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturant_app/Accountant/show_ready_order.dart';
import 'package:resturant_app/home/AppColors.dart';
import 'package:resturant_app/cubit/cubit.dart';
import 'package:resturant_app/cubit/states.dart';

class Accountant extends StatefulWidget {
  const Accountant({super.key});

  @override
  State<Accountant> createState() => _AccountantState();
}

class _AccountantState extends State<Accountant> {
  @override
  void initState() {
    // TODO: implement initState
    AppCubit.get(context).getAllTablesOrders();
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
              'Ready Orders',
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
                  itemCount: AppCubit.get(context).tablesOrders.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        //item image..
                        Container(
                          margin: const EdgeInsets.only(bottom: 15, left: 10),
                          height: 80,
                          width: 80,
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
                                image: AssetImage("images/readyOrder.png"),
                              )),
                        ),
                        //item details
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              AppCubit.get(context).getDataWaiterGuide(
                                  tableNum: AppCubit.get(context)
                                      .tablesOrders[index]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowReadyOrder()));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(bottom: 15, right: 10),
                              padding: const EdgeInsets.only(left: 5),
                              height: 80,
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
                                        "Table Number: ${AppCubit.get(context).tablesOrders[index]}",
                                        style: GoogleFonts.cairo(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: IconButton(
                                      onPressed: () async {
                                        var cubit = AppCubit.get(context);
                                        await cubit.getDataWaiterGuide(
                                            tableNum:
                                                cubit.tablesOrders[index]);
                                        for (int i = 0;
                                            i <
                                                cubit.listFoodWaitersGuide
                                                    .length;
                                            i++) {
                                          cubit.deleteFromWaiterGuide(
                                              tableNum:
                                                  cubit.tablesOrders[index],
                                              uid: cubit.listFoodWaitersGuide[
                                                  index][1]);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.done_outline,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
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
