import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:twofcapital/app/modules/todo/controllers/todo_controller.dart';

import '../../auth/views/sign_up_view.dart';

class TodoDetailView extends GetView<TodoController>{
   TodoDetailView({super.key});
    final todo=Get.arguments;
   final _formKey=GlobalKey<FormState>();
   final TextEditingController _titleController=TextEditingController();
   final TextEditingController _descController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    Get.put(TodoController());
    _titleController.text=todo["title"]??"";
    _descController.text=todo["description"]??"";
    controller.isTodoPinned.value=todo["isPinned"];
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(() =>
          IconButton(onPressed:(){
              controller.isTodoPinned.value=!controller.isTodoPinned.value;
          } , icon:controller.isTodoPinned.value?const Icon(Icons.push_pin):const Icon(Icons.push_pin_outlined)),),
          IconButton(
              onPressed: () async {
                DateTime? selected = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2040),
                );
                if (selected != null) {
                  final TimeOfDay? pickedTime =
                  await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    var selectedDateTime = DateTime(
                      selected.year,
                      selected.month,
                      selected.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    controller.reminderTime.value =
                        selectedDateTime;
                  }
                }
              },
              icon: const Icon(
                Icons.alarm,
                size: 16,
              )),
          IconButton(onPressed:(){} , icon:const Icon(Icons.archive_outlined)),
          IconButton(onPressed:(){controller.deleteTodo(todo);} , icon:const Icon(Icons.delete)),
        ],
      ),
      body:SafeArea(child:LayoutBuilder(builder: (context, constraints) {
        return  Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      const Text("EditedAt: ",style:TextStyle(fontSize: 12),),
                      Text(todo['editedAt'],style:const TextStyle(fontSize: 11),),
                    ],
                  ),
                ),
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color:todo['color']!=0? Color((0xFF << 24) | (todo['color'] & 0x00FFFFFF)).withOpacity(0.5):CardTheme.of(context).color,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.3))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
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
                        todo['title']=_titleController.text;
                        todo['description']=_descController.text;
                        todo['isPinned']=controller.isTodoPinned.value;
                        controller.updateTodo(todo,controller.reminderTime.value);
                      }
                    },
                        style: ElevatedButton.styleFrom(padding:const EdgeInsets.all(16)),
                        child:controller.isUpdatingTodo.value?const AuthLoading(): const Text("Save")),
                    ))
              ],)
        );
      },))
    );
  }
}
