import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifsView extends StatelessWidget {
  final String urlImage;
  final String titleImage;

  GifsView({@required this.urlImage, @required this.titleImage});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$titleImage'),
        actions: [
          IconButton(icon: Icon(Icons.share, color: Colors.white,), onPressed: (){
            Share.share('$urlImage');
          })
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Image.network('$urlImage', fit: BoxFit.contain, height: 300.0,),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
