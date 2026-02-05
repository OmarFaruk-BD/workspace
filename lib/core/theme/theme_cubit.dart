import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/theme/app_theme.dart';
import 'package:workspace/core/theme/dark_theme.dart';
import 'package:workspace/core/theme/light_theme.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(LightTheme());

  void toggleTheme() {
    if (state is LightTheme) {
      emit(DarkTheme());
    } else {
      emit(LightTheme());
    }
  }
}
