import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resturant_app/Customer/customer_page.dart';
import 'package:resturant_app/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Manager/AddFoodModel.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(initialAppState());
  static AppCubit get(context) => BlocProvider.of(context);

  List<List<dynamic>> listFoodSalads = [];
  List<List<dynamic>> listFoodMeals = [];
  List<List<dynamic>> listFoodDrinks = [];
  List<List<dynamic>> listFoodAppetizers = [];
  List<List<dynamic>> listFoodOffers = [];
  List<List<dynamic>> listFoodCart = [];
  List<List<dynamic>> listFoodOrder = [];
  List<List<dynamic>> listFoodChef = [];
  List<List<dynamic>> listFoodWaitersGuide = [];
  List<dynamic> tables = [];
  List<dynamic> dates = [];
  List<dynamic> tablesOrders = [];
  Future<void> getAllTables() async {
    tables = [];
    dates = [];
    emit(getAllTablesLoadingState());
    await FirebaseFirestore.instance.collection('Chef').get().then((value) {
      for (var element in value.docs) {
        List<String> splits = (element.id).split("#");
        tables.add(splits[1]);
        dates.add(splits[0]);
        splits = [];
      }
      emit(getAllTablesSuccessState());
    }).catchError((error) {
      emit(getAllTablesErrorState());
    });
  }

  Future<void> getAllTablesOrders() async {
    tablesOrders = [];
    emit(getAllTablesWaitersLoadingState());
    await FirebaseFirestore.instance
        .collection('Waiter Guide')
        .get()
        .then((value) {
      for (var element in value.docs) {
        tablesOrders.add(element.id);
      }
      emit(getAllTablesWaitersSuccessState());
    }).catchError((error) {
      emit(getAllTablesWaitersErrorState());
    });
  }

  void adminAdd({
    required List<String> data,
  }) {
    emit(AddFoodLoadingState());
    foodCreate(
      data: data,
    );
  }

  void foodCreate({
    required List<String> data,
  }) {
    AddFoodModel model = AddFoodModel(
      data: data,
    );
    FirebaseFirestore.instance
        .collection(data[1])
        .doc(data[0])
        .set(model.toMap())
        .then((value) {
      emit(CreateFoodSuccessState());
    }).catchError((error) {
      emit(CreateFoodErrorState());
    });
  }

  void addFoodToCart({
    required List<String> data,
  }) {
    AddFoodModel model = AddFoodModel(
      data: data,
    );
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(data[1]) // data[1] = table number
        .collection('items')
        .doc(data[0]) // uid
        .set(model.toMap())
        .then((value) {
      emit(AddFoodToCartSuccessState());
      getDataCart();
    }).catchError((error) {
      emit(AddFoodToCartErrorState());
    });
  }

  void getDataCart() {
    listFoodCart = [];
    emit(GetDataCartLoadingState());
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(tableNumberofCustomer)
        .collection('items')
        .get()
        .then((value) {
      for (int i = 0; i < value.size; i++) {
        listFoodCart.add(value.docs.elementAt(i).data().values.elementAt(0));
      }
      emit(GetDataCartSuccessState());
    }).catchError((error) {
      emit(GetDataCartErrorState());
    });
  }

  Future<void> getDataChef({
    required String tableNumber,
  }) async {
    listFoodChef = [];
    emit(GetDataChefLoadingState());
    await FirebaseFirestore.instance
        .collection('Chef')
        .doc(tableNumber)
        .collection('items')
        .get()
        .then((value) {
      for (int i = 0; i < value.size; i++) {
        listFoodChef.add(value.docs.elementAt(i).data().values.elementAt(0));
      }
      emit(GetDataChefSuccessState());
    }).catchError((error) {
      emit(GetDataChefErrorState());
    });
  }

  void getDataSalads() {
    listFoodSalads = [];
    emit(GetDataSaladsLoadingState());
    FirebaseFirestore.instance.collection('Salads').get().then((value) {
      for (int i = 0; i < value.size; i++) {
        listFoodSalads.add(value.docs.elementAt(i).data().values.elementAt(0));
      }

      emit(GetDataSaladsSuccessState());
    }).catchError((error) {
      emit(GetDataSaladsErrorState());
    });
  }

  void getDataDrinks() {
    listFoodDrinks = [];
    emit(GetDataDrinksLoadingState());
    FirebaseFirestore.instance.collection('Drinks').get().then((value) {
      for (int i = 0; i < value.size; i++) {
        listFoodDrinks.add(value.docs.elementAt(i).data().values.elementAt(0));
      }
      emit(GetDataDrinksSuccessState());
    }).catchError((error) {
      emit(GetDataDrinksErrorState());
    });
  }

  void getDataMeals() {
    listFoodMeals = [];
    emit(GetDataMealsLoadingState());
    FirebaseFirestore.instance.collection('Meals').get().then((value) {
      for (int i = 0; i < value.size; i++) {
        listFoodMeals.add(value.docs.elementAt(i).data().values.elementAt(0));
      }
      emit(GetDataMealsSuccessState());
    }).catchError((error) {
      emit(GetDataMealsErrorState());
    });
  }

  void getDataAppetizers() {
    listFoodAppetizers = [];
    emit(GetDataAppetizersLoadingState());
    FirebaseFirestore.instance.collection('Appetizers').get().then((value) {
      for (int i = 0; i < value.size; i++) {
        listFoodAppetizers
            .add(value.docs.elementAt(i).data().values.elementAt(0));
      }
      emit(GetDataAppetizersSuccessState());
    }).catchError((error) {
      emit(GetDataAppetizersErrorState());
    });
  }

  void getDataOffers() {
    listFoodOffers = [];
    emit(GetImagesOffersLoadingAppState());
    FirebaseFirestore.instance.collection('Offers').get().then((value) {
      for (int i = 0; i < value.size; i++) {
        listFoodOffers.add(value.docs.elementAt(i).data().values.elementAt(0));
      }
      emit(GetImagesOffersSuccessAppState());
    }).catchError((error) {
      emit(GetImagesOffersErrorAppState());
    });
  }

  String generateRandomString() {
    final random = Random();
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    final codeUnits = List.generate(3, (index) {
      final index = random.nextInt(letters.length);
      return letters.codeUnitAt(index);
    });
    return String.fromCharCodes(codeUnits);
  }

  setOffers({
    required List<String> data,
  }) async {
    AddFoodModel model = AddFoodModel(data: data);
    await FirebaseFirestore.instance
        .collection('Offers')
        .doc(data[0])
        .set(model.toMap());
    emit(SetImagesOffersSuccessAppState());
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(GetImagesSuccessAppState());
    } else {
      emit(GetImagesErrorAppState());
    }
  }

  var image = '';
  void uploadProfileImage() {
    emit(UploadImagesLoadingAppState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        image = value;
        emit(UploadImagesSuccessAppState());
      }).catchError((error) {
        emit(UploadImagesSuccessAppState());
      });
    }).catchError((error) {
      emit(UploadImagesErrorAppState());
    });
  }

  String dropdownvalue = 'Meals';
  var items = [
    'Meals',
    'Salads',
    'Drinks',
    'Appetizers',
  ];
  Widget dropDownButtonWidget() {
    return DropdownButton(
      key: const ValueKey("categoryFood"),
      value: dropdownvalue,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (String? newValue) {
        dropdownvalue = newValue!;
        emit(DropDownButtonDone());
      },
    );
  }

  void updateData({
    required List<String> data,
  }) {
    emit(updateDataLoadingAppState());
    AddFoodModel model = AddFoodModel(
      data: data,
    );
    FirebaseFirestore.instance
        .collection(data[1])
        .doc(data[0])
        .update(model.toMap())
        .then((value) {
      emit(updateDataSuccessAppState());
    }).catchError((error) {
      emit(updateDataErrorAppState());
    });
  }

  void updateCart({
    required List<String> data,
  }) {
    emit(UpdateCartLoadingState());
    AddFoodModel model = AddFoodModel(
      data: data,
    );
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(data[1])
        .collection('items') // data[1] contain table number
        .doc(data[0])
        .update(model.toMap())
        .then((value) {
      emit(UpdateCartSuccessState());
      getDataCart();
    }).catchError((error) {
      emit(UpdateCartErrorState());
    });
  }

  void updateOrder({
    required List<String> data,
  }) {
    emit(UpdateOrderLoadingState());
    AddFoodModel model = AddFoodModel(
      data: data,
    );
    FirebaseFirestore.instance
        .collection('Order')
        .doc(data[1])
        .collection('items')
        .doc(data[0])
        .update(model.toMap())
        .then((value) {
      emit(UpdateOrderSuccessState());
      getDataOrder();
    }).catchError((error) {
      emit(UpdateOrderErrorState());
    });
  }

  void updateChef({
    required List<String> data,
  }) {
    emit(UpdateChefLoadingState());
    AddFoodModel model = AddFoodModel(
      data: data,
    );
    FirebaseFirestore.instance
        .collection('Chef')
        .doc(data[1])
        .collection('items')
        .doc(data[0])
        .update(model.toMap())
        .then((value) {
      emit(UpdateChefSuccessState());
      //getDataCart();
    }).catchError((error) {
      emit(UpdateChefErrorState());
    });
  }

  void deleteData({
    required String type,
    required String uid,
  }) {
    emit(deleteDataLoadingAppState());
    FirebaseFirestore.instance.collection(type).doc(uid).delete().then((value) {
      emit(deleteDataSuccessAppState());
    }).catchError((error) {
      emit(deleteDataErrorAppState());
    });
  }

  void deleteImageOffer({
    required List<String> data,
  }) {
    emit(deleteImageOfferLoadingAppState());
    FirebaseFirestore.instance
        .collection('Offers')
        .doc(data[0])
        .delete()
        .then((value) {
      emit(deleteImageOfferSuccessAppState());
    }).catchError((error) {
      emit(deleteImageOfferErrorAppState());
    });
  }

  Future<void> addFoodToChef({
    required List<String> data,
  }) async {
    AddFoodModel model = AddFoodModel(
      data: data,
    );

    await FirebaseFirestore.instance
        .collection('Chef') //data[0] = table number
        .doc(data[0])
        .set({});

    await FirebaseFirestore.instance
        .collection('Chef') //data[0] = table number
        .doc(data[0])
        .collection('items')
        .doc(data[1]) // data[0] = table number, data[1] = uid
        .set(model.toMap())
        .then((value) {
      emit(AddFoodToChefSuccessState());
      getDataCart();
    }).catchError((error) {
      emit(AddFoodToChefErrorState());
    });
  }

  void addFoodToOrder({
    required List<String> data,
  }) {
    AddFoodModel model = AddFoodModel(
      data: data,
    );
    FirebaseFirestore.instance
        .collection('Order')
        .doc(data[0])
        .collection('items')
        .doc(data[1]) // data[0] = table number , data[1] = uid
        .set(model.toMap())
        .then((value) {
      emit(AddFoodToOrderSuccessState());
      getDataOrder();
    }).catchError((error) {
      emit(AddFoodToOrderErrorState());
    });
  }

  Future<void> getDataOrder() async {
    listFoodOrder = [];
    emit(GetDataOrderLoadingState());
    await FirebaseFirestore.instance
        .collection('Order')
        .doc(tableNumberofCustomer)
        .collection('items')
        .get()
        .then((value) {
      for (int i = 0; i < value.size; i++) {
        listFoodOrder.add(value.docs.elementAt(i).data().values.elementAt(0));
      }
      emit(GetDataOrderSuccessState());
    }).catchError((error) {
      emit(GetDataOrderErrorState());
    });
  }

  Future<void> getDataWaiterGuide({
    required String tableNum,
  }) async {
    listFoodWaitersGuide = [];
    emit(GetDataWaitersGuideLoadingState());
    await FirebaseFirestore.instance
        .collection('Waiter Guide')
        .doc(tableNum)
        .collection('items')
        .get()
        .then((value) {
      for (int i = 0; i < value.size; i++) {
        listFoodWaitersGuide
            .add(value.docs.elementAt(i).data().values.elementAt(0));
      }
      emit(GetDataWaitersGuideSuccessState());
    }).catchError((error) {
      emit(GetDataWaitersGuideErrorState());
    });
  }

  void deleteFromCart({
    required String tableNum,
    required String uid,
  }) {
    emit(DeleteFromCartLoadingState());
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(tableNum)
        .collection('items')
        .doc(uid)
        .delete()
        .then((value) {
      emit(DeleteFromCartSuccessState());
      getDataCart();
    }).catchError((error) {
      emit(DeleteFromCartErrorState());
    });
  }

  void deleteFromChef({
    required String tableNum,
  }) {
    emit(DeleteFromChefLoadingState());
    FirebaseFirestore.instance
        .collection('Chef')
        .doc(tableNum)
        .delete()
        .then((value) {
      emit(DeleteFromChefSuccessState());
      getAllTables();
    }).catchError((error) {
      emit(DeleteFromChefErrorState());
    });
  }

  void deleteFromWaiterGuide({
    required String tableNum,
    required String uid,
  }) {
    emit(DeleteFromWaiterGuideLoadingState());
    FirebaseFirestore.instance
        .collection('Waiter Guide')
        .doc(tableNum)
        .collection('items')
        .doc(uid)
        .delete()
        .then((value) {
      emit(DeleteFromWaiterGuideSuccessState());
      getAllTablesOrders();
    }).catchError((error) {
      emit(DeleteFromWaiterGuideErrorState());
    });

    FirebaseFirestore.instance
        .collection('Waiter Guide')
        .doc(tableNum)
        .delete();
  }

  void deleteFromOrder({
    required String tableNum,
    required String uid,
  }) {
    emit(DeleteFromOrderLoadingState());
    FirebaseFirestore.instance
        .collection('Order')
        .doc(tableNum)
        .collection('items')
        .doc(uid)
        .delete()
        .then((value) {
      emit(DeleteFromOrderSuccessState());
      getAllTables();
    }).catchError((error) {
      emit(DeleteFromOrderErrorState());
    });
  }

  Future<void> addFoodToWaiterGuide({
    required List<String> data,
  }) async {
    AddFoodModel model = AddFoodModel(
      data: data,
    );
    await FirebaseFirestore.instance
        .collection('Waiter Guide') //data[0] = table number
        .doc(data[0])
        .set({});

    await FirebaseFirestore.instance
        .collection('Waiter Guide')
        .doc(data[0])
        .collection('items')
        .doc(data[1]) // data[0] = table number , data[1] = uid
        .set(model.toMap())
        .then((value) {
      emit(AddFoodToWaitersGuideSuccessState());
      getDataWaiterGuide(tableNum: data[0]);
    }).catchError((error) {
      emit(AddFoodToWaitersGuideErrorState());
    });
  }
}
