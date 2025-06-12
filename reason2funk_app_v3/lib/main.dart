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
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Home-Page/Reason-2-Funk_Landing-Page-BG_Blk-DJM-900-Mixer_[2560x1600].jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Home-Page/Reason-2-Funk_OG-Org-Blk-Round-Logo[1200x1200].png',
                    height: 120,
                    width: 120,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "OUR PASSION",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "IS HOUSE...",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC76E19),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Tagline
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "STRICTLY UNDERGROUND HOUSE MUSIC",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    letterSpacing: 3,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  "Welcome to Reason 2 Funk Records",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC76E19),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  "Reason 2 Funk Records is an Underground House Music Record Label based in Northwest UK, featuring Jackin House & Tech House artists from around the globe.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Featured Release
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  "AVAILABLE NOW!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFC76E19),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/Home-Page/Reason-2-Funk_pres_DJ-Philly-Phil_Future-of-the-Funk-EP_Cover-Art_[1010x992].jpg',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "DJ Philly Phil - Future of the Funk EP",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "1. Swing on Deez\n2. Boogie on the 1",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReleasesTab extends StatelessWidget {
  final List<Map<String, String>> releases = [
    {
      "title": "DJ Philly Phil - Future of the Funk EP",
      "artist": "DJ Philly Phil",
      "tracks": "1. Swing on Deez\n2. Boogie on the 1",
      "image": "assets/images/Home-Page/Reason-2-Funk_pres_DJ-Philly-Phil_Future-of-the-Funk-EP_Cover-Art_[1010x992].jpg",
    },
    {
      "title": "Frank Amodo & MC Partymouth - Piasí 88 Keys EP",
      "artist": "Frank Amodo & MC Partymouth",
      "tracks": "1. Piasí 88 Keys (Original)\n2. Piasí 88 Keys (Josh Stone Remix)\n3. Piasí 88 Keys (Doc Link Remix)\n4. Piasí 88 Keys (BUFS Sultry Edit)",
      "image": "assets/images/Home-Page/Reason-2-Funk_pres_Pia-si-88-Keys_ft_MC-PartyMouth-&-Frank-Amodo_Album-Cover_[1400x1400].jpg",
    },
    {
      "title": "Rory Northall - Dont Stop Dancin EP",
      "artist": "Rory Northall (UK)",
      "tracks": "1. Dont Stop (Original)\n2. I Wanna Dance (Original)",
      "image": "assets/images/Home-Page/Reason-2-Funk_pres_Dont-Stop-Dancin-EP_ft_Rory-Northall_Album-Cover_[1400x1400].jpg",
    },
    {
      "title": "Frank Amodo - I Get Deep",
      "artist": "Frank Amodo (Hawaii)",
      "tracks": "1. I Get Deep (Original)\n2. I Get Deep (BUFS Remix)\n3. I Get Deep (D Britton Remix)",
      "image": "assets/images/Home-Page/Reason-2-Funk_pres_I-Get-Deep-EP_ft_Frank-Amodo_Album-Cover_[1400x1400].jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: releases.length,
      itemBuilder: (context, index) {
        final release = releases[index];
        return Card(
          color: Colors.grey[900],
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    release["image"]!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        release["title"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        release["artist"]!,
                        style: TextStyle(
                          color: Color(0xFFC76E19),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        release["tracks"]!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ArtistsTab extends StatelessWidget {
  final List<Map<String, String>> artists = [
    {
      "name": "Jon Hart",
      "role": "Founder & Co-Owner",
      "image": "assets/images/Home-Page/Reason-2-Funk_Co-Owner-Jon-Hart-Artist-Pic_[1200x1600].jpg",
      "link": "https://www.mixcloud.com/djjonhart/",
    },
    {
      "name": "Chris Jackson",
      "role": "Co-Owner",
      "image": "assets/images/Home-Page/Reason-2-Funk_Co-Owner-Jacksonstrut-Artist-Pic_[1080x1080].png",
      "link": "https://twitch.tv/jacksonstrut",
    },
    {
      "name": "DJ Philly Phil",
      "role": "Artist",
      "image": "assets/images/Home-Page/Reason-2-Funk_DJ-Philly-Phil_Artist-Portrait_[600x600].jpg",
      "link": "https://www.reason2funk.co.uk/artists",
    },
    {
      "name": "Frank Amodo",
      "role": "Artist (Hawaii)",
      "image": "assets/images/Home-Page/Reason-2-Funk_pres_I-Get-Deep-EP_ft_Frank-Amodo_Album-Cover_[1400x1400].jpg",
      "link": "https://www.reason2funk.co.uk/artists",
    },
    {
      "name": "MC Partymouth",
      "role": "Artist",
      "image": "assets/images/Home-Page/Reason-2-Funk_MC-PartyMouth_Artist-Pic_[1365x2048].jpg",
      "link": "https://www.reason2funk.co.uk/artists",
    },
    {
      "name": "Rory Northall",
      "role": "Artist (UK)",
      "image": "assets/images/Home-Page/Reason-2-Funk_Rory-Northall_Artist-Pic_[600x600].jpg",
      "link": "https://www.reason2funk.co.uk/artists",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return Card(
          color: Colors.grey[900],
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(artist["image"]!),
            ),
            title: Text(
              artist["name"]!,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              artist["role"]!,
              style: TextStyle(color: Color(0xFFC76E19)),
            ),
            trailing: Icon(Icons.open_in_new, color: Color(0xFFC76E19)),
            onTap: () => _launchURL(artist["link"]!),
          ),
        );
      },
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
    return SingleChildScrollView(
      child: Column(
        children: [
          // Merch Preview Images
          Container(
            height: 200,
            child: PageView(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/Home-Page/Reason-2-Funk_Merch_Blk-House-Blend-TShirt_Front_[800x800].jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/Home-Page/Reason-2-Funk_Merch_Blk-House-Blend-TShirt_Back_[800x800].jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Merch Links
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
      ),
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
          "Chris Jackson - Twitch",
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
        // Logo
        Center(
          child: Image.asset(
            'assets/images/Home-Page/Reason-2-Funk_Transparent-Wide-Blk-Wht-Logo_[764x237].png',
            height: 100,
          ),
        ),
        SizedBox(height: 24),
        Text(
          "About Reason2Funk Records",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFC76E19)),
        ),
        SizedBox(height: 18),
        Text(
          "Reason 2 Funk Records is an Underground House Music Record Label based in Northwest UK, "
          "featuring Jackin House & Tech House artists from around the globe.",
          style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
        ),
        SizedBox(height: 16),
        Text(
          "Our Passion is House... we aim to bring you music via our artists releases and also via our FUNKcast podcast mixes.",
          style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
        ),
        SizedBox(height: 24),
        Text(
          "Team Update",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC76E19)),
        ),
        SizedBox(height: 12),
        Text(
          "Due to life changes for Adam & Rich, a decision was made to make some team changes at Reason 2 Funk Records. "
          "After some time deciding on the best way to move forward, Jon decided that there was an obvious person to team up with to progress with the label... "
          "Chris Jackson of course!",
          style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
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