import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturant_app/Accountant/accountant_page.dart';
import 'package:resturant_app/Chef/chef_page.dart';
import 'package:resturant_app/Customer/customer_page.dart';
import 'package:resturant_app/Manager/manager_page.dart';

import '../cubit/cubit.dart';

class StartApp extends StatelessWidget {
  var usernameController = TextEditingController();

  void fetchData(context) {
    AppCubit.get(context).getDataAppetizers();
    AppCubit.get(context).getDataSalads();
    AppCubit.get(context).getDataMeals();
    AppCubit.get(context).getDataDrinks();
    AppCubit.get(context).getDataOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadiusDirectional.all(Radius.circular(5)),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (usernameController.text == "manager") {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManagerPage()),
                          (route) => false,
                        );
                        fetchData(context);
                      } else if (usernameController.text == "customer") {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Customer()),
                          (route) => false,
                        );
                        fetchData(context);
                      } else if (usernameController.text == "chef") {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Chef()),
                          (route) => false,
                        );
                      } else if (usernameController.text == "accountant") {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Accountant()),
                          (route) => false,
                        );
                      }
                    },
                    child: Text(
                      "Send",
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Username:",
                    hintStyle: GoogleFonts.tajawal(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
