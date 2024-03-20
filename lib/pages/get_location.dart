import 'package:flutter/material.dart';
import 'package:swiggy/components/general_components/heading.dart';
import 'package:swiggy/components/general_components/my_button.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyHeading(
                      text: 'What\'s your location?',
                    ),

                    SizedBox(height: 12),

                    // subheading text
                    Text(
                      'We need your location to show available restaurants & products.',
                      style: TextStyle(
                        color: Color(0xFF616161),
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // fancy location image
              Image.asset(
                'lib/assets/images/FancyLocation.png',
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 20),
              // continue button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    onPressed: () {},
                    msg: 'Continue',
                    buttonColor: Colors.deepOrange[600]!,
                    textColor: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // enter location manually
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Enter location manually',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange[600],
                    ),
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
