import 'package:flutter/material.dart';
import 'package:my_activity_tracker/core/utils/page_transition.dart';

popContext(context, [dynamic result]) {
  Navigator.of(context).pop(result);
}

pushContext(context, {required Widget route, Function(dynamic)? function}) {
  Navigator.push(context, createRoute(route)).then((value) {
    if (value != null && function != null) {
      function(value);
    }
  });
}

pushReplacementContext(context,
    {required Widget route, Function(dynamic)? function}) {
  Navigator.pushReplacement(context, createRoute(route)).then((value) {
    if (value != null) {
      function!(value);
    }
  });
}
