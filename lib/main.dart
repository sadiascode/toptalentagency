import 'package:flutter/material.dart';
import 'package:top_talent_agency/app/app.dart';
import 'package:top_talent_agency/core/roles.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Initialize role storage
  await initializeRole();

  runApp(const TopTalentAgency());
}
