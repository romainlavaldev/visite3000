import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login_screen.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>{

  final _storage = const FlutterSecureStorage();

  final _loginfromkey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();


  bool _isPasswordVisible = false;

  Future<void> _trySignup() async {

    Map data = {'username': usernameController.text, 'email': emailController.text, 'password': passwordController.text, 'passwordConfirm': passwordConfirmController.text};

    if (passwordController.text != passwordConfirmController.text)
    {
      return;
    }

/*
    String body = jsonEncode(data);
    Response response = await http.post(
      Uri.parse('http://192.168.1.100:8001/visite3000/signUp.php'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    );
*/
    _loginScreen();

  }

  _loginScreen(){
    Navigator.push(context, MaterialPageRoute(builder: (builder) => const LoginScreen()));
  }

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.pink,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 75,
          right: 20,
          left: 20,
          bottom: 100
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Visite3000",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 40
              ),
            ),
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                  child: Padding(
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
                              TextFormField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  hintText: "Username"
                                ),
                              ),
                              const SizedBox(
                                height: 20,
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
                                height: 20,
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
                                height: 20,
                              ),
                              TextFormField(
                                controller: passwordConfirmController,
                                obscureText: !_isPasswordVisible,
                                keyboardType: TextInputType.visiblePassword,
                                onEditingComplete: _trySignup,
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
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
                          height: 60,
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
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account ? ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                        ),
                      ),
                      GestureDetector(
                        onTap: _loginScreen,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 16,
                            fontWeight: FontWeight.w900
                          ),
                        ),
                      )
                    ],
                  )
                  
              ],
            ),
              const SizedBox()
          ],
        ),
      )
    );
  }
}