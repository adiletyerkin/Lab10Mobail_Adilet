import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterFormPage extends StatefulWidget{
  @override
  _RegisterFormPageState createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage>{
  bool _hidePass = true;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  List<String> _countries = ['Kazakhstan', 'Russia', 'Germany', 'France'];
  String _selectedCountry;

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void dispose(){
    _nameController.dispose();
     _phoneController.dispose();
     _emailController.dispose();
     _storyController.dispose();
     _passController.dispose();
     _confirmPassController.dispose();

    _nameFocus.dispose();
    _passFocus.dispose();
    _passFocus.dispose();

    super.dispose();
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus){
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Lab10 Refister Form"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              focusNode: _nameFocus,
              autofocus: true,
              onFieldSubmitted: (_){
                _fieldFocusChange(context, _nameFocus, _phoneFocus);
              },
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: "Full Name *",
                hintText: "What is your name?",
                prefixIcon: Icon(Icons.person),
                suffixIcon: GestureDetector(
                  onTap: (){
                    _nameController.clear();
                  },
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black, width: 2)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.blue, width: 2)
                ),
              ),
              validator: _validatename,
            ),
            SizedBox(height: 10),
            TextFormField(
              focusNode: _phoneFocus,
              onFieldSubmitted: (_){
                _fieldFocusChange(context, _phoneFocus, _passFocus);
              },
              controller: _phoneController,
              decoration: InputDecoration(
                  labelText: "Phone number *",
                hintText: "Where can we reach you?",
                helperText: "Phone format (XXX)XXX-XXXX",
                prefixIcon: Icon(Icons.call),
                suffixIcon: GestureDetector(
                  onLongPress: (){
                    _phoneController.clear();
                  },
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.black, width: 2)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.blue, width: 2)
                ),
              ),
              keyboardType: TextInputType.phone ,
              inputFormatters: [
                // FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter(RegExp(r'[()\d -]{1,15}$'),
                allow: true),
              ],
              validator: (value) => _validatorPhoneNum(value)
                  ? null
                  : "must be enteres as (###)###-####",
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: "Email Address",
                hintText: "Email Address",
                icon: Icon(Icons.mail)
              ),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.map),
                labelText: "Country?"
              ),
                items: _countries.map((country) {
                  return DropdownMenuItem(
                    child: Text(country),
                    value: country,
                  );
                }).toList(),
                onChanged: (data){
                print(data);
                setState(() {
                  _selectedCountry = data;
                });
                },
              value: _selectedCountry,
              validator: (val){
                return val == null ? "Please select a country" : null;
              },

            ),

            SizedBox(height: 20),
            TextFormField(
              controller: _storyController,
              decoration: InputDecoration(
                  labelText: "Life Story",
                hintText: "Tell  about yourself",
                helperText: "Keep it short",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100)
              ],

            ),
            SizedBox(height: 10),
            TextFormField(
              focusNode: _passFocus,
              controller: _passController,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: InputDecoration(
                  labelText: "Password *",
                hintText: "Enter the password",
                suffixIcon: IconButton(
                  icon: Icon(_hidePass ? Icons.visibility: Icons.visibility_off),
                  onPressed: (){
                    setState(() {
                      _hidePass = !_hidePass;
                    });
                  },
                ),
                icon: Icon(Icons.security)
              ),
              validator: _validatePassword,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _confirmPassController,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: InputDecoration(
                  labelText: "Confirm Password *",
                  hintText: "Confirm the password",
                  icon: Icon(Icons.border_color)
              ),
              validator: _validatePassword,
            ),
            SizedBox(height: 15),
            RaisedButton(
              onPressed: _submitForm,
              color: Colors.green,
              child: Text("Submit Form",
                style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );

  }
  void _submitForm(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      _showDialog(_nameController.text);
      print('Name: ${_nameController.text}');
      print('phone: ${_phoneController.text}');
      print('Email: ${_emailController.text}');
      print('Story: ${_storyController.text}');
      print('Counrty: ${_selectedCountry}');
    }
    else{
      _showMeassage("Form is not valid! Please reviw and correct!");
    }
  }

  String _validatename(String value){
    final _nameExp = RegExp(r'^[A-Za-z ]+$');
    if(value.isEmpty){
      return "Name is required";
    }
    else if(!_nameExp.hasMatch(value)){
      return "Please enter alphabetic charaters";
    }
    else{
      return null;
    }
  }
  
  bool _validatorPhoneNum(String input){
    final _phoneExp = RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
        return _phoneExp.hasMatch(input);
  }
  
  String _validateEmail(String value){

    if(value.isEmpty){
      return "email is required";
    }else if(!_emailController.text.contains('@')){
      return "Invalid email";
    }
    else{
      return null;
    }
  }

  String _validatePassword(String value){
    if(_passController.text.length != 8){
      return "8 characters required!";
    }else if(_confirmPassController.text != _passController.text){
      return "password does not match";
    }
    else{
      return null;
    }
  }

  void _showMeassage(String message){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        content:
        Text(message,
          style:
          TextStyle(
            color: Colors.black,
            fontWeight:FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _showDialog(String name){
    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text("Registration successful!"),
            content: Text(
              '$name is now a verified register form',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ) ,
            actions: [
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child:
                  Text('Verified', style: TextStyle(
                    color: Colors.green,
                    fontSize: 18
                  ),
                  )
              )
            ],

          );
      }
    );
  }



}
