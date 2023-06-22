import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturant_app/cubit/cubit.dart';
import 'package:resturant_app/Customer/menu_page.dart';
import 'package:resturant_app/cubit/states.dart';

class Home extends StatelessWidget {
  void fetchData(context) {
    AppCubit.get(context).getDataAppetizers();
    AppCubit.get(context).getDataSalads();
    AppCubit.get(context).getDataMeals();
    AppCubit.get(context).getDataDrinks();
    AppCubit.get(context).getDataOffers();
    AppCubit.get(context).getDataCart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadiusDirectional.all(Radius.circular(5)),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      fetchData(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Menu(
                                  previousPageWidget: Home(),
                                )),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Go to Menu",
                      style: GoogleFonts.notoKufiArabic(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
