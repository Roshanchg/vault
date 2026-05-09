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
}
