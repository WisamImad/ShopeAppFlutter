import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/cubit.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/states.dart';
import 'package:learn_section8/models/categories_model.dart';
import 'package:learn_section8/models/home_model.dart';
import 'package:learn_section8/shared/components/components.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopeCubit, ShopeStates>(
      listener: (context, state) {
        if (state is ShopeSuccesChangeFavoritesStates) {
          if (!state.model.state) {
            showToast(
                text: state.model.message,
                state: ToastState.ERROR
            );
          } else{
            showToast(
                text: state.model.message,
                state: ToastState.SUCCES
            );
          }
        }
      },
      builder: (context, state) {
        var cubit = ShopeCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.homeModel != null &&
                cubit.categoriesModel != null,
            builder: (context) => ProductsBuilder(
                ShopeCubit.get(context).homeModel!,
                ShopeCubit.get(context).categoriesModel!,
                context),
            fallback: (context) => Center(child: CircularProgressIndicator()));
      },
    );
  }
}

Widget ProductsBuilder(
        HomeModel model, CategoriesModel categoriesModel, context) =>
    SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
              items: model.data!.banners
                  .map((e) => Image(
                        image: NetworkImage('${e.image}'),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              )),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 100.0,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          CatogriesBuilder(categoriesModel.data!.data[index]),
                      separatorBuilder: (context, index) => SizedBox(
                            width: 10.0,
                          ),
                      itemCount: categoriesModel.data!.data.length),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'New Products',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 1 / 1.61,
              children: List.generate(
                  model.data!.products.length,
                  (index) =>
                      buildGradeProducts(model.data!.products[index], context)),
            ),
          ),
        ],
      ),
    );

Widget CatogriesBuilder(CategoriesData data) => Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Image(
          image: NetworkImage(data.image),
          height: 100.0,
          width: 100.0,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.8),
          width: 100.0,
          child: Text(
            data.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );

Widget buildGradeProducts(ProductModel productModel, context) => Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(alignment: AlignmentDirectional.bottomStart, children: [
            Image(
              image: NetworkImage('${productModel.image}'),
              width: double.infinity,
              height: 200,
            ),
            if (productModel.discount != 0)
              Container(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    'DICCOUNT',
                    style: TextStyle(fontSize: 8.0, color: Colors.white),
                  ),
                ),
              ),
          ]),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, height: 1.3),
                ),
                Row(
                  children: [
                    Text(
                      '${productModel.price.round()}',
                      style: TextStyle(fontSize: 12.0, color: Colors.orange),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    if (productModel.discount != 0)
                      Text(
                        '${productModel.oldPrice.round()}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopeCubit.get(context)
                            .changeFavorites(productModel.id);
                        print(productModel.id);
                      },
                      icon: CircleAvatar(
                        backgroundColor: ShopeCubit.get(context)
                                    .favorite[productModel.id]!
                            ? Colors.orange
                            : Colors.grey,
                        radius: 15.0,
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                      iconSize: 15,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
