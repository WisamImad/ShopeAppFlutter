import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_section8/models/search_model.dart';
import 'package:learn_section8/modules/search/cubit/states.dart';
import 'package:learn_section8/shared/components/constanses.dart';
import 'package:learn_section8/shared/network/end_points.dart';
import 'package:learn_section8/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialStates());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void searchProduct(String text) {
    emit(SearchLoadingStates());
    DioHelper.postData(url: SEARCH, token: token, data: {
      'text': text,
    }).then((value) {
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccesStates());
    }).catchError((erorr) {
      emit(SearchErrorStates());
    });
  }
}
