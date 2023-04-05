import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vent_news/common/theme.dart';
import 'package:vent_news/data/model/response/Article.dart';
import 'package:intl/intl.dart';
import 'package:vent_news/feature/detail/DetailPage.dart';

class OverviewPage extends StatelessWidget {
  final Article article;

  const OverviewPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(
                    Rect.fromLTRB(0, 0, rect.width, rect.bottom),
                  );
                },
                blendMode: BlendMode.darken,
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/errorimage.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.only(
                        left: 5,
                      ),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: kPrimaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  bottom: 50,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy kk:mm')
                          .format(article.publishedAt),
                      style: whiteTextStyle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      article.title,
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      article.author,
                      style: whiteTextStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.48,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                20,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  article.description,
                  style: greyTextStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  article.content,
                  style: greyTextStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 55,
                  margin: EdgeInsets.zero,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailPage(url: article.url),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Read More',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
