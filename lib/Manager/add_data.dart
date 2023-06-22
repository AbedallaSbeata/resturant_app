import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturant_app/Manager/manager_page.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../home/AppColors.dart';

class AddData extends StatefulWidget {
  const AddData({Key? key}) : super(key: key);

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    var name = TextEditingController();
    var price = TextEditingController();
    cubit.profileImage = null;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetImagesSuccessAppState) {
          AppCubit.get(context).uploadProfileImage();
        }
        if (state is CreateFoodSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added successfully..',
                  style:
                      GoogleFonts.poppins(fontSize: 15, color: Colors.white)),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is CreateFoodErrorState) {
          Fluttertoast.showToast(
              msg: 'Error adding food..', backgroundColor: Colors.red);
        }
      },
      builder: (context, state) {
        bool acceptanceCondition = name.text.length < 25 &&
            name.text.isNotEmpty &&
            int.tryParse(price.text) != null &&
            price.text.isNotEmpty &&
            cubit.image.isNotEmpty;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  AppCubit.get(context).getDataOffers();
                  AppCubit.get(context).getDataAppetizers();
                  AppCubit.get(context).getDataSalads();
                  AppCubit.get(context).getDataMeals();
                  AppCubit.get(context).getDataDrinks();
                });
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Add Food',
              style: GoogleFonts.poppins(fontSize: 22, color: Colors.white),
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (state is UploadImagesLoadingAppState)
                  const LinearProgressIndicator(),
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 10),
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border:
                          Border.all(color: AppColors.iconColor2, width: 2.0)),
                  child: cubit.profileImage == null
                      ? IconButton(
                          key: const ValueKey("imageFood"),
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: AppColors.iconColor2,
                          ),
                          onPressed: () {
                            cubit.getProfileImage();
                          },
                        )
                      : GestureDetector(
                          key: const ValueKey("imageFood"),
                          onTap: () {
                            cubit.getProfileImage();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(
                              cubit.profileImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextField(
                        key: const ValueKey("nameFood"),
                        controller: name,
                        decoration: InputDecoration(
                          hintText: 'Enter the name ',
                          labelText: 'Meal Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        key: const ValueKey("priceFood"),
                        decoration: InputDecoration(
                          hintText: 'Enter the price ',
                          labelText: 'Meal price',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        controller: price,
                      ),
                    ],
                  ),
                ),
                cubit.dropDownButtonWidget(),
                const SizedBox(height: 15),
                MaterialButton(
                  key: const ValueKey("addFood"),
                  onPressed: () {
                    String uid = cubit.generateRandomString();
                    if (acceptanceCondition) {
                      AppCubit.get(context).adminAdd(data: [
                        uid,
                        cubit.dropdownvalue,
                        cubit.image,
                        name.text,
                        price.text
                      ]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManagerPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Input error..',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.white)),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: AppColors.iconColor2, width: 1.0),
                  ),
                  color: AppColors.mainColor,
                  child: Text(
                    'Add',
                    style: GoogleFonts.cairo(fontSize: 19, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
