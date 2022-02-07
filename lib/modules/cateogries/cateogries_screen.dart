import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/cubit.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/states.dart';
import 'package:learn_section8/models/categories_model.dart';
import 'package:learn_section8/shared/components/components.dart';

class CateogriesScreen extends StatelessWidget {
  const CateogriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopeCubit,ShopeStates>(
      listener: (context,state){},
      builder: (context,state){
        return ConditionalBuilder(
          condition: ShopeCubit.get(context).categoriesModel != null,
          builder: (context) => ListView.separated(
              itemBuilder: (context,index) => buildeCatItem(ShopeCubit.get(context).categoriesModel!.data!.data[index]),
              separatorBuilder: (context,index) => myDivider(),
              itemCount: ShopeCubit.get(context).categoriesModel!.data!.data.length
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildeCatItem(CategoriesData data) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(data.image),
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              data.name,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Spacer(),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      );
}
