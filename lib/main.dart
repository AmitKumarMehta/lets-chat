import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/firebase_options.dart';
import 'package:lets_chat/screens/splash.dart';
import 'package:lets_chat/theme/gradient_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(create: (context) => GradientProvider(),
  child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lets-chat',
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

