import 'package:exam/utils/helpers/db_helper.dart';
import 'package:get/get.dart';

import '../model/db_model.dart';

class HomeController extends GetxController{
  RxList<DBModel> dataList=<DBModel>[].obs;
  Future<void> readData()
  async {
    dataList.value =await DbHelper.dbHelper.readData();
  }
}