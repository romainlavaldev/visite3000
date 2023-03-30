import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:visite3000/globals.dart' as globals;

class Scanner extends StatefulWidget{

  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  MobileScannerController cameraController = MobileScannerController();
    final _storage = const FlutterSecureStorage();
    bool alreadyScanned = false;

  Future<String> addSubbedCard(String readValue) async {
    if (readValue.isEmpty){
      return "not_added";
    }


    String shareCode = readValue;
    
    Map data = {'userId': await _storage.read(key: "UserId"), 'shareCode': shareCode};

    String body = jsonEncode(data);
    
    Response response = await http.post(
      Uri.parse('${globals.serverEntryPoint}/db/add_user_subbed_card.php'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    );

    if (response.statusCode == 200){
      dynamic jsonData = json.decode(response.body);
      return jsonData['status'];
    } else {
      return "not_added";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mobile Scanner'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: MobileScanner(
          // fit: BoxFit.contain,
          controller: cameraController,
          onDetect: (capture) {

            if (alreadyScanned){
              return;
            }

            final Barcode barcode = capture.barcodes[0];
            String val = barcode.rawValue ?? "";
            addSubbedCard(val).then((status) {
              setState(() {
                alreadyScanned = true;
              });
              if (status == "not_added"){
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    elevation: 0,
                    content: Text(
                      "Can't find card",
                      textAlign: TextAlign.center,
                    ),
                    icon: Icon(Icons.close),
                  )
                ).then((value) => Navigator.pop(context));
              }
              else if (status == "added")
              {
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    elevation: 0,
                    content: Text(
                      "Card added to your wallet",
                      textAlign: TextAlign.center,
                    ),
                    icon: Icon(Icons.check),
                  )
                ).then((value) => Navigator.pop(context, 1));
              }
              else if (status == "exists")
              {
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    elevation: 0,
                    content: Text(
                      "You already have this card in your wallet !",
                      textAlign: TextAlign.center,
                    ),
                    icon: Icon(Icons.copy_all_rounded),
                  )
                ).then((value) => Navigator.pop(context));
              } 
              else if (status == "owner")
              {
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    elevation: 0,
                    content: Text(
                      "This card is yours !",
                      textAlign: TextAlign.center,
                    ),
                    icon: Icon(Icons.face),
                  )
                ).then((value) => Navigator.pop(context));
              }
            });
          },
        ),
    );
  }
}