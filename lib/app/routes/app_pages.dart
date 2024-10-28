import 'package:get/get.dart';
import 'package:twofcapital/app/modules/chat/views/chat_detail_view.dart';
import 'package:twofcapital/app/modules/chat/views/contacts_view.dart';
import 'package:twofcapital/app/modules/chat/views/group_chat_detail_view.dart';
import 'package:twofcapital/app/modules/todo/views/add_todo_view.dart';
import 'package:twofcapital/app/modules/todo/views/todo_detail_view.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/sign_up_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/todo/bindings/todo_binding.dart';
import '../modules/todo/views/todo_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const SIGNIN = Routes.AUTH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () =>  HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
      children: [
        GetPage(
          name: _Paths.CHATDETAIL,
          page: () =>  ChatDetailView(),
          binding: ChatBinding(),
        ),
        GetPage(
          name: _Paths.GROUPCHATDETAIL,
          page: () =>  GroupChatDetailView(),
          binding: ChatBinding(),
        ),
        GetPage(
          name: _Paths.CONTACTS,
          page: () =>  ContactsView(),
          binding: ChatBinding(),
        ),
      ]
    ),
    GetPage(
        name: _Paths.AUTH,
        page: () => AuthView(),
        binding: AuthBinding(),
        children: [
          GetPage(
            name: _Paths.SIGNUP,
            page: () => SignUpView(),
            binding: AuthBinding(),
          ),
          GetPage(
            name: _Paths.FORGOT,
            page: () => ForgotPasswordView(),
            binding: AuthBinding(),
          ),
        ]),
    GetPage(
      name: _Paths.TODO,
      page: () => const TodoView(),
      binding: TodoBinding(),
      children: [
        GetPage(
          name: _Paths.ADDTODO,
          page: () => AddTodoView(),
          binding: TodoBinding(),
        ),
        GetPage(
          name: _Paths.TODODETAIL,
          page: () => TodoDetailView(),
          binding: TodoBinding(),
        ),
      ]
    ),

  ];
}
