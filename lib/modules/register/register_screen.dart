import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/layout/ShopeApp/shope_layout.dart';
import 'package:learn_section8/modules/login/login_screen.dart';
import 'package:learn_section8/modules/register/cubit/cubit.dart';
import 'package:learn_section8/modules/register/cubit/states.dart';
import 'package:learn_section8/shared/components/components.dart';
import 'package:learn_section8/shared/components/constanses.dart';
import 'package:learn_section8/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => ShopeRegisterCubit(),
      child: BlocConsumer<ShopeRegisterCubit,ShopeRegisterStates>(
        listener: (context,state){
          if(state is ShopeRegisterSucessStates){
            if(state.registerModel.status == true){
              print("Register Screen Sucees = ");
              print(state.registerModel.message);
              print(state.registerModel.data!.token);
              print(state.registerModel.data!.name);
              print(state.registerModel.data!.phone);

              showToast(text: state.registerModel.message!, state: ToastState.SUCCES);

              CacheHelper.saveData2(
                  key: 'token', value: state.registerModel.data!.token)
                  .then((value) {
                token = state.registerModel.data!.token!;
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ShopeLayout()),
                        (route) => false);
              });
            }else {
              print(state.registerModel.message);
              print("Register Screen Error = ");

              showToast(text: state.registerModel.message!, state: ToastState.ERROR);
            }
          }
        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign Up".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          "SignUp now to browse our hot offers",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'name is Error or is not Exiset';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            focusColor: Colors.orange,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Email is Error or is not Exiset';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email),
                            focusColor: Colors.orange,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'phone is too Short';
                            }
                          },
                          onFieldSubmitted: (value) {
                            if (formKey.currentState!.validate()) {

                              print('True phone');
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            prefixIcon: Icon(Icons.phone),
                            focusColor: Colors.orange,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password is too Short';
                            }
                          },
                          onFieldSubmitted: (value) {
                              print('True login');
                          },
                          obscureText: ShopeRegisterCubit.get(context).isPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            focusColor: Colors.orange,
                            suffixIcon: Icons.remove_red_eye != null
                                ? IconButton(
                                onPressed: () {
                                  ShopeRegisterCubit.get(context).changePasswordVisibility();
                                },
                                icon: Icon(Icons.remove_red_eye))
                                : null,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopeRegisterLoadingStates,
                          builder: (context) => defaultButton(
                              text: 'sign up'.toUpperCase(),
                              function: () {
                                if(formKey.currentState!.validate()){
                                  ShopeRegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text
                                  );
                                }
                                print('True signUp');
                              }
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Alreday I have an account?',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => LoginScreen()), (
                                      route) => false);
                                },
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(color: Colors.orange),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
