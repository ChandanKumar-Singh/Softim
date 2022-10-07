import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../ApiManager/Apis.dart';

class DownloadItems {
  static List<DownloadItem> documents = [
    DownloadItem(
      name: 'Android Programming Cookbook',
      url:
          'http://enos.itcollege.ee/~jpoial/allalaadimised/reading/Android-Programming-Cookbook.pdf',
    ),
    DownloadItem(
      name: 'iOS Programming Guide',
      url:
          'http://englishonlineclub.com/pdf/iOS%20Programming%20-%20The%20Big%20Nerd%20Ranch%20Guide%20(6th%20Edition)%20[EnglishOnlineClub.com].pdf',
    ),
    DownloadItem(
      name: 'Arches National Park',
      url:
          'https://upload.wikimedia.org/wikipedia/commons/6/60/The_Organ_at_Arches_National_Park_Utah_Corrected.jpg',
    ),
    DownloadItem(
      name: 'Canyonlands National Park',
      url:
          'https://upload.wikimedia.org/wikipedia/commons/7/78/Canyonlands_National_Park%E2%80%A6Needles_area_%286294480744%29.jpg',
    ),
    DownloadItem(
      name: 'Death Valley National Park',
      url:
          'https://upload.wikimedia.org/wikipedia/commons/b/b2/Sand_Dunes_in_Death_Valley_National_Park.jpg',
    ),
    DownloadItem(
      name: 'Gates of the Arctic National Park and Preserve',
      url:
          'https://upload.wikimedia.org/wikipedia/commons/e/e4/GatesofArctic.jpg',
    ),
    DownloadItem(
      name: 'Big Buck Bunny',
      url:
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    ),
    DownloadItem(
      name: 'Elephant Dream',
      url:
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    ),
    DownloadItem(
      name: 'Spitfire',
      url:
          'https://github.com/bartekpacia/spitfire/releases/download/v1.2.0/spitfire.apk',
    ),
    DownloadItem(
      name: 'Google Search',
      url:
          'https://www.google.com/search?q=apk+file+image&sxsrf=ALiCzsZLfeeZ_v8hwncU0zQ1oIB0u_PUWA:1660542462080&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiOv9jcksj5AhWwRWwGHYkyCpgQ_AUoA3oECAEQBQ&biw=1366&bih=639&dpr=1',
    ),
    DownloadItem(
      name: 'Error ',
      url:
          'htps://www.google.com/search?q=apk+fi9jcksj5AhWwRWwGHYkyCpgQ_AUoA3oECAEQBQ&biw=1366&bih=639&dpr=1',
    ),
  ];

  Future<void> getDownloadItems() async {
    documents.clear();
    String url = ApiManager.BASE_URL + ApiManager.getStudentStudyMaterial;
    final headers = {
      'Authorization': ApiManager.authKey,
    };
    try {
      var response = await http.post(Uri.parse(url), headers: headers);
      debugPrint('Study Materials Response = ${response.body}');
      var responseData = await json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == 200) {
          var message = responseData['message'];
          var data = responseData['data'];
          data.forEach((v) {
            documents.add(DownloadItem.fromJson(v));
          });
          print(documents.length);
        }
      }
    } catch (e) {
      debugPrint('Some Error happened');
    }
  }
}

class DownloadItem {
  int? id;
  String? name;
  String? batchId;
  String? url;
  String? description;
  String? createdAt;
  String? updatedAt;

  DownloadItem(
      {this.id,
      this.name,
      this.batchId,
      this.url,
      this.description,
      this.createdAt,
      this.updatedAt});

  DownloadItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['title'];
    batchId = json['batch_id'];
    url = json['attachment'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.name;
    data['batch_id'] = this.batchId;
    data['attachment'] = this.url;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
