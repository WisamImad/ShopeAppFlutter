import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_section8/layout/ShopeApp/cubit/cubit.dart';
import 'package:learn_section8/shared/cubit/cubit.dart';

// هنا نستخدم الويجت المكرر الي راح نستدعيها في كا مكان

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.orange,
  required String text,
  required Function function,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text.toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: background,
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  required String? Function(String?)? validator,
  required String label,
  bool ispassword = false,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPassed,
}) =>
    TextFormField(
      cursorColor: Colors.orange,
      controller: controller,
      keyboardType: type,
      obscureText: ispassword,
      onFieldSubmitted: (s) {
        onSubmit!(s);
      },
      validator: validator,
      onChanged: (s) {
        print('$s');

      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        focusColor: Colors.orange,
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPassed!();
                },
                icon: Icon(suffix))
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model , context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: (){
                  AppCubit.get(context).updateData(states: "done", id: model['id']);
                },
                icon: Icon(Icons.check_box,color: Colors.purple,)
            ),
            IconButton(
                onPressed: (){
                  AppCubit.get(context).updateData(states: "archive", id: model['id']);
                },
                icon: Icon(Icons.archive,color: Colors.black54,)
            ),
          ],
        ),
      ),
  onDismissed: (direcation){
    AppCubit.get(context).deleteData(id: model['id']);
  },
);

Widget tasksBuilder({
  required List<Map> task,
}){
  return task.length > 0
      ? ListView.separated(
      itemBuilder: (context, index) {
        print('task status ${task[index]['status']}');
        return buildTaskItem(task[index], context);
      },
      separatorBuilder: (context, index) => myDivider(),
      itemCount: task.length)
      : Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,color: Colors.grey,size: 80,),
        Text(
          "No Taske Yet, Please Add Some Tasks",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey
          ),
        )
      ],
    ),
  );
}

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(start: 20.0),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

Widget buildArticleItem(article,context) =>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  '${article['urlToImage']}'),
            )
        ),
      ),
      SizedBox(
        width: 20,
      ),
      Expanded(
        child: Container(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                    '${article['title']}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style:
                    Theme.of(context).textTheme.bodyText1,
                  )),
              Text('${article['publishedAt']}',style: TextStyle(
                color: Colors.grey,
              ),),
            ],
          ),
        ),
      )
    ],
  ),
);

Widget articleBuilder(list, BuildContext context)=>ConditionalBuilder(
  condition: list.length>0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildArticleItem(list[index],context),
    separatorBuilder: (context, index) => myDivider(),
    itemCount: 10,
  ),
  fallback: (context) => Center(child: CircularProgressIndicator()),
);

void showToast({
  required String text,
  required ToastState state,
})=>
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      backgroundColor: changeColorState(state),
      textColor: Colors.white,
      fontSize: 16.0
  );

enum ToastState{SUCCES,ERROR,WARNING}

Color? changeColorState(ToastState state){
  Color color;
  switch(state){
    case ToastState.SUCCES:
      color = Colors.green;
    break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;
  }
}

Widget builderListProducts(model,context,{bool isOldPrice = true}){
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height: 120.0,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.image.toString()),
                width: 120.0,
                height: 120.0,
              ),
              if (model.discount != 0 && isOldPrice)
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: Text(
                    'DISCOUNT',
                    style: TextStyle(
                      fontSize: 8.0,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.3,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      model.price.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    if (model.discount != 0 && isOldPrice)
                      Text(
                        model.oldPrice.toString(),
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopeCubit.get(context).changeFavorites(model.id!);
                      },
                      icon: CircleAvatar(
                        radius: 15.0,
                        backgroundColor:
                        ShopeCubit.get(context)
                            .favorite[model.id]!
                            ? Colors.orange
                            : Colors.grey,
                        child: Icon(
                          Icons.favorite_border,
                          size: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

