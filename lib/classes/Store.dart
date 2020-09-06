import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import 'package:virago/classes/FormofBirthControl.dart';
import 'package:virago/classes/Symptom.dart';
import 'package:virago/classes/Brand.dart';


class Store extends Model {
  List<FormofBirthControl> formsOfBirthControl;
  List<FormofBirthControl> usedFormsOfBirthControl = new List<FormofBirthControl>();
  List<Brand> usedBrands = new List<Brand>();
  List<Symptom> symptoms;

  static Store of(BuildContext context) => 
      ScopedModel.of<Store>(context);

  void addUsedForm(FormofBirthControl form) {
    this.usedFormsOfBirthControl.add(form);
  }

  void addUsedBrands(List<Brand> brands) {
    this.usedBrands.addAll(brands);
  }

}