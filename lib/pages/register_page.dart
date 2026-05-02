import 'package:flutter/material.dart';
import 'package:footwear_client/controller/login_controller.dart';
import 'package:footwear_client/pages/login_page.dart';
import 'package:footwear_client/widgets/otp_txt_field.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.blueGrey[50]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Your Account !!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.registerNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Your Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.registerNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_android),
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              OtpTxtField(
                otpController: controller.otpController,
                isVisible: controller.isOtpVisible,
                onComplete: (pin) {
                  controller.otpEntered = pin;
                  print("Entered OTP: $pin");
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (controller.isOtpVisible) {
                    controller.addUser();
                  } else {
                    controller.sendOtp();
                  }
                },
                child: Text(controller.isOtpVisible ? "Register" : "Send OTP"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const LoginPage());
                },
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
