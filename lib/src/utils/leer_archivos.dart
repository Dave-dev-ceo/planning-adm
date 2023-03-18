import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

Future<FilePickerResult?> leerArchivos({
  String? dialogTitle,
  String? initialDirectory,
  FileType type = FileType.any,
  List<String>? allowedExtensions,
  dynamic Function(FilePickerStatus)? onFileLoading,
  bool allowCompression = true,
  bool allowMultiple = false,
  bool withData = false,
  bool withReadStream = false,
  bool lockParentWindow = false,
}) async {
  final pickedFile = await FilePicker.platform.pickFiles(
    dialogTitle: dialogTitle,
    allowCompression: allowCompression,
    allowMultiple: allowMultiple,
    allowedExtensions: allowedExtensions,
    initialDirectory: initialDirectory,
    lockParentWindow: lockParentWindow,
    onFileLoading: onFileLoading,
    type: type,
    withData: withData,
    withReadStream: withReadStream,
  );

  if (pickedFile == null) return pickedFile;

  final List<PlatformFile> files = [];

  for (var file in pickedFile.files) {
    final sizeMb = fileSize(file.size);

    final nameFile = file.name;

    if (sizeMb > 11) {
      MostrarAlerta(
        mensaje: 'El archivo $nameFile supera los 10Mb, no se pudo cargar',
        tipoMensaje: TipoMensaje.advertencia,
      );
      return null;
    } else {
      files.add(file);
    }
  }

  if (files.isEmpty) return null;

  return FilePickerResult(files);
}

double fileSize(int bytes) {
  final double mb = ((bytes / (1024 * 1024)));

  return num.parse(mb.toStringAsFixed(4)).toDouble();
}
