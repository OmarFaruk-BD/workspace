import 'package:flutter/material.dart';

class SlowScrollPhysics extends ScrollPhysics {
  const SlowScrollPhysics({super.parent});

  @override
  SlowScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(_, double offset) => offset * 0.2;
}

class SliverAppbarPage extends StatefulWidget {
  const SliverAppbarPage({super.key});

  @override
  State<SliverAppbarPage> createState() => _SliverAppbarPageState();
}

class _SliverAppbarPageState extends State<SliverAppbarPage> {
  bool isBlue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const SlowScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            snap: false,
            pinned: true,
            floating: true,
            expandedHeight: 300,
            backgroundColor: Colors.blueAccent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {},
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate collapse ratio (0.0 = expanded, 1.0 = collapsed)
                final double collapsedHeight =
                    kToolbarHeight + MediaQuery.of(context).padding.top;
                final double expandedHeight =
                    300 + MediaQuery.of(context).padding.top;
                final double currentHeight = constraints.maxHeight;

                // Calculate opacity (0.0 when expanded, 1.0 when collapsed)
                final double opacity =
                    ((expandedHeight - currentHeight) /
                            (expandedHeight - collapsedHeight))
                        .clamp(0.0, 1.0);

                return FlexibleSpaceBar(
                  // Title with fade-in animation
                  title: Opacity(
                    opacity: opacity,
                    child: const Text('SliverAppBar'),
                  ),
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: Image.network(
                    'https://images.unsplash.com/photo-1764703495149-f09b0aa607c3',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          // Second AppBar (Tab Bar) — now with ZERO extra top padding
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              child: Container(
                color: Colors.tealAccent,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBlue
                            ? Colors.white
                            : Colors.white.withAlpha(70),
                        foregroundColor: isBlue ? Colors.black : Colors.white,
                      ),
                      onPressed: () => setState(() => isBlue = true),
                      child: const Text('Blue'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isBlue
                            ? Colors.white
                            : Colors.white.withAlpha(70),
                        foregroundColor: !isBlue ? Colors.black : Colors.white,
                      ),
                      onPressed: () => setState(() => isBlue = false),
                      child: const Text('Red'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final bool showBlue = isBlue;
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: showBlue ? Colors.blue.shade400 : Colors.red.shade400,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  '${showBlue ? 'Blue' : 'Red'} Item $index',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }, childCount: 30),
          ),
        ],
      ),
    );
  }
}

// Custom delegate to control exact height of the tab bar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TabBarDelegate({required this.child});

  @override
  double get minExtent => 64; // height when collapsed
  @override
  double get maxExtent => 64; // same → no expand

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.tealAccent, child: child);
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
