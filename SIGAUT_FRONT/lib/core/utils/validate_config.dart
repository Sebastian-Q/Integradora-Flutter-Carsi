import 'package:flutter/foundation.dart';

enum ValidationType {
  required,
  password,
  upperCase,
  lowerCaseAndNumbers,
  lettersAndNumbers,
  numbers,
  integerNumber,
  decimalPrecision,
  email,
  alphanumeric,
  whiteSpaces,
  onlyLetters,
  validateEspecialChar,
  onlyUndescore,
  min,
  max,
  maxLength,
  minLength,
  validateInList,
  notEqual,
  notExponential,
  notMillion
}

class ValidateConfig {
  late ValidationType validationType;
  dynamic value = true;
  dynamic dataValidate; // use when required validate
  String? message;

  ValidateConfig(this.validationType, this.value);

  ValidateConfig.maxLength(int number, {this.message})
      : validationType = ValidationType.maxLength,
        value = number;

  ValidateConfig.validaEqual(this.value, this.dataValidate, {this.message})
      : validationType = ValidationType.validateInList;

  ValidateConfig.validaNotEqualDouble(double this.value, {this.message})
      : validationType = ValidationType.notEqual;

  ValidateConfig.minLength(int number, {this.message})
      : validationType = ValidationType.minLength,
        value = number;

  ValidateConfig.min(double number, {this.message})
      : validationType = ValidationType.min,
        value = number;

  ValidateConfig.max(double number, {this.message})
      : validationType = ValidationType.max,
        value = number;

  ValidateConfig.notExponential()
      : validationType = ValidationType.notExponential;

  ValidateConfig.notMillion()
      : validationType = ValidationType.notMillion;

  ValidateConfig.numbers({this.message})
      : validationType = ValidationType.numbers,
        value = true;

  ValidateConfig.required({this.message})
      : validationType = ValidationType.required,
        value = true;

  ValidateConfig.password({this.message})
      : validationType = ValidationType.password,
        value = true;

  ValidateConfig.upperCase({this.message})
      : validationType = ValidationType.upperCase,
        value = true;

  ValidateConfig.lowerCaseAndNumbers({this.message})
      : validationType = ValidationType.lowerCaseAndNumbers,
        value = true;

  ValidateConfig.lettersAndNumbers({this.message})
      : validationType = ValidationType.lettersAndNumbers,
        value = true;

  ValidateConfig.email({this.message})
      : validationType = ValidationType.email,
        value = true;

  ValidateConfig.whiteSpaces({this.message})
      : validationType = ValidationType.whiteSpaces,
        value = true;

  ValidateConfig.onlyLetters({this.message})
      : validationType = ValidationType.onlyLetters,
        value = true;

  ValidateConfig.validateEspecialChar({this.message})
      : validationType = ValidationType.validateEspecialChar,
        value = true;

  ValidateConfig.onlyUndescore({this.message})
      : validationType = ValidationType.onlyUndescore,
        value = true;

  ValidateConfig.integerNumber({this.message})
      : validationType = ValidationType.integerNumber;

  ValidateConfig.decimalPrecision({this.message})
      : validationType = ValidationType.decimalPrecision;

  ValidateConfig.alphanumeric({this.message})
      : validationType = ValidationType.alphanumeric;

  static String? validate(dynamic value, List<ValidateConfig> exceptions) {
    var data = exceptions.map((e) => e.isValid(value)).nonNulls.toList();
    if (data.isNotEmpty) {
      return data[0];
    } else {
      return null;
    }
  }

