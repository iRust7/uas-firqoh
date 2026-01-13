import 'package:flutter/material.dart';
import 'data/hive_boxes.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive and open boxes
  await HiveBoxes.initHive();
  
  runApp(const MyApp());
}
