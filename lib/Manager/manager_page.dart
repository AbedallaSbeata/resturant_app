import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Customer/menu_page.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../home/AppColors.dart';
import 'add_data.dart';
import 'add_offers.dart';
import 'edit_page.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({super.key});

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var currPageindex = 0.0;
  int i = 0;
  String fixedPromotionImage =
      'https://scontent.fgza9-1.fna.fbcdn.net/v/t1.6435-9/43301665_1911040678950111_8320290008216895488_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=2c4854&_nc_ohc=YwBydT-A4e0AX9Na-XE&_nc_ht=scontent.fgza9-1.fna&oh=00_AfDgNiU2DWFxFg_-XM1OZUNIbnaf9BOe-j-I3iPkorFrkw&oe=648203EA';

  void fetchData(context) {
    AppCubit.get(context).getDataAppetizers();
    AppCubit.get(context).getDataSalads();
    AppCubit.get(context).getDataMeals();
    AppCubit.get(context).getDataDrinks();
    AppCubit.get(context).getDataOffers();
  }

  @override
  void initState() {
    fetchData(context);
    super.initState();
    pageController.addListener(() {
      setState(() {
        currPageindex = pageController.page!;
      });
    });
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Menu',
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
            drawer: Drawer(
              width: 250,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 60, left: 15),
                    height: 150,
                    decoration: BoxDecoration(color: AppColors.mainColor),
                    child: Text(
                      'Manager',
                      style: GoogleFonts.cairo(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_box_outlined),
                    title: const Text('Add Food'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddData()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_box_outlined),
                    title: const Text('Add Offers'),
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddOffers()));
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('Update/Delete'),
                    onTap: () {
                      fetchData(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditPage()));
                    },
                  ),
                ],
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
                          return buildPagePromotion(position);
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
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 20, bottom: 15),
                    child: const Row(
                      children: [
                        Text("Categories",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
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
                                  horizontal: 8, vertical: 5),
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
                  const SizedBox(height: 20),
                  showFood(i),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPagePromotion(int index) {
    var cubit = AppCubit.get(context);
    return Container(
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
          image: cubit.listFoodOffers.isNotEmpty
              ? NetworkImage(cubit.listFoodOffers[index][1])
              : NetworkImage(fixedPromotionImage),
        ),
        borderRadius: BorderRadius.circular(30),
        color: AppColors.blueColor,
      ),
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
                      bottomLeft: Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 184, 182, 182),
                      blurRadius: 3.0,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, bottom: 50),
                      child: Text(
                        foodList[index][3],
                        style: GoogleFonts.cairo(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 15, top: 50),
                      child: Text(
                        '${foodList[index][4]}\$',
                        style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.priceColor),
                      ),
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
}
