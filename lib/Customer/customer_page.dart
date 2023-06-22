import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_page.dart';

class Customer extends StatefulWidget {
  @override
  State<Customer> createState() => _CustomerState();
}

String? tableNumberofCustomer;

class _CustomerState extends State<Customer> {
  List<String> tablesNumbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];
  var tableNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool tableIsExist = false;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 59,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadiusDirectional.all(Radius.circular(5)),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      for (int i = 0; i < tablesNumbers.length; i++) {
                        if (tableNumberController.text == tablesNumbers[i]) {
                          tableIsExist = true;
                          break;
                        }
                      }
                      if (tableIsExist) {
                        tableNumberofCustomer = tableNumberController.text;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false,
                        );
                        setState(() {});
                      } else {
                        Fluttertoast.showToast(
                          msg: 'The table number is incorrect',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
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
                  controller: tableNumberController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter the table number",
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
