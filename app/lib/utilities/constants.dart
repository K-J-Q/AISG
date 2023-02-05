import 'package:flutter/material.dart';

const kTitleTextStyle = TextStyle(
  fontSize: 36.0,
);

const kCodeTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const kResultTextStyle = TextStyle(
  fontSize: 20.0,
);

const kTypeTextStyle = TextStyle(
  fontSize: 10.0,
  backgroundColor: Colors.black,
);

const kButtonTextStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.white,
);

const kTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(Icons.search, color: Colors.white, size: 30.0),
  hintText: 'Enter food name:',
  hintStyle: TextStyle(color: Colors.grey),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide(color: Colors.grey,width: 2),
  ),
);

const kBusTypeDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(5)),
  color: Colors.black,
);
