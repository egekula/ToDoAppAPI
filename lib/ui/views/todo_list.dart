import 'package:flutter/material.dart';
import 'package:todoapi/services/todo_services.dart';
import 'package:todoapi/ui/views/todo_add.dart';
import 'package:todoapi/widget/todo_card.dart';

import '../../utils/snackbar_helper.dart';
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchToDoList();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black45,
        title: const Text("To-Do List",),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(),),
          replacement: RefreshIndicator(
          onRefresh: fetchToDoList,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text("No To-do Item"),),
            child: ListView.builder(
                padding: EdgeInsets.all(7),
                itemCount: items.length,
                itemBuilder: (context,index){
                  final item = items[index] as Map;
                  final id = item["_id"] as String;
                  return ToDoCard(item: item, index: index, navigateEdit: NavigateToEditPage, deleteById: deleteById);
                }
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: NavigateToAddPage,
          label: const Text("Add")
      ),
    );
  }
  Future<void> NavigateToAddPage() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) =>AddPage() ));
    setState(() {
      isLoading = true;
    });
    fetchToDoList();
  }

  Future<void> NavigateToEditPage(Map item) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) =>AddPage(todo: item ) ));
    setState(() {
      isLoading = true;
    });
    fetchToDoList();

  }

  Future<void> fetchToDoList() async {
    final response = await ToDoService.fetchToDoList();
    if(response != null){
      setState(() {
        items = response;
      });
    }
    else{
      showSuccessMessage(context,"Something went wrong!");
    }
    setState(() {
      isLoading =false;
    });
  }

  Future<void> deleteById(String id) async {

    final success = await ToDoService.deleteById(id);
    if(success){
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });
    }
    else{
      showSuccessMessage(context,"To-do is not deleted");
    }
  }

}
