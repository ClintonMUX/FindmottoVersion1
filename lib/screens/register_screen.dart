import 'package:email_validator/email_validator.dart';
import 'package:findmotto/global/global.dart';
import 'package:findmotto/screens/login_screen.dart';
import 'package:findmotto/screens/forgot_password_screen.dart';
import 'package:findmotto/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import the firebase_auth package
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/cupertino.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmpasswordTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  void _submit() async {
// validate all form fields

if(_formkey.currentState!.validate()){

await firebaseAuth.createUserWithEmailAndPassword(
  email: emailTextEditingController.text.trim(),
 password: passwordTextEditingController.text.trim(),
 ).then((auth) async{

  currentUser = auth.user;

  if(currentUser != null){
    Map userMap = {
      "id": currentUser!.uid,
      "name":nameTextEditingController.text.trim(),
      "email":emailTextEditingController.text.trim(),
      "phone":phoneTextEditingController.text.trim(),

    };

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
    userRef.child(currentUser!.uid).set(userMap);
  }

  await Fluttertoast.showToast(msg: "Successfully Registered");
  Navigator.push(context, MaterialPageRoute(builder: (c) => Mainscreen()));
 }).catchError((ErrorMessage){
  Fluttertoast.showToast(msg: "Error Occurred: \n $ErrorMessage");
 });
 
 }
 else {
  Fluttertoast.showToast(msg: "Not All Fields Are Valid");
}
  }

  //declare a GlobalKey

  final _formkey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(

      onTap:() {
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
            'Register',
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
              TextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50)
                ],
                decoration: InputDecoration(
                  hintText: 'name',
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
    return 'Name can\'t be empty';
  } 
  if(text.length < 2){
    return 'Please Enter Valid Name';
  } if(text.length > 50){
    return 'Name can\'t be moore than 50 characters';
  } 
},
              
 onChanged: (text) => setState(() {
   nameTextEditingController.text = text;
 }),
              ),

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
           IntlPhoneField(
            showCountryFlag: true,
            dropdownIcon: Icon(
 Icons.arrow_drop_down,
              color: darkTheme? Colors.amber.shade400 :Colors.grey,

            ),
                 decoration: InputDecoration(
                  hintText: 'Phone',
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
               
                ),
onChanged: (text) => setState(() {
   phoneTextEditingController.text = text.completeNumber;
 }
 ),
           ),

              SizedBox(height: 20,),

        TextFormField(
          obscureText: !_passwordVisible,
                inputFormatters: [
        
                  LengthLimitingTextInputFormatter(50)
                 
                ],
                decoration: InputDecoration(
                  hintText: 'password',
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
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                  ),
                  onPressed: (){
                    setState(() {
                      // toggle eye
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
                ),
autovalidateMode:  AutovalidateMode.onUserInteraction,
validator: (text) {
  if(text == null || text.isEmpty){
    return 'Password can\'t be empty';
  } 
  if(text.length < 5){
    return 'Please Enter Valid Email';
  }  if(EmailValidator.validate(text) == true){
    return null;
  }
   if(text.length > 50){
    return 'Password can\'t be moore than 50 characters';
  } 
  return null;
},

 onChanged: (text) => setState(() {
   passwordTextEditingController.text = text;
 }
 ),
              ),

         SizedBox(height: 20,),

        TextFormField(
          obscureText: !_passwordVisible,
                inputFormatters: [
        
                  LengthLimitingTextInputFormatter(50)
                 
                ],
                decoration: InputDecoration(
                  hintText: 'confirm  password',
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
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                  ),
                  onPressed: (){
                    setState(() {
                      // toggle eye
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
                ),
autovalidateMode:  AutovalidateMode.onUserInteraction,
validator: (text) {
  if (text == null || text.isEmpty) {
    return 'Password can\'t be empty';
  }
  if (text.length < 5) {
    return 'Please enter a valid password';
  }
  if (text != passwordTextEditingController.text) {
    return 'Passwords do not match';
  }
  if (text.length > 50) {
    return 'Password can\'t be more than 50 characters';
  }
  return null;
},


 onChanged: (text) => setState(() {
   confirmpasswordTextEditingController.text = text;
 }
 ),
              ),

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
                  
                'Register',
                style: TextStyle(
                  fontSize: 20
                ),
                  
                  ),
                
                
                ),

                SizedBox(height: 20,),

                GestureDetector(

                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (c) => ForgotPassword()));
                },

                child: Text(
                  'Forgot Password',
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
                      'Have and Account ?',
                      style: TextStyle(
                        color:  Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    SizedBox(width: 5,),
                  
                GestureDetector(

                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                },

                child: Text(
                  'Sign In',
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