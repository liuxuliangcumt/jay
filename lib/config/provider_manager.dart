import 'package:jay/models/AlbumListModel.dart';
import 'package:jay/models/DownloadModel.dart';
import 'package:jay/models/HomePageModel.dart';
import 'package:jay/models/MusicListModel.dart';
import 'package:jay/models/SongModel.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...uiConsumableProviders
];

/// 独立的model
List<SingleChildCloneableWidget> independentServices = [
  ChangeNotifierProvider<DownloadModel>(
    create: (context) => DownloadModel(),
  ),
  ChangeNotifierProvider<SongModel>(
    create: (context) => SongModel(),
  ),
  ChangeNotifierProvider<HomePageModel>(
    create: (context) => HomePageModel(),
  ),
  ChangeNotifierProvider<MusicListModel>(
    create: (context) => MusicListModel(),
  ),
  ChangeNotifierProvider<AlbumListModel>(
    create: (context) => AlbumListModel(),
  ),
];

List<SingleChildCloneableWidget> uiConsumableProviders = [
//  StreamProvider<User>(
//    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
//  )
];
