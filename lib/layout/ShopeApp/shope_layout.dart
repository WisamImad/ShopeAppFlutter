import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/cubit.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/states.dart';
import 'package:learn_section8/modules/login/login_screen.dart';
import 'package:learn_section8/modules/search/search_screen.dart';
import 'package:learn_section8/shared/network/local/cache_helper.dart';

class ShopeLayout extends StatelessWidget {
  const ShopeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopeCubit, ShopeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopeCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('Shope App'),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchScreen()));
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          body: cubit.bottomScreen[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              cubit.ChangeCurrentIndex(index);
            },
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.apps), label: 'Cateogries'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorite'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}
