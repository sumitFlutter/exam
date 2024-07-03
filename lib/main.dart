
import 'package:exam/utils/routes/my_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main()
{
  runApp(const Exam());
}
class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: myAppRoutes
    );
  }
}
