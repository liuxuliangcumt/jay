import 'package:flutter/material.dart';
import 'package:jay/models/DownloadModel.dart';
import 'package:jay/models/SongModel.dart';
import 'package:provider/provider.dart';

class DownloadList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DownloadModel model = Provider.of(context);
    return Container(
      child: ListView.builder(
        itemCount: model.downloadSong.length,
        itemBuilder: (ct, index) {
          Song song = model.downloadSong[index];

          return Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            child: Row(
              children: [
                InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Image.network(song.picUrl, fit: BoxFit.cover),
                    ),
                  ),
                  onTap: () {},
                ),
                SizedBox(width: 10),
                Text(
                  song.mName,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(
                  icon: model.isDownload(song)
                      ? Icon(
                          Icons.cloud_done,
                          size: 25.0,
                          color: Theme.of(context).accentColor,
                        )
                      : song.isLoading
                          ? Icon(
                              Icons.file_download,
                              size: 25.0,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.cloud_download,
                              size: 25.0,
                              color: Colors.grey,
                            ),
                  onPressed: () {
                    if(song.isLoading){
                      return;
                    }
                    model.removeFile(song);
                  },
                ),
                SizedBox(width: 20)
              ],
            ),
          );
        },
      ),
    );
  }
}
