import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:dolistlasteditioin/Shared/states.dart';
import 'package:dolistlasteditioin/Modules/tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../Modules/archived.dart';
import '../Modules/done.dart';

class CounterCubit extends Cubit<DadStates>{
  CounterCubit():super(InitialState());
  static CounterCubit get(context)=>BlocProvider.of(context);
  int currentIndex=0;
  List <Widget>page=[
    NewTaskScreen(),
    DoneScreen(),
    ArchivePage()
  ];
  List<Map>newTaskScreen=[];
  List<Map>doneTaskScreen=[];
  List<Map>archiveTasksScreen=[];
  late Database database;
  bool change=false;
  List <Widget>tittles=[
    Text('Tasks'),
    Text('Done'),
    Text('Archived')
  ];

  IconData iconChange=Icons.edit;
  Void? changePages (int index){
    currentIndex=index;
    emit(ChangeBottomNavgiateState());
  }
  Void? changeIcon({@required icon , @required show}){
    iconChange=icon;
    change=false;


    emit(ChangeIconState());

  }
  void creatDatabase() async{
    await openDatabase('todolist',

        version: 1,
        onCreate:(database,version)async{
          print('database created');
          await database.execute('Create Table tasks(id INTEGER PRIMARY KEY,task TEXT,time TEXT,date TEXT,status TEXT)').then((value) {print('table created');});
        } ,
        onOpen: (database){
          getDatabase(database);
          print('databaseOpened');


        }
    ).then((value){
      database=value;
      emit(CreatDatabaseState());
    });
  }
  void insertToDatabase({required String tittle,required String time,required date}) async{
    await database.transaction((txn)async{
      await txn.rawInsert('INSERT INTO tasks(task,time,date,status) VALUES("$tittle","$time","$date","new")');
    }).then((value) => print('values added $value'));
    emit(InsertToDatabaseState());
    getDatabase(database);
  }

  void getDatabase(database){
    newTaskScreen=[];
    doneTaskScreen=[];
    archiveTasksScreen=[];

    database.rawQuery('SELECT * FROM tasks').then((value) {

      print(value);
      value.forEach((element){
        if(element['status']=='new'){
          newTaskScreen.add(element);
        }
        else if(element['status']=='done'){
          doneTaskScreen.add(element);
        }
        else{
          archiveTasksScreen.add(element);
        }});
      emit(GetFromDatabaseState());


    } );
  }
  void updateDatabase({required String status ,required int id })async{
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ? ',
        ['$status',id]).then((value) {
          getDatabase(database);

      emit(UpdateDatabaseState());

    });

  }
  void deletfromdatabase({required int id }){
     database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
       getDatabase(database);
       emit(DeleteDatabaseState());});
  }



}
