import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/ui/car_models_page.dart';
import 'package:flutter_app_videolist/ui/citylist_custom_header_page.dart';
import 'package:flutter_app_videolist/ui/citylist_page.dart';
import 'package:flutter_app_videolist/ui/contacts_list_page.dart';
import 'package:flutter_app_videolist/ui/contacts_page.dart';
import 'package:flutter_app_videolist/ui/github_language_page.dart';
import 'package:flutter_app_videolist/ui/large_data_page.dart';
import 'package:flutter_app_videolist/ui/page_scaffold.dart';

class StylesListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AzListView',
        ),
      ),
      body: ListPage([
        PageInfo("GitHub Languages", (ctx) => GitHubLanguagePage(), false),
        PageInfo("Contacts", (ctx) => ContactsPage(), false),
        PageInfo("Contacts List", (ctx) => ContactListPage()),
        PageInfo("City List", (ctx) => CityListPage(), false),
        PageInfo(
            "City List(Custom header)", (ctx) => CityListCustomHeaderPage()),
        PageInfo("Car models", (ctx) => CarModelsPage(), false),
        PageInfo("10000 data", (ctx) => LargeDataPage(), false),
      ]),
    );
  }
}