import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:wanandroid/common/StringUtil.dart';
import 'package:wanandroid/model/list_item/BlogListDataItemModel.dart';
import 'package:wanandroid/fonts/IconF.dart';
import 'package:wanandroid/widget/BackBtn.dart';
import 'package:wanandroid/common/CollectUtil.dart';
import 'dart:async';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  final BlogListDataItemModel articleBean;

  WebViewPage({this.url, this.title, this.articleBean});

  @override
  State<StatefulWidget> createState() => new _WebViewState();

  String getUrl() {
    return (!StringUtil.isNullOrEmpty(url))
        ? url
        : ((null != articleBean) ? articleBean.link : "");
  }

  String getTitle() {
    return (!StringUtil.isNullOrEmpty(title))
        ? title
        : ((null != articleBean) ? articleBean.title : "");
  }
}

class _WebViewState extends State<WebViewPage> {
  String toastMsg;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
//      headers: User().getHeader(),
      url: widget.getUrl(),
      appBar: AppBar(
        title: Text(
          null != toastMsg ? toastMsg : widget.getTitle(),
          style: null != toastMsg
              ? TextStyle(
                  fontSize: 15.0,
                  color: Colors.amberAccent,
                )
              : null,
        ),
        leading: BackBtn(),
        actions: <Widget>[
          _buildStared(context),
        ],
      ),
    );
  }

  Widget _buildStared(BuildContext context) {
    if (null == widget.articleBean) {
      return Text("");
    } else
      return IconButton(
        icon: Icon(
          (widget.articleBean.collect) ? IconF.like_fill : IconF.like_stroke,
          color: Colors.white,
        ),
        onPressed: () {
          CollectUtil.updateCollectState(context, widget.articleBean,
              (bool isOK, String errorMsg) {
            if (isOK) {
              setState(() {
                widget.articleBean.collect = !widget.articleBean.collect;
              });
            } else {
              setState(() {
                toastMsg = errorMsg;
              });
              Timer(Duration(seconds: 2), () {
                setState(() {
                  toastMsg = null;
                });
              });
            }
          });
        },
      );
  }
}
