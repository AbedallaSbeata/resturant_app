import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../home/AppColors.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPage();
}

class _EditPage extends State<EditPage> {
  int i = 0;
  PageController pageController = PageController(viewportFraction: 0.85);
  List<String> categories = ["Meals", "Salads", "Drinks", "Appetizers"];
  var currPageindex = 0.0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currPageindex = pageController.page!;
      });
    });
  }

  void fetchData(context) {
    AppCubit.get(context).getDataAppetizers();
    AppCubit.get(context).getDataSalads();
    AppCubit.get(context).getDataMeals();
    AppCubit.get(context).getDataDrinks();
    AppCubit.get(context).getDataOffers();
  }

  //to manage the memory
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    var promotionsNum =
        cubit.listFoodOffers.isNotEmpty ? cubit.listFoodOffers.length : 1;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                fetchData(context);
              },
            ),
            centerTitle: true,
            title: Text(
              'Editing',
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
              //Promotions
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 250,
                child: PageView.builder(
                    controller: pageController,
                    itemCount: promotionsNum,
                    itemBuilder: (context, position) {
                      return buildPagePromotion(
                          position,
                          cubit.listFoodOffers.isNotEmpty
                              ? cubit.listFoodOffers[position][1]
                              : '');
                    }),
              ),
              DotsIndicator(
                dotsCount: promotionsNum,
                position: currPageindex.toInt(),
                decorator: DotsDecorator(
                  activeColor: const Color(0xff89dad0),
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              //Categories..
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map(
                    (category) {
                      int index = categories.indexOf(category);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            i = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 15),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: i == index
                                ? Border.all(
                                    color: AppColors.mainColor, width: 2)
                                : null,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 184, 182, 182),
                                blurRadius: 5.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff89dad0),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(height: 15),
              showFood(i),
            ],
          )),
        );
      },
    );
  }

  Widget buildPagePromotion(int index, String image) {
    var cubit = AppCubit.get(context);
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          height: 220,
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 184, 182, 182),
                blurRadius: 5.0,
                offset: Offset(0, 5),
              ),
            ],
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(image),
            ),
            borderRadius: BorderRadius.circular(30),
            color: AppColors.blueColor,
          ),
        ),
        if (cubit.listFoodOffers.isNotEmpty)
          IconButton(
            onPressed: () {
              if (cubit.listFoodOffers.isNotEmpty) {
                cubit.deleteImageOffer(data: [
                  cubit.listFoodOffers[index][0],
                  cubit.listFoodOffers[index][1]
                ]);
                AppCubit.get(context).getDataOffers();
              }
            },
            icon: const Icon(
              Icons.delete,
              size: 40,
              color: Colors.red,
            ),
          )
      ],
    );
  }

  Widget showFood(int i) {
    var cubit = AppCubit.get(context);
    switch (i) {
      case 0:
        return buildFoodList(cubit.listFoodMeals);
      case 1:
        return buildFoodList(cubit.listFoodSalads);
      case 2:
        return buildFoodList(cubit.listFoodDrinks);
      case 3:
        return buildFoodList(cubit.listFoodAppetizers);
      default:
        return Container();
    }
  }

  Widget buildFoodList(List<List<dynamic>> foodList) {
    int itemCount = foodList.length;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15, bottom: 13),
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                color: AppColors.blueColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 184, 182, 182),
                    blurRadius: 3.0,
                    offset: Offset(0, 5),
                  ),
                ],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(foodList[index][2]),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 15, bottom: 13),
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 184, 182, 182),
                      blurRadius: 3.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        foodList[index][3],
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            foodList[index][4],
                            style: TextStyle(
                              color: AppColors.priceColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => editData(
                                        type: categories[i],
                                        uid: foodList[index][0],
                                        oldImage: foodList[index][2],
                                        oldPrice: foodList[index][4],
                                        oldName: foodList[index][3],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: AppColors.blueColor,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.zero,
                              child: IconButton(
                                onPressed: () {
                                  AppCubit.get(context).deleteData(
                                    type: foodList[index][1],
                                    uid: foodList[index][0],
                                  );
                                  AppCubit.get(context).getDataMeals();
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget editData(
      {required String uid,
      required String type,
      required String oldImage,
      required String oldName,
      required String oldPrice}) {
    var cubit = AppCubit.get(context);
    var price = TextEditingController();
    var name = TextEditingController();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetImagesSuccessAppState) {
          AppCubit.get(context).uploadProfileImage();
        }
      },
      builder: (context, state) {
        name.text = oldName;
        price.text = oldPrice;
        cubit.profileImage = null;
        bool acceptanceCondition = name.text.length < 25 &&
            name.text.isNotEmpty &&
            price.text.isNum &&
            price.text.isNotEmpty;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Edit Food Detials',
              style: GoogleFonts.poppins(fontSize: 22, color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
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
                      ? GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image(
                              image: NetworkImage(oldImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () {
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
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextField(
                        controller: name,
                        decoration: InputDecoration(
                          hintText: 'Enter the New name',
                          labelText: 'Meal Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: price,
                        decoration: InputDecoration(
                          hintText: 'Enter the new price ',
                          labelText: 'Meal price',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (acceptanceCondition) {
                      AppCubit.get(context).updateData(data: [
                        uid,
                        type,
                        cubit.image,
                        name.text,
                        price.text
                      ]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditPage()));
                      fetchData(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('The item has been updated..',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.white)),
                          backgroundColor: Colors.green,
                        ),
                      );
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
                    'Update',
                    style: GoogleFonts.cairo(fontSize: 20, color: Colors.white),
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
