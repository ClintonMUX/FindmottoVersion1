import 'package:findmotto/screens/login_screen.dart';
import 'package:findmotto/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:findmotto/global/global.dart';
import 'package:findmotto/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import the firebase_auth package
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/cupertino.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

   final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();


bool _passwordVisible = false;
  void _submit() {
// validate all form fields
 firebaseAuth.sendPasswordResetEmail(
  email: emailTextEditingController.text.trim()
  ).then((value){
    Fluttertoast.showToast(msg: "We Have Sent You An Email To Reset Password");
  }).onError((error, stackTrace) {
    Fluttertoast.showToast(msg: "Error Occured: \n ${error.toString()}");
  });
  }



final _formkey = GlobalKey<FormState>();
  @override

   
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(


       onTap: () {
        FocusScope.of(context).unfocus();
       },
       child: Scaffold(
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Column(
            children: [
              Image.asset(darkTheme? 'images/logo.png' : 'images/logo.png'),
           SizedBox(height: 20,),

           Text(
            'Reset Password',
            style: TextStyle(
              color: darkTheme? Colors.amber.shade400 : Colors.blue,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
           ),

Padding(padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),

child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Form(
      key: _formkey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
               children: [
           
              SizedBox(height: 20,),

        TextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50)
                ],
                decoration: InputDecoration(
                  hintText: 'email',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: darkTheme? Colors.black45 : Colors.grey.shade200,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                   borderSide: BorderSide(width: 0,
                  style: BorderStyle.none,
                  )
                  ),
                prefix:  Icon(Icons.person, color: darkTheme? Colors.amber.shade400 :Colors.grey,),
                ),
autovalidateMode:  AutovalidateMode.onUserInteraction,
validator: (text) {
  if(text == null || text.isEmpty){
    return 'Email can\'t be empty';
  } 
  if(text.length < 2){
    return 'Please Enter Valid Email';
  }  if(EmailValidator.validate(text) == true){
    return null;
  }
   if(text.length > 50){
    return 'Email can\'t be moore than 50 characters';
  } 
},

 onChanged: (text) => setState(() {
   emailTextEditingController.text = text;
 }
 ),
              ),

       
              SizedBox(height: 20,),

        
        
              SizedBox(height: 20,),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                  onPrimary: darkTheme ? Colors.black : Colors.white,

                  elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
                 minimumSize: Size(double.infinity, 50) 
                ),

                onPressed: (){
                  _submit();
                }, 
                child: Text(
                  
                'Recover Password',
                style: TextStyle(
                  fontSize: 20
                ),
                  
                  ),
                
                
                ),

                SizedBox(height: 20,),

                GestureDetector(

                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                },

                child: Text(
                  'Remember Yuur Password ? Login',
                  style: TextStyle( 
                    color: darkTheme? Colors.amber.shade400 : Colors.blue
                  ),
                ),

                ),
SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      'Don\'t and Account ?',
                      style: TextStyle(
                        color:  Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    SizedBox(width: 5,),
                  
                GestureDetector(

                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (c) => RegisterScreen()));
                },

                child: Text(
                  'Register',
                  style: TextStyle( 
                    color: darkTheme? Colors.amber.shade400 : Colors.blue
                  ),
                ),

                ),

                  ],
                )


            ],
            ),
           )],
            
           )

), 
            ],
          )
        ],
      ),
)
    );
  }
}