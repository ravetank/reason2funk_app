import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(Reason2FunkApp());

class Reason2FunkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reason2Funk',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFC76E19),
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFC76E19),
          secondary: Color(0xFFC76E19),
        ),
      ),
      home: Reason2FunkHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Reason2FunkHomePage extends StatefulWidget {
  @override
  _Reason2FunkHomePageState createState() => _Reason2FunkHomePageState();
}

class _Reason2FunkHomePageState extends State<Reason2FunkHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomeTab(),
    ReleasesTab(),
    ArtistsTab(),
    FunkcastTab(),
    MerchTab(),
    LiveStreamTab(),
    SocialTab(),
    AboutTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _tabTitles = [
    'Home',
    'Releases',
    'Artists',
    'FUNKcast',
    'Merch',
    'Live',
    'Social',
    'About',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_selectedIndex], 
          style: TextStyle(color: Color(0xFFC76E19))),
        backgroundColor: Colors.black,
        elevation: 1,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Color(0xFFC76E19),
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Releases'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Artists'),
          BottomNavigationBarItem(icon: Icon(Icons.audiotrack), label: 'FUNKcast'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Merch'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Social'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'About'),
        ],
      ),
    );
  }
}

// -- TAB CONTENT --

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 80, color: Color(0xFFC76E19)),
            SizedBox(height: 32),
            Text(
              "Welcome to Reason2Funk!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFC76E19)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "Underground House Music\nHalifax, NS & UK",
              style: TextStyle(fontSize: 18, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Text(
              "Explore our releases, artists, streams, merch & more.",
              style: TextStyle(fontSize: 15, color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ReleasesTab extends StatelessWidget {
  final List<Map<String, String>> releases = [
    {
      "title": "Latest Releases",
      "platform": "Beatport",
      "url": "https://www.beatport.com/label/reason-2-funk-records/47240",
    },
    {
      "title": "Deep House Collection",
      "platform": "Traxsource", 
      "url": "https://www.traxsource.com/label/23323/reason-2-funk-records",
    },
    {
      "title": "Reason2Funk Catalog",
      "platform": "Bandcamp",
      "url": "https://reason2funkrecords.bandcamp.com/",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: releases.map((release) {
        return Card(
          color: Colors.grey[900],
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(release["title"]!, style: TextStyle(color: Colors.white)),
            subtitle: Text(release["platform"]!, style: TextStyle(color: Color(0xFFC76E19))),
            trailing: Icon(Icons.open_in_new, color: Color(0xFFC76E19)),
            onTap: () => _launchURL(release["url"]!),
          ),
        );
      }).toList(),
    );
  }
}

class ArtistsTab extends StatelessWidget {
  final List<Map<String, String>> artists = [
    {
      "name": "Jon Hart",
      "link": "https://www.mixcloud.com/djjonhart/",
    },
    {
      "name": "Jackson Strut", 
      "link": "https://twitch.tv/jacksonstrut",
    },
    {
      "name": "HT Ross",
      "link": "https://soundcloud.com/reason-2-funk/",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: artists.map((artist) {
        return Card(
          color: Colors.grey[900],
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(artist["name"]!, style: TextStyle(color: Colors.white)),
            subtitle: Text("View Profile", style: TextStyle(color: Color(0xFFC76E19))),
            trailing: Icon(Icons.person, color: Color(0xFFC76E19)),
            onTap: () => _launchURL(artist["link"]!),
          ),
        );
      }).toList(),
    );
  }
}

class FunkcastTab extends StatelessWidget {
  final List<Map<String, String>> funkcast = [
    {
      "series": "FUNKcast Series Latest",
      "url": "https://soundcloud.com/reason-2-funk/sets/funkcast-series-1",
    },
    {
      "series": "FUNKcast Archive",
      "url": "https://soundcloud.com/reason-2-funk/",
    },
    {
      "series": "Jon Hart Mixcloud",
      "url": "https://www.mixcloud.com/djjonhart/",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: funkcast.map((fc) {
        return Card(
          color: Colors.grey[900],
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(fc["series"]!, style: TextStyle(color: Colors.white)),
            subtitle: Text("Listen Now", style: TextStyle(color: Color(0xFFC76E19))),
            trailing: Icon(Icons.play_circle_fill, color: Color(0xFFC76E19)),
            onTap: () => _launchURL(fc["url"]!),
          ),
        );
      }).toList(),
    );
  }
}

class MerchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _merchCard(
          context,
          "Official R2F Merch",
          "https://www.reason2funk.co.uk/merch",
          "Exclusive Reason2Funk apparel and gear!",
        ),
        _merchCard(
          context,
          "DJ Jon Hart Shop", 
          "https://djjonhart-shop.fourthwall.com/en-cad",
          "Get Jon Hart's signature merchandise!",
        ),
      ],
    );
  }

  Widget _merchCard(BuildContext context, String title, String url, String desc) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        subtitle: Text(desc, style: TextStyle(color: Colors.white70)),
        trailing: Icon(Icons.shopping_cart, color: Color(0xFFC76E19)),
        onTap: () => _launchURL(url),
      ),
    );
  }
}

class LiveStreamTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _liveCard(
          context,
          "Reason2Stream",
          "https://reason2stream.co.uk",
          "Our custom live streaming platform!",
        ),
        _liveCard(
          context,
          "Jon Hart - Twitch",
          "https://twitch.tv/djjonhart",
          "Catch Jon's weekly house sets live.",
        ),
        _liveCard(
          context,
          "Jackson Strut - Twitch",
          "https://twitch.tv/jacksonstrut", 
          "Underground house & jackin' beats!",
        ),
      ],
    );
  }

  Widget _liveCard(BuildContext context, String title, String url, String desc) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        subtitle: Text(desc, style: TextStyle(color: Colors.white70)),
        trailing: Icon(Icons.live_tv, color: Color(0xFFC76E19)),
        onTap: () => _launchURL(url),
      ),
    );
  }
}

class SocialTab extends StatelessWidget {
  final List<Map<String, String>> socials = [
    {"platform": "Facebook", "url": "https://www.facebook.com/reason2funk"},
    {"platform": "Twitter/X", "url": "https://x.com/reason2funk"},
    {"platform": "YouTube", "url": "https://www.youtube.com/c/Reason2FunkRecords"},
    {"platform": "Bandcamp", "url": "https://reason2funkrecords.bandcamp.com/"},
    {"platform": "Mixcloud", "url": "https://www.mixcloud.com/djjonhart"},
    {"platform": "SoundCloud", "url": "https://soundcloud.com/reason-2-funk/"},
    {"platform": "Spotify", "url": "https://open.spotify.com/album/432NNOo1q4qwlQ5ZcLLQcF"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: socials.map((social) {
        return Card(
          color: Colors.grey[900],
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(social["platform"]!, style: TextStyle(color: Colors.white)),
            subtitle: Text("Follow us", style: TextStyle(color: Color(0xFFC76E19))),
            trailing: Icon(Icons.open_in_new, color: Color(0xFFC76E19)),
            onTap: () => _launchURL(social["url"]!),
          ),
        );
      }).toList(),
    );
  }
}

class AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        Text(
          "About Reason2Funk",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFC76E19)),
        ),
        SizedBox(height: 18),
        Text(
          "Reason2Funk Records is an underground house label based in Halifax, NS and the UK, "
          "bringing jackin' house vibes and soulful grooves to dancefloors worldwide. "
          "Home to artists Jon Hart, Jackson Strut, HT Ross, and more.",
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        SizedBox(height: 24),
        Text(
          "We also run Reason2Stream, our custom live streaming platform, and Reason2Raid, "
          "our community raid train. Join the movement!",
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        SizedBox(height: 32),
        Text("Contact: info@reason2funk.co.uk",
            style: TextStyle(color: Colors.white54, fontSize: 15)),
        SizedBox(height: 12),
        Text(
          "© 2025 Reason2Funk Records. All Rights Reserved.",
          style: TextStyle(color: Colors.white38, fontSize: 13),
        ),
      ],
    );
  }
}

// URL launcher function
Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}