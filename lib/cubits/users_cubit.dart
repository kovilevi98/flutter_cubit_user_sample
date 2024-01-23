import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_cubit/models/user.dart';

part 'users_cubit.freezed.dart';
part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(const UsersState.initial());

  fetchUsers() async {
    try {
      emit(const UsersState.loading());
      Dio dio = Dio();

      final res = await dio.get("https://jsonplaceholder.typicode.com/users");
      if (res.statusCode == 200) {
        final users = res.data.map<User>((item) {
          return User.fromJson(item);
        }).toList();

        emit(UsersState.success(users));
      } else {
        emit(
          UsersState.error("Error loading users: ${res.data.toString()}"),
        );
      }
    } catch (e) {
      emit(
        UsersState.error("Error loading users: ${e.toString()}"),
      );
    }
  }
}
