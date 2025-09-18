library dynamic_widget;


import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/basic/dynamic_widget_json_exportor.dart';
import 'package:flutter/widgets.dart';


class JsonWidget extends StatefulWidget {
  final String jsonCode;
  final ClickListener? listener;

  const JsonWidget(this.jsonCode, {this.listener});

  @override
  JsonWidgetState createState() => JsonWidgetState();
}

class JsonWidgetState extends State<JsonWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget?>(
      future: _buildWidget(context),
      builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
        return snapshot.hasData
            ? DynamicWidgetJsonExportor(child: snapshot.data)
            : SizedBox();
      },
    );
  }

  Future<Widget?> _buildWidget(BuildContext context) async {
    return DynamicWidgetBuilder.build(
      widget.jsonCode,
      context,
      widget.listener??DefaultClickListener(onClick: _onClick),
    );
  }

  void _onClick(String? event) {
    
  }
}

