import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../dialogeUtils.dart';
import '../../validation_utils.dart';
import '../registration/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool securedPassword = true ;
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image :AssetImage('assets/images/background_pattern.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text('Login'),
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height : MediaQuery.of(context).size.height*.25),

                    TextFormField(
                        controller: emailController,
                        validator: (text){
                          validator: (text){
                            if(text == null || text.trim().isEmpty){
                              return 'Please Enter email address';
                            }
                            if(!ValidationUtils.isValidEmail(text)){
                              return 'Please enter a valid email';
                            }
                            return null ;
                          };
                        },
                        decoration : InputDecoration(
                            labelText: ('Email Address ')
                        )
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (text){
                        validator: (text){
                          if(text == null || text.trim().isEmpty){
                            return 'Please Enter password';
                          }
                          if(text.length<6){
                            return 'Password should be at least 6 chars';
                          }
                          return null ;
                        };
                      },
                      obscureText: securedPassword,
                      decoration : InputDecoration(
                        labelText: ('Password '),
                        suffixIcon: InkWell(
                            onTap: (){
                              securedPassword=!securedPassword;
                              setState((){});
                            },

                            child: Icon(
                                securedPassword ?
                                Icons.visibility: Icons.visibility_off)),
                      ),
                    ),
                    SizedBox(height: 24,),
                    ElevatedButton(onPressed: (){
                      signIn();
                    },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                        ),
                        child:
                        Text('Login',
                          style: TextStyle(
                              fontSize:18
                          ),)),
                    TextButton(onPressed: (){
                      Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                    },
                        child: Text('or Create Account ?')),

                  ],),
              ),
            ),

          ),
        ),
      ) ,
    );

  }
  var authService = FirebaseAuth.instance;
  void signIn(){
    if(formKey.currentState?.validate()==false){
      return;
    }
    showLoading(context, 'Loading....');
    authService.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
        .then((userCredential) {
      hideLoading(context);
      showMessage(context, (userCredential.user?.uid) ?? '');
    })
        .onError((error, stackTrace) {
      hideLoading(context);
      showMessage(context, error.toString());
    });
  }

}
