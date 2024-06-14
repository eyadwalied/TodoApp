import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Shared/bloc.dart';
import '../Shared/states.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CounterCubit, DadStates>(
        builder: (context, state) {
          var done=CounterCubit.get(context).archiveTasksScreen;
          return ListView.separated(
              itemBuilder: (context, index) => Dismissible(
                key:Key(done[index]['id'].toString()),
                onDismissed: (direction){
                  CounterCubit.get(context).deletfromdatabase(id: done[index]['id']);

                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Card(
                    elevation: 40,

                    color: Colors.grey[300],
                    child: Row(
                      children: [
                        CircleAvatar(
                            child: Text('${done[index]['time']}'),
                            radius: 40,
                            backgroundColor: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${done[index]['task']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                '${done[index]['date']}',
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
                          CounterCubit.get(context).updateDatabase(status: 'done',id:done[index]['id']);

                        }, icon:Icon(Icons.check_circle_outline,color: Colors.green,) ),
                        IconButton(onPressed: (){
                          CounterCubit.get(context).updateDatabase(status: 'Archive', id:done[index]['id'] );

                        }, icon:Icon(Icons.archive,) )

                      ],
                    ),
                  ),
                ),
              ),
              separatorBuilder:(context, index) => Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              itemCount: done.length);
        },
        listener: (context, state) {});;
  }
}

