import 'package:flutter/material.dart';
import 'package:great_place/provider/greatPlace.dart';
import 'package:provider/provider.dart';
//
import './add_Place_Scren.dart';

class PlaceListScreen extends StatelessWidget {
  const PlaceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Great Place"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      //
      body: FutureBuilder(
        future: Provider.of<GreatPlace>(context, listen: false)
            .fetchAndSetDataFromDevice(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlace>(
                child: Center(
                  child: Text(
                    "Got no place please add some places",
                  ),
                ),
                builder: (context, greatPlaces, chld) =>
                    greatPlaces.items.isEmpty
                        ? chld as Widget
                        : ListView.builder(
                            itemBuilder: (ctx, index) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(greatPlaces.items[index].image),
                              ),
                              title: Text(
                                greatPlaces.items[index].title,
                              ),
                              onTap: () {},
                            ),
                            itemCount: greatPlaces.items.length,
                          ),
              ),
      ),
    );
  }
}
