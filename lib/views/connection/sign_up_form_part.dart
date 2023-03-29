import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:visite3000/views/common/no_internet.dart';

import 'package:visite3000/globals.dart' as globals;

class SignUpFormPart extends StatefulWidget{
  final Function setIsRegistered;
  final Function setIsLoading;
  const SignUpFormPart({super.key, required this.setIsRegistered, required this.setIsLoading});

  @override
  State<SignUpFormPart> createState() => _SignUpFormPartState();
}

class _SignUpFormPartState extends State<SignUpFormPart>{
  final _loginfromkey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;

  Future<void> _trySignup() async {

    if (passwordController.text != passwordConfirmController.text || !isValidEmail(emailController.text))
    {
      return;
    }

    widget.setIsLoading(true);

    Map data = {'firstName': firstNameController.text, 
                'lastName': lastNameController.text, 
                'username': usernameController.text, 
                'email': emailController.text, 
                'password': passwordController.text
                };

    String body = jsonEncode(data);

    await Future.delayed(const Duration(seconds: 2), (){});

    Response response;
    try
    {
      response = await http.post(
        Uri.parse('${globals.serverEntryPoint}/db/signup.php'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
        }
      );
    } catch(e){
      print(e);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const NoInternet()));
      return;
    }

    if(response.statusCode == 200)
    {
      dynamic jsonData = json.decode(response.body);
      widget.setIsLoading(false);
      if (jsonData['status'] == 1)
      {
        widget.setIsRegistered(true);
      }
      else
      {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              elevation: 0,
              content: Text(
                jsonData['message'],
                textAlign: TextAlign.center,
              ),
              icon: const Icon(Icons.person_off_outlined),
            )
          );
      }
    }
  }

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.only(
      left: 40,
      right: 40,
      top: 50,
      bottom: 20
    ),
    child: Column(
      children: [
        const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Form(
          key: _loginfromkey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: lastNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: usernameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: "Username"
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email"
                ),
                validator: (value){
                  if (!isValidEmail(value!))
                  {
                    return "Email is not valid";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined
                    ),
                    color: Colors.pink,
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordConfirmController,
                obscureText: !_isPasswordConfirmVisible,
                keyboardType: TextInputType.visiblePassword,
                onEditingComplete: _trySignup,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordConfirmVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined
                    ),
                    color: Colors.pink,
                    onPressed: () {
                      setState(() {
                        _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
                      });
                    },
                  )
                ),
                validator: (value){
                  if (value != passwordController.text)
                  {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 45,
        ),
        TextButton(
          onPressed: (){
            if(_loginfromkey.currentState!.validate())
            {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("You are now registered"),
                  backgroundColor: Colors.green,
                )
              );
            }
            _trySignup();
          },
          style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink,
              fixedSize: const Size(120, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))
              )
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text("Sign Up"),
              Icon(Icons.arrow_right_alt_rounded)
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
      )
    );
  }
}