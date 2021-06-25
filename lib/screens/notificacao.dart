import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/ui/help_view.dart';
import 'package:coneg/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:coneg/widget/appbarpanel.dart';
import 'package:coneg/widget/drawerpanel.dart';

class NotificacaoConfig extends StatefulWidget {
  const NotificacaoConfig({Key key}) : super(key: key);

  @override
  _NotificacaoConfigState createState() => _NotificacaoConfigState();
}

class _NotificacaoConfigState extends State<NotificacaoConfig> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> responseMap;
  String _methodSelected;
  static const methodItems = <String>['Email', 'Telefone'];
  final List<DropdownMenuItem<String>> _dropDownMenuItems = methodItems
      .map((String value) =>
          DropdownMenuItem<String>(value: value, child: Text(value)))
      .toList();
  TextEditingController method_show = TextEditingController();
  HelpView helpNotificacao = HelpView('assets/helpNotificacao.txt');
  TextEditingController msg_show = TextEditingController();
  TextEditingController msg = TextEditingController();
  ConegDesign notificacaoDesign = ConegDesign();
  String notificacao = 'Notificação';

  @override
  void initState() {
    super.initState();
    _loadRes();
  }

  void _loadRes() async {
    var res = await ConegRoutes().getCurrentNotification();
    print('res $res');
    setState(() {
      method_show.text = res['method'];
      msg_show.text = res['message'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    // Stroked text as border.
                    Text(
                      notificacao,
                      style: TextStyle(
                        fontSize: 40,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = notificacaoDesign.getBlue(),
                      ),
                    ),
                    // Solid text as fill.
                    Text(
                      notificacao,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: IconButton(
                        splashRadius: 10,
                        icon: Icon(
                          Icons.help_outline_rounded,
                          color: notificacaoDesign.getPurple(),
                        ),
                        onPressed: () {
                          helpNotificacao.showHelp(
                              context, "Ajuda em Notificação");
                        })),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 450,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Color(0xFF17DFD3),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 5, color: Color(0xFF23A39B))),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Notificação cadastrada',
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration.collapsed(
                                hintText: "Método definido:"),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: TextField(
                            controller: method_show,
                            maxLines: 8,
                            readOnly: true,
                            //decoration: InputDecoration(hoverColor: Colors.amber),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration.collapsed(
                                hintText: "Mensagem definida:"),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: TextField(
                            controller: msg_show,
                            maxLines: 8,
                            readOnly: true,
                            //decoration: InputDecoration(hoverColor: Colors.amber),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 450,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Color(0xFF17DFD3),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 5, color: Color(0xFF23A39B))),
                  child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Atualizar Notificação',
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: TextField(
                                  readOnly: true,
                                  decoration: InputDecoration.collapsed(
                                      hintText: "Método:"),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: DropdownButtonFormField(
                                    value: _methodSelected,
                                    hint: const Text("Escolha"),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _methodSelected = newValue;
                                      });
                                      print(_methodSelected);
                                    },
                                    items: _dropDownMenuItems,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration.collapsed(
                                hintText: "Mensagem:"),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: TextFormField(
                            controller: msg,
                            maxLines: 12,
                            decoration: InputDecoration(
                              hintText:
                                  "Mensagem para envio. Utilize \$NOME para utilizar o nome da pessoa dentro da mensagem!",
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF23A39B), width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty)
                                return "Mensagem não pode ser vazia!";
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              //makeRequestMultipart();
                              print('nice dude!');
                              await ConegRoutes().setCurrentNotification({
                                "method": _methodSelected,
                                "message": msg.value.text
                              });
                              _loadRes();
                            }
                          },
                          color: notificacaoDesign.getPurple(),
                          elevation: 10,
                          highlightElevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          textColor: Colors.white,
                          child: Text('Cadastrar nova notificação'),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          )
        ]);
  }
}
