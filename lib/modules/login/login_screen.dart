import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_section8/layout/ShopeApp/shope_layout.dart';
import 'package:learn_section8/modules/login/cubit/cubit.dart';
import 'package:learn_section8/modules/login/cubit/states.dart';
import 'package:learn_section8/modules/register/register_screen.dart';
import 'package:learn_section8/shared/components/components.dart';
import 'package:learn_section8/shared/components/constanses.dart';
import 'package:learn_section8/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
          listener: (context, state) {
        if (state is ShopLoginSuccessState) {
          if (state.loginModel.status == true) {
            print(state.loginModel.message);
            print("انت فين يا عم الحج ");
            print(state.loginModel.data!.token);
            print(state.loginModel.data!.name);
            print(state.loginModel.data!.phone);

            showToast(text: state.loginModel.message!, state: ToastState.SUCCES);

            CacheHelper.saveData2(
                    key: 'token', value: state.loginModel.data!.token)
                .then((value) {
                  token = state.loginModel.data!.token!;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ShopeLayout()),
                  (route) => false);
            });
          } else {
            print(state.loginModel.message);
            print("انت فين يا عم الحج ");

            showToast(text: state.loginModel.message!, state: ToastState.ERROR);
          }
        }
      }, builder: (context, state) {
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
                        "Login".toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        "login now to browse our hot offers",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30,
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
                        height: 30,
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
                          if (formKey.currentState!.validate()) {
                            ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text);
                            print('True login');
                          }
                        },
                        obscureText: ShopLoginCubit.get(context).isPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          focusColor: Colors.orange,
                          suffixIcon: Icons.remove_red_eye != null
                              ? IconButton(
                                  onPressed: () {
                                    ShopLoginCubit.get(context)
                                        .changePasswordVisibility();
                                  },
                                  icon: Icon(Icons.remove_red_eye))
                              : null,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopLoginLoadingState,
                        builder: (context) => defaultButton(
                            text: 'Login'.toUpperCase(),
                            function: () {
                              if (formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                                print('True login');
                              }
                            }),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account?',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => RegisterScreen()), (
                                    route) => false);
                              },
                              child: Text(
                                'REGISTER',
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
      }),
    );
  }
}