  String? isValid(dynamic valorCampo) {
    try {
      if (ValidationType.required == validationType) {
        valorCampo = valorCampo.toString().trim();
        if (valorCampo == null || (valorCampo is String && valorCampo.isEmpty)) {
          return message ?? "Campo requerido";
        }
      }
      if (valorCampo.toString().isNotEmpty) {
        if (ValidationType.onlyUndescore == validationType) {
          RegExp regExp = RegExp(r'^[A-Z_]+$');
          if (!regExp.hasMatch(valorCampo)) {
            return message ?? "Solo se aceptan guiones bajos y letras";
          }
        } else if (ValidationType.validateEspecialChar == validationType) {
          RegExp regExp = RegExp(r'^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ& _-]+$');
          if (!regExp.hasMatch(valorCampo)) {
            return message ?? "No se aceptan caracteres especiales";
          }
        } else if (ValidationType.numbers == validationType) {
          RegExp regExp =
          RegExp(r'(^\d*\.?\d*)', caseSensitive: false, multiLine: false);
          if (valorCampo.toString().trim().isEmpty ||
              !regExp.hasMatch(valorCampo)) {
            return message ?? "Inserte un número válido";
          }
        } else if (ValidationType.integerNumber == validationType) {
          RegExp regExp = RegExp(r'^[0-9]+$');
          if (valorCampo.toString().trim().isEmpty ||
              !regExp.hasMatch(valorCampo)) {
            return message ?? "Solo inserte numeros enteros";
          }
        } else if (ValidationType.decimalPrecision == validationType) {
          RegExp regExp = RegExp(r'^\d+(\.\d{0,2})?$');
          if (!regExp.hasMatch(valorCampo)) {
            return message ?? "Máx. 2 decimales";
          }
        } else if (ValidationType.onlyLetters == validationType) {
          RegExp regExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ& ]+$');
          if (!regExp.hasMatch(valorCampo)) return "Solo se aceptan letras";
        } else if (ValidationType.whiteSpaces == validationType) {
          RegExp regExp = RegExp(r'\s');
          if (regExp.hasMatch(valorCampo)) {
            return message ?? "El campo no debe contener espacios";
          }
        } else if (ValidationType.email == validationType) {
          RegExp emailRegExp = RegExp(
            r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
          );
          if (!emailRegExp.hasMatch(valorCampo)) {
            return message ?? "La dirección de correo no es valida";
          }
        } else if (ValidationType.alphanumeric == validationType) {
          RegExp regExp = RegExp(r"^[a-zA-Z0-9_\'-]+$");
          if (!regExp.hasMatch(valorCampo)) {
            return message ?? "Campo alfanumérico";
          }
        } else if (ValidationType.minLength == validationType) {
          if (int.parse(value.toString()) > valorCampo.toString().length) {
            return message ?? 'No ingrese menos de $value caracteres';
          }
        } else if (ValidationType.maxLength == validationType) {
          if (int.parse(value.toString()) < valorCampo.toString().length) {
            return message ?? "No ingrese mas de $value caracteres";
          }
        } else if (ValidationType.max == validationType) {
          if (double.parse(value.toString()) <
              double.parse(valorCampo.toString())) {
            return message ?? "Debe insertar un número menor a $value";
          }
        } else if (ValidationType.notExponential == validationType) {
          if (18 < valorCampo.toString().length) {
            return message ?? "No puede ingresar más de 18 digitos";
          }
        } else if (ValidationType.notMillion == validationType) {
          if (999999.99 < double.parse(valorCampo.toString())) {
            return message ?? "Valor máximo a ingresar 999999.99";
          }
        } else if (ValidationType.min == validationType) {
          if (double.parse(value.toString()) >
              double.parse(valorCampo.toString())) {
            return message ?? "Debe insertar un número mayor a $value";
          }
        } else if (ValidationType.lettersAndNumbers == validationType) {
          RegExp regExp = RegExp(r'([a-zA-Z0-9áéíóúÁÉÍÓÚñÑ&# ]*)+$');
          if (!regExp.hasMatch(valorCampo)) {
            return message ?? "Solo se permiten letras y números";
          }
        } else if (ValidationType.lowerCaseAndNumbers == validationType) {
          RegExp regExp = RegExp(r'([a-z0-9áéíóúñ&# ]*)+$');
          if (!regExp.hasMatch(valorCampo)) {
            return message ??
                "El campo solamente acepta letras minúsculas y números";
          }
        } else if (ValidationType.upperCase == validationType) {
          RegExp regExp = RegExp(r'^[A-Z0-9ÁÉÍÓÚÑ&# ]+$');
          if (!regExp.hasMatch(valorCampo)) {
            return message ??
                "El campo solo acepta mayúsculas y números";
          }
        } else if (ValidationType.password == validationType) {
          // RegExp regExp = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])");
          // RegExp regExp = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z@ .!#$%&*+^_-])");
          RegExp regExp = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@ .!#$%&*+^_-])");
          if (!regExp.hasMatch(valorCampo)) {
            return message ?? "Formato inválido de contraseña ej. Password1234";
          }
        } else if (ValidationType.validateInList == validationType) {
          if (dataValidate is List) {
            var exist = dataValidate.indexWhere(
                    (element) => element.toString() == value.toString());
            if (exist == -1) {
              return message ?? "Ya existe";
            }
          } else if (dataValidate != value) {
            return message ?? "Ya existe";
          }
        } else if (ValidationType.notEqual == validationType) {
          if(double.tryParse(valorCampo) == value) {
            return message ?? "El valor debe ser diferente al actual";
          }
        }
      }
    } catch (e) {
      debugPrint("e > $e");
      return "Valor inválido";
    }

    return null;
  }
}
