import 'package:coneg/models/design_color_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpView {
  // bool helpWindow = false;
  String msg = '';
  String imgAssetPath = '';
  double h;
  double w;
  Color color;

  HelpView(String assetPath, [this.imgAssetPath, this.h, this.w]) {
    loadAsset(assetPath);
    color = ConegDesign().getPurple();
  }

  void loadAsset(String path) async {
    msg = await rootBundle.loadString(path);
  }

  Future showHelp(BuildContext context, String title) {
    // spawnDialog(context, "Ajuda em Cadastro Geral", helpText,
    //     cadastroDesign.getPurple());
    if (imgAssetPath == null)
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(title),
                //content: new Text("Hello World"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(msg),
                    ],
                  ),
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: color,
                    elevation: 10,
                    highlightElevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textColor: Colors.white,
                    child: Text('OK'),
                  )
                ]);
          });
    else
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(title),
                //content: new Text("Hello World"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(msg),
                      Image.asset(
                        imgAssetPath, //'assets/images/scheme-register.png',
                        height: h,
                        width: w,
                        isAntiAlias: true,
                      ),
                    ],
                  ),
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: color,
                    elevation: 10,
                    highlightElevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textColor: Colors.white,
                    child: Text('OK'),
                  )
                ]);
          });
  }

  Future showInfo(BuildContext context, String title, String text) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              //content: new Text("Hello World"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(text),
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: color,
                  elevation: 10,
                  highlightElevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  textColor: Colors.white,
                  child: Text('OK'),
                )
              ]);
        });
  }
}
