import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/cubit.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/states.dart';
import 'package:learn_section8/shared/components/components.dart';
import 'package:learn_section8/shared/components/constanses.dart';

class SettingsScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopeCubit, ShopeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopeCubit
            .get(context)
            .userModel;

        nameController.text = model.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return ConditionalBuilder(
          condition: ShopeCubit
              .get(context)
              .userModel != null,
          builder: (context) =>
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if(state is ShopeLoadingUpdateUserStates)
                        LinearProgressIndicator(),
                        SizedBox(height: 20,),
                        defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            label: 'Name',
                            prefix: Icons.person,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'name must be not Empty';
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: 20,),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.name,
                            label: 'Email',
                            prefix: Icons.email,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'email must be not Empty';
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: 20,),
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.name,
                            label: 'Phone',
                            prefix: Icons.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'phone must be not Empty';
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: 20,),
                        defaultButton(
                            text: 'Update',
                            function: () {
                              if(formKey.currentState!.validate()){
                                ShopeCubit.get(context).updateUserData(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    email: emailController.text
                                );
                              }
                            }
                        ),
                        SizedBox(height: 20,),
                        defaultButton(
                            text: 'Logout',
                            function: () {
                              signOut(context);
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          fallback: (context) => Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }
}