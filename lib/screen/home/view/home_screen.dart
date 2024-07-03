import 'package:exam/screen/home/controller/home_controller.dart';
import 'package:exam/screen/home/model/db_model.dart';
import 'package:exam/utils/helpers/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController home=Get.put(HomeController());
  TextEditingController txtName=TextEditingController();
  TextEditingController txtMobile=TextEditingController();
  TextEditingController txtEmail=TextEditingController();
  GlobalKey<FormState> key=GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    home.readData();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text("Contact App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children:[ Obx(
            () =>  Expanded(
              child: ListView.builder(itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    editContact(home.dataList[index]);
                  },
                  onLongPress: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text("Are You Sure?"),
                        content: Text("${home.dataList[index].name} will be deleted!"),
                        actions: [
                          ElevatedButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: const Text("No!")),
                          ElevatedButton(onPressed: () {
                            DbHelper.dbHelper.deleteData(home.dataList[index].id!);
                            home.readData();
                            Navigator.pop(context);
                          }, child: const Text("Yes!"))
                        ],
                      );
                    },);
                  },
                  title: Text(home.dataList[index].name!),
                  subtitle: Text(home.dataList[index].mobile!),
                  leading: CircleAvatar(radius: 35,
                  backgroundColor: Colors.primaries[index].shade300,
                  child: Center(child: Text(home.dataList[index].name!.substring(0,1),style: const TextStyle(fontWeight: FontWeight.bold),),),),
                  trailing: Row(mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () async {
                      await launchUrl(Uri.parse("sms:${home.dataList[index].mobile}"));
                    }, icon: const Icon(Icons.sms)),
                    const SizedBox(width: 1,),
                    IconButton(onPressed: () async {
                      await launchUrl(Uri.parse("tel:${home.dataList[index].mobile}"));
                    }, icon: const Icon(Icons.call))

                  ],),
                );
              },
              itemCount: home.dataList.length,),
            ),
          ),
            SizedBox(height: MediaQuery.sizeOf(context).height*0.2,
            child: const Center(child: Text("On tap of any contact you can edit contact\nOn long press of any contact You can delete contact")),)
            ]

        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        addContact();
      },child: const Icon(Icons.person_add),),
    ));
  }
  void addContact(){
    txtName.clear();
    txtMobile.clear();
    txtEmail.clear();
    showDialog(context: context, builder: (context) {
      return SingleChildScrollView(
        child: AlertDialog(
          title: const Text("Add a new Contact"),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(controller: txtName,
                  validator: (value) {
                    if(value!.isEmpty)
                      {
                        return "Please Enter Name:";
                      }
                    return null;
                  },
                  decoration: const InputDecoration(label: Text("Name:"),
                  prefixIcon: Icon(Icons.person_add),
                  border: OutlineInputBorder()),),
                  const SizedBox(height: 12,),
                  TextFormField(controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                    if(value!.isNotEmpty) {
                      EmailValidator.validate(value)
                          ? null
                          : "Please enter a valid email";
                    }
                    else{
                      return "Email can't empty";
                    }
                        return null;
                      },
                    decoration: const InputDecoration(label: Text("Email:"),
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder())),
                  const SizedBox(height: 12,),
                  TextFormField(controller: txtMobile,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value!.isEmpty)
                      {
                        return "Please Enter mobile number:";
                      }
                      else if(value.length!=10)
                        {
                          return "Please Enter a Valid number";
                        }
                      return null;
                    },
                    decoration: const InputDecoration(label: Text("Mobile:"),
                        prefixIcon: Icon(Icons.call),
                        border: OutlineInputBorder()),),
                  const SizedBox(height: 18,),
                  Center(
                    child: ElevatedButton(child: const Text("Add"),onPressed: () async {
                      if(key.currentState!.validate())
                        {
                          DBModel model=DBModel(name: txtName.text, email: txtEmail.text, mobile: txtMobile.text);
                          await DbHelper.dbHelper.addData(model);
                          await home.readData();
                          Navigator.pop(context);
                        }
                    },),
                  )
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            }, child: const Text("Cancel"))
          ],
        ),
      );
    },);
  }
  void editContact(DBModel modelIndex){
    txtName.text=modelIndex.name!;
    txtEmail.text=modelIndex.email!;
    txtMobile.text=modelIndex.mobile!;
    showDialog(context: context, builder: (context) {
      return SingleChildScrollView(
        child: AlertDialog(
          title: const Text("Edit a new Contact"),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(controller: txtName,
                    validator: (value) {
                      if(value!.isEmpty)
                      {
                        return "Please Enter Name:";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(label: Text("Name:"),
                        prefixIcon: Icon(Icons.person_add),
                        border: OutlineInputBorder()),),
                  const SizedBox(height: 12,),
                  TextFormField(controller: txtEmail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if(value!.isNotEmpty) {
                          EmailValidator.validate(value)
                              ? null
                              : "Please enter a valid email";
                        }
                        else{
                          return "Email can't empty";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(label: Text("Email:"),
                          prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder())),
                  const SizedBox(height: 12,),
                  TextFormField(controller: txtMobile,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value!.isEmpty)
                      {
                        return "Please Enter mobile number:";
                      }
                      else if(value.length!=10)
                      {
                        return "Please Enter a Valid number";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(label: Text("Mobile:"),
                        prefixIcon: Icon(Icons.call),
                        border: OutlineInputBorder()),),
                  const SizedBox(height: 18,),
                  Center(
                    child: ElevatedButton(child: const Text("Add"),onPressed: () async {
                      if(key.currentState!.validate())
                      {
                        DBModel model=DBModel(name: txtName.text, email: txtEmail.text, mobile: txtMobile.text,id: modelIndex.id);
                        await DbHelper.dbHelper.updateData(model);
                        await home.readData();
                        Navigator.pop(context);
                      }
                    },),
                  )
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            }, child: const Text("Cancel"))
          ],
        ),
      );
    },);
  }
}

