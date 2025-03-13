import 'package:cinemapedia/domain/entities/videos.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos_response.dart';

class VideoMapper {

  static moviedbVideoToEntity( Result moviedbVideo ) => Video(
    id: moviedbVideo.id, 
    name: moviedbVideo.name, 
    youtubeKey: moviedbVideo.key,
    publishedAt: moviedbVideo.publishedAt
  );


}