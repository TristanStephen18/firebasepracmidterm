import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:midtermpracfirebase/screens/home.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  bool showpassword = true;

  var emailcon = TextEditingController();
  var passcon = TextEditingController();

  void login() async {
    if(formkey.currentState!.validate()){
      EasyLoading.show(
        status: 'Processing'
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailcon.text, password: passcon.text)
      .then((UserCredential) async {
        EasyLoading.dismiss();
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=> Datascreen()));
      }).catchError((error){
        EasyLoading.showError(
          'Invalid Credentials Entered'
        );
      });
    }else{
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(20),
                SizedBox(height: 10,),
                TextFormField(
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please fill up this field';
                    }
                    return null;
                  },
                  controller: emailcon,
                  decoration: InputDecoration(
                    label: const Text('Email'),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  obscureText: showpassword,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please fill up this field';
                    }
                    return null;
                  },
                  controller: passcon,
                  decoration: InputDecoration(
                    label: const Text('Password'),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        showpassword = !showpassword;
                      });
                    }, icon: Icon( showpassword ? Icons.visibility : Icons.visibility_off))
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: login, child: const Text('Log In'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}