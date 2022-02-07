import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/cubit.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/states.dart';
import 'package:learn_section8/models/favorites_model.dart';
import 'package:learn_section8/models/home_model.dart';
import 'package:learn_section8/shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<ShopeCubit,ShopeStates>(
      listener: (context,state){},
      builder: (context,state){
        return ConditionalBuilder(
            condition: state is! ShopeLoadingGetFavoritesStates,
            builder: (context) =>
                ListView.separated(
                itemBuilder: (context,index) => builderListProducts(ShopeCubit.get(context).favoritesModel!.data!.data![index].product,context),
                    separatorBuilder: (context,index) => myDivider(),
                    itemCount: ShopeCubit.get(context).favoritesModel!.data!.data!.length),
            fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

}
