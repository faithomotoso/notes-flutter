import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

AppBar appBar({String title}){
  return AppBar(
    title: Text(title),
  );
}

TextStyle titleTextStyle({@required context}) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: Theme.of(context).textTheme.title.fontSize
);