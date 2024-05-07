import 'package:flutter/material.dart';
import 'package:todoapi/services/todo_services.dart';
import '../../utils/snackbar_helper.dart';

class AddPage extends StatefulWidget {
  final Map? todo;
  const AddPage({super.key, this.todo});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final tfTitleController = TextEditingController();
  final tfDescController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      setState(() {
        isEdit = true;
        final title = todo["title"];
        final desc = todo["description"];
        tfTitleController.text = title;
        tfDescController.text = desc;
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: isEdit ? Text("Edit Page"):Text("Add Page"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: tfTitleController,
            decoration: InputDecoration(hintText: "Title"),
          ),
          TextField(
            controller: tfDescController,
            decoration: InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: isEdit ? Text("Update"):Text("Submit"),
          )
        ],
      ),
    );
  }
  Future<void> submitData() async {

    final success = await ToDoService.submitData(body);
    if(success){
      tfTitleController.text = "";
      tfDescController.text = "";
      showSuccessMessage(context,"Successful");
    }
    else{
      showSuccessMessage(context,"Failed");
    }
  }
  Future<void> updateData() async {
    final todo = widget.todo;
    if(todo == null){
      return;
    }
    final id = todo["_id"];

    final success = await ToDoService.updateData(id, body);
    if(success){
      tfTitleController.text = "";
      tfDescController.text = "";
      showSuccessMessage(context,"Successful");
    }
    else{
      showSuccessMessage(context,"Failed");
    }
  }
  Map get body{
    final title = tfTitleController.text;
    final desc = tfDescController.text;
    return {
      "title": title,
      "description": desc,
      "is_completed": false
    };
  }

}
