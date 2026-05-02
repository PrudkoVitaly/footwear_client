import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:footwear_client/controller/home_controller.dart';
import 'package:footwear_client/controller/login_controller.dart';
import 'package:footwear_client/controller/category_controler.dart';
import 'package:footwear_client/pages/register_page.dart';
import 'package:footwear_client/firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(CategoryController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RegisterPage(),
    );
  }
}
