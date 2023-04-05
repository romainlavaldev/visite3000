import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart' as sizeGetter;
import 'package:visite3000/globals.dart' as globals;

class CardAdd extends StatefulWidget {
  const CardAdd({super.key});

  @override
  State<CardAdd> createState() => _CardAddState();
}

class _CardAddState extends State<CardAdd> {
  final _storage = const FlutterSecureStorage();
  Image image = Image(
    image: NetworkImage("${globals.serverEntryPoint}/cards/0.png"),
  );

  File? imageFile;

  Future<bool> addCard() async {

    if (imageFile == null){
      return false;
    }

    List<int> imageData = imageFile?.readAsBytesSync() as List<int>;

    String baseImage = base64Encode(imageData);


    Map data = {
      'userId': await _storage.read(key: "UserId"),
      'role': roleController.text, 
      'phone': phoneController.text,
      'mail': mailController.text,
      'image': baseImage
    };
    String body = jsonEncode(data);
    
    Response response = await http.post(
      Uri.parse('${globals.serverEntryPoint}/db/add_card.php'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    );

    if (response.statusCode == 200){
      return true;
    }
    else {
      return false;
    }
  }

  void confirmCancel(BuildContext context){
    Widget cancelButton = TextButton(
      child: const Text("NOOOOOOO!"),
      onPressed:  () => Navigator.pop(context),
      
    );
    Widget continueButton = TextButton(
      child: const Text("I'm sure"),
      onPressed:  () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Cancel ?"),
      content: const Text("Changes will not be saved."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> changeImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null){
      return false;
    }

    File imageFile = File(image.path);
    
    final size = sizeGetter.ImageSizeGetter.getSize(FileInput(imageFile));

    if (size.width != 448 || size.height != 268){
      return false;
    }

    Image selectedImage = Image.file(imageFile);

    setState(() {
      this.image = selectedImage;
      this.imageFile = imageFile;
    });

    return true;
  }

  TextEditingController roleController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        confirmCancel(context);
        return Future(() => false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, 
        backgroundColor: Colors.pink,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => changeImage().then((validation) {
                      if (!validation) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            elevation: 0,
                            content: Text(
                              "Image has to be 448x268 and .png",
                              textAlign: TextAlign.center,
                            ),
                            icon: Icon(Icons.image_aspect_ratio),
                          )
                        );
                      }
                    }),
                    child: image
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.pink,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 5
                          ),
                          child: Column(
                            children:
                            [
                              CardFormEntryEdit(title: "Role", controller: roleController),
                              CardFormEntryEdit(title: "Phone", controller: phoneController, isPhone: true,),
                              CardFormEntryEdit(title: "Mail", controller: mailController, isMail: true,),
                            ]
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              fixedSize: const Size(120, 50),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30))
                              )
                            ),
                            onPressed: () => confirmCancel(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.pink
                              ),
                            )
                          ),
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              fixedSize: const Size(120, 50),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 255, 230, 0),
                                width: 7),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30))
                              )
                            ),
                            onPressed: () {
                              addCard().then((validation) {
                                if (validation){
                                  Navigator.pop(context, 1);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const AlertDialog(
                                      elevation: 0,
                                      content: Text(
                                        "Can't save the datas",
                                        textAlign: TextAlign.center,
                                      ),
                                      icon: Icon(Icons.signal_wifi_connected_no_internet_4_rounded),
                                    )
                                  );
                                }
                              });
                            } ,
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.pink
                              ),
                            )
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}


class CardFormEntryEdit extends StatelessWidget{
  final String title;
  final TextEditingController controller;
  
  final bool isMail;
  final bool isPhone;

  const CardFormEntryEdit({super.key, required this.title, required this.controller, this.isPhone = false, this.isMail = false});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 197, 25, 82),
              border: Border.all(
                color: Colors.yellow.withOpacity(0.75),
                width: 3
              ),
              borderRadius: BorderRadius.circular(13)
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                scrollPadding: const EdgeInsets.only(bottom: 120),
                decoration: null,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
                controller: controller,
              )
            )
          )
        ],
      ),
    );
  }

}
  