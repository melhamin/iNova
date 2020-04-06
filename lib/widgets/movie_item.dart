import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart' as intl;

import 'package:e_movies/genres.dart';
import '../pages/movie_details_page.dart';

class MovieItem extends StatelessWidget {
  // final int id;
  final movie;  

  MovieItem({
    // this.id,
    this.movie,    
  });

  String getGenreName(int genreId) {
    return GENRES[genreId];
  }

  void _onDetailsPressed(BuildContext context, int id) {
    Navigator.of(context).pushNamed(MovieDetailPage.routeName,
        arguments: id);
  }

  String _formatDate(DateTime date) {
    return intl.DateFormat('dd MM yyyy').format(date);
  }

  Widget _buildBackgroundImage(BuildContext context, String imageUrl) {
    // if(imageUrl == 'null' || imageUrl.length == 0 || imageUrl == null)
    // print('imageUrl --------------------> null TITLE: ${movie.title}');
    // if(imageUrl == null) imageUrl = 'blob:https://www.pngfuel.com/5e3dae69-7ade-4e65-b1ab-8a2cd4eedc6c';
    return imageUrl == null
        ? Image.asset('assets/images/loading.png', fit: BoxFit.cover)
        : Hero(
          tag: movie.id,
                  child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: const Color(0xff000000),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.7), BlendMode.dstATop),
                    image: imageProvider,
                  ),
                ),
              ),
            ),
        );
  }

  Widget _buildFooter(BuildContext context, double screenWidth, String title,
      int genreId, DateTime date) {
    return Positioned.directional(
      width: screenWidth / 2,
      height: 75,
      bottom: 0,
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.9),
                  Color.fromRGBO(0, 0, 0, 0)
                ]),
            backgroundBlendMode: BlendMode.dstIn),
        constraints: BoxConstraints(maxWidth: screenWidth / 2 - 20),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title == null ? 'N/A' : title,
                style: Theme.of(context).textTheme.headline6,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              FittedBox(
                child: Text(
                  getGenreName(genreId),
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 5),
              FittedBox(
                child: Text(
                  _formatDate(date),
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('MovieItem ---> build called...');
    // final movie = Provider.of<Movies>(context, listen: false).findById(id);
    final screenWidth = MediaQuery.of(context).size.width;
    // print('genreId --------------- > ${movie.genreIDs[0]}');
    return GestureDetector(
      onTap: () => _onDetailsPressed(context, movie.id),
      child: ClipRRect(
        child: GridTile(
          child: Stack(
            children: <Widget>[
              _buildBackgroundImage(context, movie.imageUrl),
              _buildFooter(
                context,
                screenWidth,
                movie.title,
                movie.genreIDs.isNotEmpty ? movie.genreIDs[0] : -1,
                movie.releaseDate,
              )
            ],
          ),
        ),
      ),
    );
  }
}
