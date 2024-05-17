final RegExp emailValidation = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
final RegExp passValidation =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
final RegExp nameValidation =
    RegExp(r'^[a-zA-ZÀ-ÿ\u00f1\u00d1]+([\- ]?[a-zA-ZÀ-ÿ\u00f1\u00d1]+)*$');
const String defaultPfp = "assets/images/iconperson.png";
