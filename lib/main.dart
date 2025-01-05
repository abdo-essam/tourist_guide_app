import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';

void main() {
  runApp(const TouristGuideApp());
}

class TouristGuideApp extends StatelessWidget {
  const TouristGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Egypt Tourist Guide',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.login,
    );
  }
}
