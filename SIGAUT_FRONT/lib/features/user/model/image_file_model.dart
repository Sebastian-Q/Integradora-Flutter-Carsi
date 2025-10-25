import 'dart:io';

class ImageFileModel {
  String contentType;
  String nombre;
  String? nombreSistema;
  String? url;
  String? encodeImage;
  int size;
  int? id;
  File? file;

  ImageFileModel({
    required this.contentType,
    required this.nombre,
    this.nombreSistema,
    this.url,
    this.encodeImage,
    required this.size,
    this.id,
    this.file,
  });

  ImageFileModel.fromJson(Map<String, dynamic> json)
      : contentType = json['contentType'] ?? "--",
        nombre = json['nombre'] ?? "None",
        encodeImage = json['encodeImage'],
        nombreSistema = json['nombreSistema'],
        url = json['url'],
        id = json['id'],
        size = json['size'] ?? 0,
        file = json['file'];

  Map<String, dynamic> toMap() {
    return {
      "nombre": nombre,
      "contentType": contentType,
      "nombreSistema": nombreSistema,
      "encodeImage": encodeImage,
      "url": url,
      "id": id,
      "size": size,
    };
  }
}