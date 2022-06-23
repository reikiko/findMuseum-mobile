import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:findMuseum_mobile/models/museum_response_model.dart';
import 'package:findMuseum_mobile/models/city_response_model.dart';
import 'package:findMuseum_mobile/models/user_response_model.dart';
import 'package:findMuseum_mobile/screens/account/account.dart';
import 'package:findMuseum_mobile/screens/cities/cities.dart';
import 'package:findMuseum_mobile/screens/home/detail_museum.dart';
import 'package:findMuseum_mobile/services/api_service.dart';
import 'package:findMuseum_mobile/services/shared_services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

Future<List<MuseumData>> fetchMuseum() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/api/museum'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => MuseumData.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class MuseumData {
  late final int id;
  late final int city_id;
  late final String name;
  late final String slug;
  late final String image;
  late final String excerpt;
  late final String desc;
  String? createdAt;
  String? updatedAt;

  MuseumData({
    required this.id,
    required this.city_id,
    required this.name,
    required this.slug,
    required this.image,
    required this.excerpt,
    required this.desc,
    this.createdAt,
    this.updatedAt,
  });

  factory MuseumData.fromJson(Map<String, dynamic> json) {
    return MuseumData(
      id: json['id'],
      city_id: json['city_id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
      excerpt: json['excerpt'],
      desc: json['desc'],
      // createdAt: json['created_at'],
      // updatedAt: json['updated_at'],
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<MuseumData>> futureData;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    futureData = fetchMuseum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: FutureBuilder<UserResponseModel>(
              future: APIService.getUserProfile(),
              builder: (BuildContext context,
                  AsyncSnapshot<UserResponseModel> model) {
                if (model.hasData) {
                  print(model.data!.name);
                  return Text(
                    "Hi!, ${model.data!.name}",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  );
                }
                return const Text("Please Login");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Best Destination",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DestinationPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FutureBuilder<List<MuseumData>>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<MuseumData> museumData =
                            snapshot.requireData;
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          // width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: museumData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailMuseum(
                                            name: museumData[index]
                                                .name,
                                            desc: museumData[index]
                                                .desc,
                                            img: museumData[index].image,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              museumData[index].image),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.5),
                                              BlendMode.darken),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    museumData[index].name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  )
                                ],
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(child: const CircularProgressIndicator());
                    },
                  ),
        ],
      ),
    );
  }
}
