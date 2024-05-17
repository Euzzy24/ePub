import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerRoute extends StatefulWidget {
  const PDFViewerRoute({super.key, required this.path});

  final String path;

  @override
  State<PDFViewerRoute> createState() => _PDFViewerRouteState();
}

class _PDFViewerRouteState extends State<PDFViewerRoute> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SfPdfViewer.network(
        'https://zrkvgohbukhnexnqupca.supabase.co/storage/v1/object/public/pdf/${widget.path}',
        key: _pdfViewerKey,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) async {
          final BuildContext currentContext = context;
          final Uint8List bytes =
              Uint8List.fromList(await details.document.save());
          if (!currentContext.mounted) {
            return; // Exit early if the widget is not mounted
          }
          await Navigator.of(currentContext).push(MaterialPageRoute(
            builder: (context) => SafeArea(
                child: PdfPreview(
              build: (PdfPageFormat format) => bytes,
            )),
          ));
        },
      ),
    );
  }
}
