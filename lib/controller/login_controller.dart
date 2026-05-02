import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footwear_client/models/user/user.dart' as app_user;
import 'package:footwear_client/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

class LoginController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GetStorage box = GetStorage();
  late CollectionReference userCollection;
  static const int _otpCooldownSeconds = 60;

  TextEditingController registerNameController = TextEditingController();
  TextEditingController registerNumberController = TextEditingController();
  TextEditingController loginNumberController = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();

  bool isOtpVisible = false;

  String? verificationId;
  String? otpEntered;
  DateTime? _lastOtpRequestAt;

  app_user.User? logginUser;

  @override
  void onReady() {
    Map<String, dynamic>? user = box.read('loginUser');
    if (user != null) {
      logginUser = app_user.User.fromJson(user);
      Get.to(() => const HomePage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
    userCollection = firestore.collection('users');
  }

  addUser() async {
    try {
      if (registerNameController.text.trim().isEmpty ||
          registerNumberController.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Please fill in all fields",
          colorText: Colors.red,
          backgroundColor: Colors.red[100],
        );
        return;
      }

      if (verificationId == null ||
          otpEntered == null ||
          otpEntered!.length != 6) {
        Get.snackbar(
          "Error",
          "Enter the 6-digit OTP code",
          colorText: Colors.red,
          backgroundColor: Colors.red[100],
        );
        return;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpEntered!,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      DocumentReference docRef = userCollection.doc();
      app_user.User user = app_user.User(
        id: docRef.id,
        name: registerNameController.text.trim(),
        number: int.parse(registerNumberController.text.trim()),
      );
      await docRef.set(user.toJson());
      Get.snackbar(
        "Success",
        "User added successfully",
        colorText: Colors.green,
      );
      registerNameController.clear();
      registerNumberController.clear();
      otpController.clear();
      otpEntered = null;
      verificationId = null;
      isOtpVisible = false;
      update();
    } catch (e) {
      Get.snackbar(
        "Error",
        "OTP verification failed. Please try again.",
        colorText: Colors.red,
      );
      print("Error adding user: $e");
    }
  }

  sendOtp() async {
    try {
      if (_lastOtpRequestAt != null) {
        final secondsPassed = DateTime.now()
            .difference(_lastOtpRequestAt!)
            .inSeconds;
        if (secondsPassed < _otpCooldownSeconds) {
          final waitSeconds = _otpCooldownSeconds - secondsPassed;
          Get.snackbar(
            "Please wait",
            "You can request a new OTP in $waitSeconds sec",
            colorText: Colors.orange[900],
            backgroundColor: Colors.orange[100],
          );
          return;
        }
      }

      if (registerNameController.text.trim().isEmpty ||
          registerNumberController.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Please fill in all fields",
          colorText: Colors.red,
          backgroundColor: Colors.red[100],
          duration: Duration(milliseconds: 500 * 3),
          margin: EdgeInsets.all(10),
          borderRadius: 10,
          boxShadows: [BoxShadow(color: Colors.red[100]!, blurRadius: 10)],
        );
        return;
      }

      final phoneNumber = _normalizePhoneNumber(
        registerNumberController.text.trim(),
      );
      if (phoneNumber == null) {
        Get.snackbar(
          "Error",
          "Enter a valid phone number. Example: +380XXXXXXXXX",
          colorText: Colors.red,
          backgroundColor: Colors.red[100],
        );
        return;
      }
      _lastOtpRequestAt = DateTime.now();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          Get.snackbar(
            "Success",
            "Phone verified automatically",
            colorText: Colors.green,
            backgroundColor: Colors.green[100],
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          final code = e.code.toLowerCase();
          final rawMessage = (e.message ?? '').toLowerCase();
          final isRateLimited =
              code == 'too-many-requests' ||
              (code == 'unknown' && rawMessage.contains('error code:39'));

          Get.snackbar(
            "Error",
            isRateLimited
                ? "Too many OTP attempts. Please try again later."
                : "Failed to send OTP (${e.code}): ${e.message ?? 'Unknown error'}",
            colorText: Colors.red,
            backgroundColor: Colors.red[100],
          );
          print(
            "verifyPhoneNumber failed: code=${e.code}, message=${e.message}",
          );
        },
        codeSent: (String id, int? resendToken) async {
          verificationId = id;
          isOtpVisible = true;
          update();
          Get.snackbar(
            "Success",
            "OTP sent successfully",
            colorText: Colors.green,
            backgroundColor: Colors.green[100],
            duration: Duration(milliseconds: 500 * 3),
            margin: EdgeInsets.all(10),
            borderRadius: 10,
            boxShadows: [BoxShadow(color: Colors.green[100]!, blurRadius: 10)],
          );
          await Future.delayed(const Duration(milliseconds: 100));
          otpController.setFocus(0);
        },
        codeAutoRetrievalTimeout: (String id) {
          verificationId = id;
        },
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error sending OTP: ${e.toString()}",
        colorText: Colors.red,
        backgroundColor: Colors.red[100],
        duration: Duration(milliseconds: 500 * 3),
        margin: EdgeInsets.all(10),
        borderRadius: 10,
        boxShadows: [BoxShadow(color: Colors.red[100]!, blurRadius: 10)],
      );
    }
  }

  String? _normalizePhoneNumber(String raw) {
    var value = raw.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (value.isEmpty) return null;

    if (value.startsWith('+')) {
      final digitsOnly = value.substring(1);
      if (!RegExp(r'^\d{10,15}$').hasMatch(digitsOnly)) return null;
      return value;
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) return null;
    if (value.startsWith('380') && value.length == 12) return '+$value';
    if (value.startsWith('0') && value.length == 10) return '+38$value';
    if (value.length == 9) return '+380$value';
    if (value.length >= 10 && value.length <= 15) return '+$value';
    return null;
  }

  Future<void> loginWithPhoneNumber() async {
    try {
      int phoneNumber = int.parse(loginNumberController.text.trim());
      if (phoneNumber.toString().isNotEmpty) {
        var querySnapshot = await userCollection
            .where('number', isEqualTo: int.tryParse(phoneNumber.toString()))
            .limit(1)
            .get();
        var userDoc = querySnapshot.docs.first;
        var userData = userDoc.data() as Map<String, dynamic>;
        box.write('loginUser', userData);
        loginNumberController.clear();
        Get.to(() => const HomePage());
        Get.snackbar(
          "Success",
          "Login successful",
          colorText: Colors.green,
          backgroundColor: Colors.green[100],
        );
      } else {
        Get.snackbar(
          "Error",
          "Please enter phone number",
          colorText: Colors.red,
          backgroundColor: Colors.red[100],
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error logging in: ${e.toString()}",
        colorText: Colors.red,
        backgroundColor: Colors.red[100],
      );
    }
  }
}
