import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swiggy/components/general_components/heading.dart';
import 'package:swiggy/pages/get_location.dart';
import 'package:swiggy/services/auth_service.dart';

class OTPPage extends StatefulWidget {
  final String mobNo;
  const OTPPage({
    super.key,
    required this.mobNo,
  });
  @override
  OTPPageState createState() => OTPPageState();
}

class OTPPageState extends State<OTPPage> {
  // firebase instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // db instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Text editing controllers for each OTP field
  final TextEditingController _otp1Controller = TextEditingController();
  final TextEditingController _otp2Controller = TextEditingController();
  final TextEditingController _otp3Controller = TextEditingController();
  final TextEditingController _otp4Controller = TextEditingController();
  final TextEditingController _otp5Controller = TextEditingController();
  final TextEditingController _otp6Controller = TextEditingController();

  // FocusNodes for each OTP field
  final FocusNode _otp1FocusNode = FocusNode();
  final FocusNode _otp2FocusNode = FocusNode();
  final FocusNode _otp3FocusNode = FocusNode();
  final FocusNode _otp4FocusNode = FocusNode();
  final FocusNode _otp5FocusNode = FocusNode();
  final FocusNode _otp6FocusNode = FocusNode();

  @override
  void dispose() {
    _otp1Controller.dispose();
    _otp2Controller.dispose();
    _otp3Controller.dispose();
    _otp4Controller.dispose();
    _otp1FocusNode.dispose();
    _otp2FocusNode.dispose();
    _otp3FocusNode.dispose();
    _otp4FocusNode.dispose();
    super.dispose();
  }

  Color buttonColor = const Color.fromARGB(225, 228, 226, 226);
  Color textColor = Colors.black54;

  // handle after otp is submitted
  void handleSubmit(BuildContext context) {
    final String otpRecieved = _otp1Controller.text +
        _otp2Controller.text +
        _otp3Controller.text +
        _otp4Controller.text +
        _otp5Controller.text +
        _otp6Controller.text;

    AuthService.loginWithOtp(otp: otpRecieved).then((value) async {
      if (value == "Success") {
        Navigator.pop(context);

        final user = _firebaseAuth.currentUser!;
        // Check if data already exists for the user
        final userDoc = _firestore.collection('users').doc(user.uid);
        await userDoc.get().then((value) {
          if (value.exists) {
            // Data already exists, navigate to GetLocation page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GetLocation()),
            );
          } else {
            // Data doesn't exist, add data to Firestore
            try {
              userDoc.set({
                'phoneNo': widget.mobNo,
              });
              // Navigate to GetLocation page after adding data
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const GetLocation()),
              );
            } catch (e) {
              // ignore: avoid_print
              print('Error: can\'t add data to db\n$e');
            }
          }
        });
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enter otp to mobNo text
            const MyHeading(text: 'Enter the OTP sent to'),
            const SizedBox(height: 5.0),
            Text(
              widget.mobNo,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            // otp fields
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _otpField(_otp1Controller, _otp1FocusNode, 1),
                _otpField(_otp2Controller, _otp2FocusNode, 2),
                _otpField(_otp3Controller, _otp3FocusNode, 3),
                _otpField(_otp4Controller, _otp4FocusNode, 4),
                _otpField(_otp5Controller, _otp5FocusNode, 5),
                _otpField(_otp6Controller, _otp6FocusNode, 6),
              ],
            ),

            // continue button
            const SizedBox(height: 40.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => handleSubmit(context),
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
                  "Continue",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // otp field widget
  Widget _otpField(
      TextEditingController controller, FocusNode focusNode, int fieldNumber) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 8,
      height: 60,
      child: Form(
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.center,
          focusNode: focusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: (value) {
            if (value.length == 1) {
              switch (fieldNumber) {
                case 1:
                  FocusScope.of(context).requestFocus(_otp2FocusNode);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(_otp3FocusNode);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(_otp4FocusNode);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(_otp5FocusNode);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(_otp6FocusNode);
                  break;
                case 6:
                  setState(() {
                    buttonColor = const Color.fromRGBO(244, 81, 30, 1);
                    textColor = const Color.fromRGBO(255, 255, 255, 1);
                  });
                  break;
                default:
                  break;
              }
            }
          },
        ),
      ),
    );
  }
}
