import 'dart:io';

import 'package:athlete_app_bloc/logic/blocs/auth_bloc/auth_bloc_bloc.dart';
import 'package:athlete_app_bloc/logic/blocs/logIn_bloc/login_bloc.dart';
import 'package:athlete_app_bloc/logic/services/validators.dart';
import 'package:athlete_app_bloc/presentation/widgets/custom_button.dart';
import 'package:athlete_app_bloc/presentation/widgets/custom_text_field.dart';
import 'package:athlete_app_bloc/utils/appServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final formKey = GlobalKey<FormState>();

  String firstName = '';

  String lastName = '';

  String gender = '';

  String birthDate = '';
  var birthDateController=TextEditingController();

  File? profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("On Boarding Screen")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                    onTap: () async {
                      XFile? file = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (file != null) {
                        setState(() {
                          profileImage = File(file.path);
                        });
                      }
                    },
                    child: Container(
                      child: profileImage == null
                          ? Icon(
                              Icons.image,
                              size: 50,
                            )
                          : Image.file(
                              profileImage!,
                              width: 100,
                              fit: BoxFit.contain,
                            ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    hintText: 'First name',
                    validator: Validators().validateField,
                    onChanged: (value) {
                      firstName = value!;
                      return null;
                    }),
                CustomTextField(
                    hintText: 'Last Name',
                    validator: Validators().validateField,
                    onChanged: (value) {
                      lastName = value!;
                      return null;
                    }),
                CustomTextField(
                    hintText: 'Gender',
                    validator: Validators().validateField,
                    onChanged: (value) {
                      gender = value!.toUpperCase();
                      return null;
                    }),
                CustomTextField(
                  controller:birthDateController ,
                    enable: false,

                    hintText: 'DOB',
                    validator: Validators().validateField,
                    onTap: ()async{
                   var date=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1975,1,1), lastDate: DateTime.now());
                   if(date!=null){
                     birthDateController.text=date.toString();
                   }
                    },
                    
                    onChanged: (value) {
                      birthDate = value!;
                      return null;
                    }),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is OnBoardingError) {
                      AppServices.showSnackBar(context, state.msg);
                    }
                  },
                  builder: (context, state) {
                    if (state is OnBoardingLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(state is OnBoardingSuccess){
                      context.read<AuthBloc>().add(NewLoggedIn(user: state.user));
                    }
                    return CustomButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (validateOther()) {
                              context.read<LoginBloc>().add(OnBoardingFormSubmitted(profileImage: profileImage, lastName: lastName, firstName: firstName, dob: birthDate, gender: gender));
                            }
                          }
                        },
                        title: 'Submit');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateOther() {
    if (profileImage == null) {
      AppServices.showSnackBar(context, 'Please choose a profile image');
      return false;
    }
    if(birthDateController.text.isEmpty){
      AppServices.showSnackBar(context, 'Please choose a date of birth');
      return false;
    }
    return true;
  }
}
