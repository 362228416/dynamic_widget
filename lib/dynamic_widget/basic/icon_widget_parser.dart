import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/icons_helper.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';

class IconWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener) {
    IconData? iconData;

    if (map.containsKey('data')) {
      String iconString = map['data'];

      // 检查是否是十六进制编码的自定义字体图标 (如 "0xe67d")
      if (iconString.startsWith('0x')) {
        try {
          // 移除 "0x" 前缀，然后解析十六进制
          String hexString = iconString.substring(2);
          int codePoint = int.parse(hexString, radix: 16);
          // 使用自定义字体族，这里假设使用 'iconfont'
          iconData = IconData(
            codePoint,
            fontFamily: map.containsKey('fontFamily') ? map['fontFamily'] : 'iconfont'
          );
          // print('解析字体图标: $iconString -> $codePoint (0x${codePoint.toRadixString(16)})');
        } catch (e) {
          // 如果解析失败，使用默认图标
          // print('解析字体图标失败: $iconString, 错误: $e');
          iconData = Icons.android;
        }
      } else {
        // 使用原有的解析方式处理 Material Icons 和 FontAwesome
        iconData = getIconUsingPrefix(name: iconString);
      }
    } else {
      iconData = Icons.android;
    }

    return Icon(
      iconData,
      size: map.containsKey("size") ? map['size']?.toDouble() : null,
      color: map.containsKey('color') ? parseHexColor(map['color']) : null,
      semanticLabel:
          map.containsKey('semanticLabel') ? map['semanticLabel'] : null,
      textDirection: map.containsKey('textDirection')
          ? parseTextDirection(map['textDirection'])
          : null,
    );
  }

  @override
  String get widgetName => "Icon";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Icon;
    return <String, dynamic>{
      "type": widgetName,
      "data": exportIconGuessFavorMaterial(realWidget.icon),
      "size": realWidget.size,
      "color": realWidget.color != null
          ? realWidget.color!.toARGB32().toRadixString(16)
          : null,
      "semanticLabel": realWidget.semanticLabel,
      "textDirection": realWidget.textDirection != null
          ? exportTextDirection(realWidget.textDirection)
          : null,
    };
  }

  @override
  Type get widgetType => Icon;
}
