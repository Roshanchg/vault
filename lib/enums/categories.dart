import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum CATEGORIES {
  GOOGLE,
  MICROSOFT,
  GITHUB,
  FACEBOOK,
  INSTAGRAM,
  SCHOOL,
  BANK,
  DEFAULT,
}

extension CategoriesExtension on CATEGORIES {
  AssetImage get imageAsset {
    return AssetImage("assets/icons/${this.name.toLowerCase()}.png");
  }

  static CATEGORIES? fromName(String name) {
    return CATEGORIES.values.firstWhere((item) => item.name == name);
  }

  String get prettyName {
    return name[0] + name.substring(1).toLowerCase();
  }
}
