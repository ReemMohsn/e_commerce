import 'package:flutter_bloc/flutter_bloc.dart';

class MainHomeCubit extends Cubit<int> {
  MainHomeCubit() : super(0);

  void changeIndex(int index) {
    if (index == state) return;
    emit(index);
  }
}
