import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'Layout/home.dart';
import 'Shared/observer.dart';


main(){
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:DoList(),);
  }
}
