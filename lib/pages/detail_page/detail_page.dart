import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:revision_quotes_app/headers.dart';
import 'package:revision_quotes_app/modals/quote_modal.dart';
import 'package:revision_quotes_app/utils/app_data.dart';
import 'dart:ui' as ui;

import 'package:share_extend/share_extend.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextStyle fontFamily = AppData.instance.quoteFontFamily[0];
  double quoteFontSize = 14;

  GlobalKey key = GlobalKey();

  Future<File> getFile() async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(
      pixelRatio: 15,
    );
    ByteData? bytes = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    Uint8List uInt8list = bytes!.buffer.asUint8List();

    Directory directory = await getTemporaryDirectory();
    File file = await File(
            "${directory.path}/QA-${DateTime.now().millisecondsSinceEpoch}.png")
        .create();
    file.writeAsBytesSync(uInt8list);

    return file;
  }

  Widget saveChild = const Icon(Icons.save_alt);

  @override
  Widget build(BuildContext context) {
    Quote quote = ModalRoute.of(context)!.settings.arguments as Quote;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: RepaintBoundary(
                key: key,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          quote.quote,
                          style: fontFamily.copyWith(
                            fontSize: quoteFontSize,
                          ),
                        ),
                      ),
                      Text("- ${quote.author}"),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Quote font family"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: AppData.instance.quoteFontFamily
                          .map(
                            (e) => TextButton(
                              onPressed: () {
                                fontFamily = e;
                                setState(() {});
                              },
                              child: Text(
                                "Abc",
                                style: e,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Row(
                    children: [
                      const Text("Quote font size"),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          quoteFontSize--;
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.remove,
                        ),
                      ),
                      Text(
                        quoteFontSize.toInt().toString(),
                      ),
                      IconButton(
                        onPressed: () {
                          quoteFontSize++;
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.add,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Edit quote"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: quote.author,
                        onChanged: (val) {
                          quote.author = val;
                        },
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Done"),
                    ),
                  ],
                ),
              ).then(
                (value) => setState(() {}),
              );
            },
            child: const Icon(Icons.edit),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              saveChild = const CircularProgressIndicator();
              setState(() {});
              File file = await getFile();
              ImageGallerySaver.saveFile(file.path).then((value) {
                saveChild = const Icon(Icons.done);
                setState(() {});
              });
            },
            child: saveChild,
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              File file = await getFile();
              ShareExtend.share(
                file.path,
                "file",
                extraText: "Get app like from PlayStore.",
              );
            },
            child: const Icon(
              Icons.share,
            ),
          ),
        ],
      ),
    );
  }
}
