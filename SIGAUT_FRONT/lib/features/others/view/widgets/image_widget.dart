import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/user/model/image_file_model.dart';

class ImageWidget extends StatefulWidget {
  final Color? colorBorder;
  final String? urlImage;
  final String? title;
  final Function(ImageFileModel?)? onImageSelected;

  const ImageWidget({
    super.key,
    this.colorBorder,
    this.urlImage,
    this.title,
    this.onImageSelected,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          dashPattern: const [6, 6],
          color: widget.colorBorder ?? Theme.of(context).colorScheme.cuartoBorder,
          strokeWidth: 2,
          child: Center(
            child: isLoading
                ? CircularProgressIndicator(
                    color: Color(0xFF1A5ED7)
                  )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.urlImage != null) ...{
                    Expanded(
                      child: Image.network(
                        widget.urlImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  } else ...{
                    Icon(Icons.camera_alt_outlined, size: 50, color: Theme.of(context).colorScheme.septimoIcon,),
                    Text(
                      widget.title ?? "Subir imagen",
                      style: CustomTextStyle.medium14.copyWith(color: Theme.of(context).colorScheme.primeroText),
                    ),
                  }
                ],
              ),
            ),
          ),
        ),

        Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.add_circle_outlined),
              iconSize: 32,
              color: widget.urlImage != null ? Theme.of(context).colorScheme.segundoIcon : Theme.of(context).colorScheme.terceroIcon,
              onPressed: () async {
                loading(true);
                final file = await _openFiles(context);
                // <-- Llamar al callback para que el padre reciba el archivo
                if (widget.onImageSelected != null && file != null) {
                  widget.onImageSelected!(file);
                }
                loading(false);
              },
              alignment: Alignment.topRight,
            )
        ),
      ],
    );
  }

  void loading(bool value) => {
    setState(() {
      isLoading = value;
    })
  };

  Future<ImageFileModel?> _openFiles(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'png', 'jpg'],
    );

    if (result == null) return null; // usuario canceló

    File file;
    file = File(result.files.single.path!);
    if (['jpeg', 'png', 'jpg'].contains(result.files.single.extension)) {
      final fileModel = await setPart(file);
      return fileModel;
    } else {
      setPart(null);
      return null;
    }
  }

  Future<ImageFileModel?> setPart(File? fileSelected) async {
    ImageFileModel? mimetypes;
    if (fileSelected != null) {
      Uint8List imageBytes = await fileSelected.readAsBytes();
      String base64string = base64.encode(imageBytes);

      mimetypes = ImageFileModel.fromJson({
        "contentType": getContentType(fileSelected),
        "nombre": getName(fileSelected),
        "encodeImage": base64string,
        "size": base64string.length,
        "file": fileSelected
      });
    }
    return mimetypes;
  }


  String getContentType(File file) {
    String extension = _getExtension(file);
    debugPrint("_getExtension ===> $extension");
    if (extension == "jpg" || extension == "jpeg") return "image/jpeg";
    if (extension == "png") return "image/png";
    return "";
  }

  String _getExtension(File fileSelected) {
    return fileSelected.path.split(".").last;
  }

  String getName(File fileSelected) {
    return fileSelected.path.split("/").last;
  }
}
