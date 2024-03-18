import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:midtermpracfirebase/screens/login.dart';
import 'package:quickalert/quickalert.dart';

class Registerscreen extends StatefulWidget {
  Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final formkey = GlobalKey<FormState>();
  bool showpassword = true;

  var namecon = TextEditingController();

  var emailcon = TextEditingController();

  var passcon = TextEditingController();

  void validateform()async {
    if(formkey.currentState!.validate()){
      try{
        QuickAlert.show(
          context: context, 
          type: QuickAlertType.loading,
          text: 'Loading',
          title: 'Creating your account');

          UserCredential  usercred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailcon.text, password: passcon.text);

            String user_id = usercred.user!.uid;

            await FirebaseFirestore.instance.collection('users').doc(user_id).set({
              'name' : namecon.text,
              'email' : emailcon.text,
            });
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=> LoginScreen()));
      } on FirebaseAuthException catch(error){
        Navigator.of(context).pop();
          QuickAlert.show(
            context: context, 
            type: QuickAlertType.error,
            text: '$error',
            );
      }
    }else{
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                SizedBox(height: 20,),
                TextFormField(
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please fill up this field';
                    }
                    return null;
                  },
                  controller: namecon,
                  decoration: InputDecoration(
                    label: const Text('Name'),
                    border: OutlineInputBorder(),
                  ),
                ),
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
                ElevatedButton(onPressed: validateform, child: const Text('Register Account'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green
                ),
                ),
                Gap(20),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>LoginScreen()));
                }, child: const Text('Log In'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}