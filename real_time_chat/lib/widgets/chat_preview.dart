import 'package:flutter/material.dart';

class ChatPreview extends StatelessWidget {
  const ChatPreview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 90),
      child: Container(
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 2.0,
          bottom: 2.0,
          right: 8.0,
        ),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://mindbodygreen-res.cloudinary.com/images/w_767,q_auto:eco,f_auto,fl_lossy/usr/RetocQT/sarah-fielding.jpg'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(7.0, 0.0, 5.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Text(
                            'Angelica Rose',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 4,
                          child: Text('10:45 PM'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text('This was the last message')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
