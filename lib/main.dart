import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventory/providers/inventory_provider.dart';
import 'package:inventory/screens/main_screen.dart';
import 'package:inventory/services/firebase_service.dart';
import 'package:inventory/utils/theme.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InventoryProvider(FirebaseService()),
      child: MaterialApp(
        title: 'Inventory Pro',
        theme: buildTheme(context),
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
      ),
    );
  }
}
