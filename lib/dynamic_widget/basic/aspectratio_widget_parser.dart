import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/widgets.dart';

class AspectRatioWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener) {
    // 获取并验证 aspectRatio 值
    double aspectRatio = _getValidAspectRatio(map["aspectRatio"]);

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: DynamicWidgetBuilder.buildFromMap(
          map["child"], buildContext, listener),
    );
  }

  /// 验证并获取有效的宽高比
  /// 如果传入的值无效，返回默认的 16:9 宽高比
  double _getValidAspectRatio(dynamic value) {
    const double defaultAspectRatio = 16.0 / 9.0; // 默认宽高比

    if (value == null) {
      debugPrint('AspectRatio: aspectRatio 为 null，使用默认值: $defaultAspectRatio');
      return defaultAspectRatio;
    }

    double aspectRatio;
    try {
      aspectRatio = value.toDouble();
    } catch (e) {
      debugPrint('AspectRatio: 无法转换 aspectRatio 为 double: $value，使用默认值: $defaultAspectRatio');
      return defaultAspectRatio;
    }

    // 验证 aspectRatio 是否有效
    if (!aspectRatio.isFinite ||
        aspectRatio <= 0 ||
        aspectRatio > 10.0) { // 限制最大宽高比为10:1
      debugPrint('AspectRatio: aspectRatio 无效: $aspectRatio，使用默认值: $defaultAspectRatio');
      return defaultAspectRatio;
    }

    return aspectRatio;
  }

  @override
  String get widgetName => "AspectRatio";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as AspectRatio;
    return <String, dynamic>{
      "type": widgetName,
      "aspectRatio": realWidget.aspectRatio,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  Type get widgetType => AspectRatio;
}
