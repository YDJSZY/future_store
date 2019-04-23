bool isEmail(val) {
  if (val == null) return false;
  RegExp exp = new RegExp(r'^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$');
  final regRes = exp.hasMatch(val);
  return regRes;
}

dynamic divPrecision({val, precision}) {
  var _precision = precision == null ? 1e8 : precision;
  return int.parse(val) / _precision;
}