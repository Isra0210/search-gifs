import 'package:BuscadorGifs/views/gifs/gifs_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=r9MO2gzP5JilICZnndnZVwYM83roIkiC&limit=20&rating=g');
    } else {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=r9MO2gzP5JilICZnndnZVwYM83roIkiC&q=$_search=19&offset=$_offset&rating=g&lang=en');
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
  }

  int _getCount(List data) {
    if (_search == null || _search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GifsView(
                  urlImage: snapshot.data["data"][index]["images"]
                      ["fixed_height"]["url"],
                  titleImage: snapshot.data["data"][index]["title"],
                ),
              ),
            ),
            onLongPress: () {
              Share.share(
                  '${snapshot.data["data"][index]["images"]["fixed_height"]["url"]}');
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text('Carregar mais...',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif'),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Pesquisar",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              onChanged: (newValue) {
                setState(() {
                  _search = newValue;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      height: 200.0,
                      width: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 4.0,
                      ),
                    );
                    break;
                  case ConnectionState.none:
                    return Center(
                      child: Text(
                        'Parece que algo deu errado!',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    );
                    break;

                  default:
                    if (snapshot.hasError) {
                      return Text(
                        'Algo deu errado!!',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      );
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
