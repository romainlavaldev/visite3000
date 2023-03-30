
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:http/http.dart' as http;

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

  void _disconnectAllAccount(){

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
                  _disconnectAllAccount();
                },
              ),
            ],
          ),
        ],
      )
    );
  }
}