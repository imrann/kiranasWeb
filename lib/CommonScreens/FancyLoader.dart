import 'package:flutter/material.dart';

class FancyLoader extends StatelessWidget {
  FancyLoader({this.loaderType, this.lines});

  final String loaderType;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return getLoaderType(
        loaderType: loaderType, lines: lines, context: context);
  }

  Widget getLoaderType({String loaderType, int lines, BuildContext context}) {
    switch (loaderType) {
      case "list":
        {
          return getListLoader();
        }
        break;

      case "sLine":
        {
          return getSingleLineLoader();
        }
        break;

      case "mLine":
        {
          return getMultiLineLoader(lines);
        }
        break;
      case "Grid":
        {
          return getGridLoader(context: context);
        }
        break;

      default:
        {
          return getLogoLoader();
        }
        break;
    }
  }

  Widget getLogoLoader() {
    return Center(
      child: Text(
        'KIRANAS',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey,
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
            wordSpacing: 2,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget getSingleLineLoader() {
    return Center(
      child: Container(
        color: Colors.grey[200],
        height: 100,
        width: 300,
      ),
    );
  }

  Widget getMultiLineLoader(int lines) {
    return Container(
      color: Colors.grey[200],
      height: lines.toDouble() * 50,
      width: 300,
    );
  }

  Widget getListLoader() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Container(
                  color: Colors.grey[200],
                  height: 15,
                  width: 100,
                ),
              ),
              subtitle: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Container(
                  color: Colors.grey[200],
                  height: 15,
                  width: 100,
                ),
              ),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[200],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getGridLoader({BuildContext context}) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ((MediaQuery.of(context).size.width >= 450.0) &&
                  (MediaQuery.of(context).size.width <= 900.0))
              ? 3
              : ((MediaQuery.of(context).size.width > 900.0) &&
                      (MediaQuery.of(context).size.width <= 1250.0))
                  ? 4
                  : (MediaQuery.of(context).size.width > 1250.0)
                      ? 6
                      : 2,
          childAspectRatio: 0.7),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          child: Card(
            color: Colors.grey[200],
          ),
        );
      },
    );
  }
}
