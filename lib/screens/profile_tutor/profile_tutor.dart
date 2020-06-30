import 'package:flutter/material.dart';
import 'package:petsaojoao/models/user/user_model.dart';
import 'package:petsaojoao/screens/register_tutor/register_tutor.dart';

class ProfileTutor extends StatefulWidget {
  @override
  _ProfileTutorState createState() => _ProfileTutorState();
}

class _ProfileTutorState extends State<ProfileTutor> {
  User user = User();

  @override
  Widget build(BuildContext context) {
    return RegisterTutor();
  }
}
