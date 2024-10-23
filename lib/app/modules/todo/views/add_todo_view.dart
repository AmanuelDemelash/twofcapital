import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twofcapital/app/modules/auth/views/sign_up_view.dart';
import 'package:twofcapital/app/modules/todo/controllers/todo_controller.dart';

class AddTodoView extends GetView<TodoController> {
   AddTodoView({super.key});

  final _formKey=GlobalKey<FormState>();
  final TextEditingController _titleController=TextEditingController();
  final TextEditingController _descController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    Get.put(TodoController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Form(
            key: _formKey,
              child: Column(
            children: [
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.3))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Title',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0 * 1.5, vertical: 16.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                             controller: _titleController,
                            ),
                          ),
                         Obx(() =>IconButton(onPressed:() => controller.isPinned.value=!controller.isPinned.value, icon:
                         controller.isPinned.value?const Icon(Icons.push_pin): const Icon(Icons.push_pin_outlined))
                         )
                        ],
                      ),

                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'take a note...',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                          BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                       controller: _descController,
                    ),
                  ],
                ),
              ),
              Container(
                margin:const EdgeInsets.all(10),
                width: Get.width,
                child:Obx(() =>ElevatedButton(onPressed: () {
                  _formKey.currentState!.save();
                  if(_titleController.text.isEmpty && _descController.text.isEmpty){
                  }else{
                    controller.addTodo(_titleController.text, _descController.text,controller.isPinned.value);
                  }
                },
                    style: ElevatedButton.styleFrom(padding:const EdgeInsets.all(16)),
                    child:controller.isAddingTodo.value?const AuthLoading(): const Text("Save")),
              ))
            ],)
          );
        },)

      ),
    );
  }
}
