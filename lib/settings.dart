
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:http/http.dart' as http;

import 'globals.dart' as globals;

import 'package:visite3000/main.dart';

class Settings extends StatefulWidget{
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{

  final _storage = const FlutterSecureStorage();

  void _logOut(){
    _storage.deleteAll();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const MyApp()));
  }

  Future<bool> _disconnectAllAccount() async {
    
    Map data = {
      'userId': await _storage.read(key: "UserId"),
    };
    String body = jsonEncode(data);
    
    Response response = await http.post(
      Uri.parse('${globals.serverEntryPoint}/db/reset_token.php'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Account'),
            tiles: [
              SettingsTile(
                title: const Text('Log out'),
                leading: const Icon(Icons.logout),
                onPressed: (BuildContext context) {
                  _logOut();
                },
              ),
              SettingsTile(
                title: const Text('Disconnect all accounts'),
                leading: const Icon(Icons.delete),
                onPressed: (BuildContext context) {
                  _disconnectAllAccount().then((validation) {
                    if (validation) {
                      _storage.deleteAll();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const MyApp()));
                    }
                  });
                },
              ),
            ],
          ),
        ],
      )
    );
  }
}