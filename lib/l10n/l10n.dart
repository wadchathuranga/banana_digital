import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('si'),
  ];

  static getLanguage(String code) {
    switch (code) {
      case 'si':
        return "සිංහල";
      default:
        return 'English';
    }
  }
}