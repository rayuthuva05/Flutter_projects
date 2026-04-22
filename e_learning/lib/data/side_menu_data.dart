import 'package:e_learning/models/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Home'),
    MenuModel(icon: Icons.menu_book_sharp, title: 'Lessions'),
    MenuModel(icon: Icons.pending_actions_rounded, title: 'Exersice'),
    MenuModel(icon: Icons.scale_sharp, title: 'Exam')
  ];
}
