import 'package:dolistlasteditioin/Shared/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Shared/bloc.dart';

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CounterCubit, DadStates>(
        builder: (context, state) {
          var tasks = CounterCubit.get(context).newTaskScreen;

          return ListView.separated(
              itemBuilder: (context, index) => Dismissible(
                key:Key(tasks[index]['id'].toString()),
                onDismissed: (direction){
                  CounterCubit.get(context).deletfromdatabase(id: tasks[index]['id']);

                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    color: Colors.grey[300],
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Text('${tasks[index]['time']}'),
                          radius: 40,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${tasks[index]['task']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                '${tasks[index]['date']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(onPressed: (){
                          CounterCubit.get(context).updateDatabase(status: 'done', id:tasks[index]['id']);

                        }, icon:Icon(Icons.check_circle_outline,color: Colors.green,) ),
                        IconButton(onPressed: (){
                          CounterCubit.get(context).updateDatabase(status: 'Archive', id:tasks[index]['id']);

                        }, icon:Icon(Icons.archive,) )

                      ],
                    ),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              itemCount: tasks.length);
        },
        listener: (context, state) {});
  }
}
