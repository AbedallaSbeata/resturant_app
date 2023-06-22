import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant_app/home/AppColors.dart';
import 'package:resturant_app/Customer/my_order.dart';
import 'package:resturant_app/cubit/cubit.dart';
import 'package:resturant_app/cubit/states.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:resturant_app/home/home_page.dart';

import '../Item page/item_page.dart';
import 'Cart/cart_page.dart';
import 'customer_page.dart';

List<String> categories = ["Meals", "Salads", "Drinks", "Appetizers"];

String fixedPromotionImage =
    'https://scontent.fgza9-1.fna.fbcdn.net/v/t1.6435-9/43301665_1911040678950111_8320290008216895488_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=2c4854&_nc_ohc=YwBydT-A4e0AX9Na-XE&_nc_ht=scontent.fgza9-1.fna&oh=00_AfDgNiU2DWFxFg_-XM1OZUNIbnaf9BOe-j-I3iPkorFrkw&oe=648203EA';

class Menu extends StatefulWidget {
  final Widget? previousPageWidget;
  const Menu({Key? key, this.previousPageWidget}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  PageController pageController = PageController(viewportFraction: 0.85);

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

  //to manage the memory
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  int i = 0;
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    var promotionsNum =
        cubit.listFoodOffers.isNotEmpty ? cubit.listFoodOffers.length : 1;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 90,
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff89dad0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "Do you want to logout and finish all your orders?",
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "No",
                                        style: GoogleFonts.cairo(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await cubit.getDataOrder();

                                        for (int index = 0;
                                            index < cubit.listFoodOrder.length;
                                            index++) {
                                          String uid =
                                              cubit.generateRandomString();
                                          var list = cubit.listFoodOrder[index];
                                          cubit.addFoodToWaiterGuide(data: [
                                            list[0],
                                            uid,
                                            list[2],
                                            list[3],
                                            list[4],
                                            list[5],
                                            list[6],
                                            ((int.parse(list[5])) ~/
                                                    (int.parse(list[6])))
                                                .toString()
                                          ]);
                                        }
                                        for (int index = 0;
                                            index < cubit.listFoodOrder.length;
                                            index++) {
                                          var list = cubit.listFoodOrder[index];
                                          cubit.deleteFromOrder(
                                            tableNum: tableNumberofCustomer!,
                                            uid: list[1],
                                          );
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Home(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Yes",
                                        style: GoogleFonts.cairo(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        "Menu",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xff89dad0),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.timer),
                              onPressed: () {
                                cubit.listFoodOrder = [];
                                cubit.getDataOrder();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyOrder(),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xff89dad0),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.shopping_cart),
                              onPressed: () {
                                cubit.listFoodCart = [];
                                cubit.getDataCart();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CartPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 250,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: promotionsNum,
                    itemBuilder: (context, position) {
                      return buildPagePromotion(position);
                    },
                  ),
                ),
                DotsIndicator(
                  dotsCount: promotionsNum,
                  position: currPageindex.toInt(),
                  decorator: DotsDecorator(
                    activeColor: const Color(0xff89dad0),
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
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
                showFood(i),
              ],
            ),
          ),
        );
      },
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
                : NetworkImage(fixedPromotionImage)),
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
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FoodDetail(
                                  type: foodList[index][1],
                                  image: foodList[index][2],
                                  name: foodList[index][3],
                                  price: foodList[index][4],
                                )));
                  });
                },
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
            ),
          ],
        );
      },
    );
  }
}
