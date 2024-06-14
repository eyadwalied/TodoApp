import 'package:dolistlasteditioin/Shared/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../Shared/bloc.dart';

class DoList extends StatelessWidget {
  var myScaffold = GlobalKey<ScaffoldState>();
  var myForm = GlobalKey<FormState>();
  bool change = false;
  var TaskController = TextEditingController();
  var TimeController = TextEditingController();
  var DateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => CounterCubit()..creatDatabase(),
        child: BlocConsumer<CounterCubit, DadStates>(
          listener: (BuildContext context,  state) {
            if(state is InsertToDatabaseState){
              Navigator.pop(context);
            }
          },
          builder: (BuildContext context, DadStates state) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (change == true) {
                    if(myForm.currentState!.validate()) {
                      CounterCubit.get(context).insertToDatabase(tittle:TaskController.text , time: TimeController.text, date: DateController.text);

                      change = false;

                    }} else {
                    change = true;
                    myScaffold.currentState!.showBottomSheet((context) =>
                        Container(
                          child: Container(
                            color: Colors.grey[300],
                            padding: EdgeInsets.all(20),
                            child: Form(
                              key:myForm ,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                      controller: TaskController,
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return'Enter the text value ';
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: Text('TaskTittle'),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide()),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.green)),
                                        errorBorder:OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red)),
                                      )),


                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: TimeController,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Enter the time value ';
                                      }
                                    },
                                    decoration: InputDecoration(
                                        label: Text('TimeTiitle'),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide()),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.green))),
                                    onTap: () {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                          .then((value) {
                                        TimeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Enter the date  value ';
                                      }

                                    },
                                    controller: DateController,
                                    decoration: InputDecoration(
                                        label: Text('Datetittle'),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide()),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.green))),
                                    onTap: () {
                                      showDatePicker(
                                          firstDate: DateTime.now(),
                                          initialDate: DateTime.now(),
                                          context: context,
                                          lastDate:
                                          DateTime.parse('2030-12-30'))
                                          .then((value) {
                                        DateController.text=DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )).closed.then((value){
                      CounterCubit.get(context).changeIcon(icon: Icons.edit, show:false);

                    });
                  }
                  CounterCubit.get(context).changeIcon(icon: Icons.add, show:true);
                },
                child: Icon(CounterCubit.get(context).iconChange),
              ),
              key: myScaffold,
              appBar: AppBar(
                centerTitle: true,
                title: CounterCubit.get(context)
                    .tittles[CounterCubit.get(context).currentIndex],
              ),
              bottomNavigationBar: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
                      label: 'Tasks',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle),
                      label: 'Done',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      label: 'Archived',
                    ),
                  ],
                  elevation: 30,
                  currentIndex: CounterCubit.get(context).currentIndex,
                  onTap: (index) {
                    CounterCubit.get(context).changePages(index);
                  },
                  type: BottomNavigationBarType.fixed),
              body: CounterCubit.get(context).page[CounterCubit.get(context).currentIndex],
            );
          },
        ));
  }
}


