import 'package:flutter/material.dart';

class ToDoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;
  const ToDoCard({super.key,required this.item, required this.index, required this.navigateEdit, required this.deleteById});

  @override
  Widget build(BuildContext context) {
    final id = item["_id"] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.black45,
            child: Text("${index+1}")
        ),
        title: Text(item["title"]),
        subtitle: Text(item["description"]),
        trailing: PopupMenuButton(
          onSelected: (value){
            if(value == "edit"){
              navigateEdit(item);
            }
            else if(value == "delete"){
              deleteById(id);
            }
          },
          itemBuilder: (context){
            return [
              PopupMenuItem(
                  child: Text("Edit"),
                  value: "edit"
              ),
              PopupMenuItem(
                  child: Text("Delete"),
                  value: "delete"

              ),

            ];
          },
        ),
      ),
    );
  }
}
