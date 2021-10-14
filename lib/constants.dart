import 'package:flutter/material.dart';

// styles
const kHeadingStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

const kHintStyle = TextStyle(
  fontSize: 13.0,
  letterSpacing: 1.2,
);

// border
var kOutlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: const BorderSide(color: Colors.transparent),
);

var kErrorOutlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: const BorderSide(color: Colors.red),
);

const kLoaderBtn = SizedBox(
  height: 20.0,
  width: 20.0,
  child: CircularProgressIndicator(
    strokeWidth: 1.5,
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  ),
);
