bool isEmail(val) {
  if (val == null) return false;
  RegExp exp = new RegExp(r'^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$');
  final regRes = exp.hasMatch(val);
  return regRes;
}