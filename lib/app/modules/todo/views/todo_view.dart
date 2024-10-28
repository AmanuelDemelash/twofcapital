import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:twofcapital/app/modules/auth/views/sign_up_view.dart';
import 'package:twofcapital/app/routes/app_pages.dart';
import 'package:twofcapital/app/utils/colorConstant.dart';
import '../../../controllers/app_authentication_controller.dart';
import '../controllers/todo_controller.dart';

class TodoView extends GetView<TodoController> {
  const TodoView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(TodoController());
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Search your note',
            filled: false,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16.0 * 1.5, vertical: 16.0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius:
              BorderRadius.all(Radius.circular(50)),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
           CircleAvatar(
            child: Text(controller.user.displayName!.substring(0,2).toUpperCase()),
          ),
          const SizedBox(width: 10,),
        ],
      ),
      drawer: AppDrawer(controller: controller),
      body: SafeArea(
        child:LayoutBuilder(builder:(context, constraints) {
         return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Welcome Back!",style: TextStyle(fontSize: 20),),
                    Text(controller.user.displayName!.toUpperCase(),style: const TextStyle(fontSize: 24),),
                  ],
                ),
              ),
              Container(
                width: Get.width,
                margin:const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() =>IconButton(onPressed:() {
                      controller.isGridView.value=!controller.isGridView.value;
                    }, icon:!controller.isGridView.value?const Icon(Icons.grid_view):const Icon(Icons.align_horizontal_left)),),
                  GestureDetector(
                    onTap:()=>Get.toNamed(Routes.ADDTODO),
                    child: Container(
                      width:100,
                      padding:const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ColorConstant.primaryColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child:const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add),Text("Add")],),
                    ),
                  )
                ],),
              ),
              Expanded(
                child:StreamBuilder(stream:controller.todoRef.onValue, builder:(context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child:AuthLoading());
                  }
                  // Check for errors
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}')); // Show error message
                  }
                  // Check if data is available
                  if (!snapshot.hasData || snapshot.data==null || snapshot.data!.snapshot.value==null) {
                    return const Center(child: Text('No todos found.')); // Show no data message
                  }
                  List<Map<dynamic, dynamic>>? todos;
                  if (snapshot.data != null && snapshot.data!.snapshot.value != null) {
                    Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                    todos = data.entries
                        .map((entry) => {
                      'id': entry.key,
                      ...entry.value as Map<dynamic, dynamic>,
                    }).toList()??[];
                    todos.where((element) => element['userId']==controller.user.uid || (element['collaborators']as Map).containsKey(controller.user.uid),);
                    List<Map> pinnedTodos = todos.where((todo) => todo['isPinned'] ?? false).toList();
                    List<Map> unpinnedTodos = todos.where((todo) => !(todo['isPinned'] ?? false)).toList();
                    todos = pinnedTodos + unpinnedTodos;
                  }else{
                    todos=[];
                  }
                  return   Obx(() =>MasonryGridView.count(
                    padding: const EdgeInsets.all(10),
                    crossAxisCount:controller.isGridView.value? 2:1,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount:todos!.length,
                    itemBuilder: (context, index) {
                      final collab=todos![index]['collaborators'] as Map<dynamic,dynamic>;
                      return GestureDetector(
                        onTap: () => Get.toNamed(Routes.TODODETAIL,arguments: todos![index]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Visibility(
                              visible:todos[index]["isPinned"],
                              child:const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: [
                                      Icon(Icons.push_pin,size: 13,),
                                      Text("pinned",style: TextStyle(fontSize: 11),),
                                    ],
                                  ),
                                ),
                            ),
                             Card(
                              elevation: 0.8,
                               color:todos[index]['color']!=0? Color((0xFF << 24) | (todos[index]['color'] & 0x00FFFFFF)).withOpacity(0.6):CardTheme.of(context).color,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration:BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(todos[index]['title'],style:const TextStyle(fontSize: 18),),
                                    Text(todos[index]['description'],textAlign: TextAlign.start,style:const TextStyle(fontSize:13)),
                                    todos[index]['reminder']!=null?Container(
                                      padding:const EdgeInsets.all(5),
                                      margin:const EdgeInsets.only(top: 10,bottom: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          border:Border.all(color: Colors.white.withOpacity(0.2))
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.watch_later_outlined,size: 12,),
                                            Text(todos[index]['reminder'].toString().substring(12),style:const TextStyle(fontSize: 11),),
                                          ],
                                        )):const Text(""),
                                     Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AvatarStack(
                                          width: 43,
                                          height:30,
                                          avatars:List.generate(collab.keys.toList().length, (index) {
                                          return  NetworkImage('https://i.pravatar.cc/150?img=1');
                                          },),
                                        ),
                                      ],

                                    )

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                  );

                },)
              ),
            ],
          );
        },)

      )
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.controller,
  });

  final TodoController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: CardTheme.of(context).color
            ),
            currentAccountPicture: CircleAvatar(
              child:Text(controller.user.displayName!.toUpperCase().substring(0,1),) ,
            ),
            accountName:Text(controller.user.displayName!.toUpperCase(),),
              accountEmail:Text(controller.user.email!),
          ),
          Container(
            width: Get.width,
            margin:const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                 height:Get.height/1.9,
                ),
                SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding:const EdgeInsets.all(15)
                      ),
                      onPressed:() {
                        Get.find<AppAuthenticationController>().logout();
                      }, child:const Text("LogOut",style: TextStyle(color: Colors.white),)),
                ),
              ],
            ),
          )
    
        ],
      ),
    );
  }
}
