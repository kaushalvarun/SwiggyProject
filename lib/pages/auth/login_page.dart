import 'package:flutter/material.dart';
import 'package:swiggy/components/general_components/heading.dart';
import 'package:swiggy/pages/auth/otp_page.dart';
import 'package:swiggy/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Text editing controllers for the mobile number field
  final TextEditingController _mobileNumberController = TextEditingController();
  Color buttonColor = const Color.fromARGB(225, 228, 226, 226);
  Color textColor = Colors.black54;

  final _formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text('Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    )),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyHeading(text: 'Enter your mobile number\nto get OTP'),
            const SizedBox(height: 20),

            // mobile no field
            Form(
              key: _formKey1,
              child: TextFormField(
                controller: _mobileNumberController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(color: Color.fromRGBO(244, 81, 30, 1)),
                  prefixText: '+91 | ',
                  hintText: '10 digit mobile number',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(244, 81, 30, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(244, 81, 30, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                validator: (value) {
                  if (value!.length != 10) return "Invalid phone number";
                  return null;
                },
                autofocus: true,
                onChanged: (value) {
                  if (value.length == 10) {
                    setState(() {
                      buttonColor = const Color.fromRGBO(244, 81, 30, 1);
                      textColor = const Color.fromRGBO(255, 255, 255, 1);
                    });
                  } else {
                    setState(() {
                      buttonColor = const Color.fromARGB(225, 228, 226, 226);
                      textColor = Colors.black54;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 20.0),

            // get OTP button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AuthService.sendOTP(
                      phoneNo: _mobileNumberController.text,
                      errorHandle: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Error in sending OTP",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ));
                      },
                      nextStep: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPPage(
                              mobNo: _mobileNumberController.text,
                            ),
                          ),
                        );
                      });
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(buttonColor),
                ),
                child: Text(
                  "Get OTP",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            // Terms & Conditions text
            const SizedBox(height: 20.0),
            const Text.rich(
              TextSpan(
                text: 'By clicking, I accept the ',
                style: TextStyle(fontSize: 15.0),
                children: [
                  TextSpan(
                    text: 'terms of service',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 15.0,
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  TextSpan(
                    text: 'privacy policy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
