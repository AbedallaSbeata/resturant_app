import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../home/AppColors.dart';

class AddOffers extends StatefulWidget {
  const AddOffers({super.key});

  @override
  State<AddOffers> createState() => _AddOffersState();
}

class _AddOffersState extends State<AddOffers> {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetImagesSuccessAppState) {
          AppCubit.get(context).uploadProfileImage();
        }
        if (state is SetImagesOffersSuccessAppState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Added successfully..',
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                AppCubit.get(context).getDataOffers();
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Add Offers',
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
          body: Column(
            children: [
              if (state is UploadImagesLoadingAppState)
                const LinearProgressIndicator(),
              Container(
                margin: const EdgeInsets.only(
                    top: 50, bottom: 30, left: 20, right: 20),
                height: 220,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: AppColors.iconColor2, width: 2.0)),
                child: cubit.profileImage == null
                    ? IconButton(
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
              MaterialButton(
                minWidth: 100,
                height: 40,
                onPressed: () {
                  if (cubit.image.isNotEmpty) {
                    String uid = cubit.generateRandomString();
                    AppCubit.get(context).setOffers(data: [uid, cubit.image]);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Input error..'),
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
            ],
          ),
        );
      },
    );
  }
}
