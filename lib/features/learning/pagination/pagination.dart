import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PaginationPage extends StatefulWidget {
  const PaginationPage({super.key});

  @override
  State<PaginationPage> createState() => _PaginationPageState();
}

class _PaginationPageState extends State<PaginationPage> {
  final MyService _myService = MyService();
  late final PagingController<int, String> _controller1 =
      PagingController<int, String>(
        getNextPageKey: (s) => s.lastPageIsEmpty ? null : s.nextIntPageKey,
        fetchPage: (pageKey) async => await _myService.getData(pageKey),
      );

  late final PagingController<int, String> _controller2 =
      PagingController<int, String>(
        getNextPageKey: (s) => s.lastPageIsEmpty ? null : s.nextIntPageKey,
        fetchPage: (pageKey) async => await _myService.getData2(pageKey),
      );

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page'), centerTitle: true),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Some header button here",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          PagingListener<int, String>(
            controller: _controller1,
            builder: (context, state, fetchNextPage) =>
                PagedSliverList<int, String>(
                  state: state,
                  fetchNextPage: fetchNextPage,
                  builderDelegate: PagedChildBuilderDelegate<String>(
                    itemBuilder: (context, item, index) => ListTile(
                      title: Text(item),
                      subtitle: Text('Page: ${state.nextIntPageKey}'),
                    ),
                  ),
                ),
          ),

          ///
          ///
          PagingListener<int, String>(
            controller: _controller2,
            builder: (context, state, fetchNextPage) =>
                PagedSliverList<int, String>(
                  state: state,
                  fetchNextPage: fetchNextPage,
                  builderDelegate: PagedChildBuilderDelegate<String>(
                    itemBuilder: (context, item, index) => ListTile(
                      title: Text(item),
                      subtitle: Text('Page: ${state.nextIntPageKey}'),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class MyService {
  Future<List<String>> getData(int page) async {
    await Future.delayed(const Duration(seconds: 1));
    if (page > 2) return [];
    List<String> list = List.generate(10, (index) => 'One $page$index');
    return list;
  }

  Future<List<String>> getData2(int page) async {
    await Future.delayed(const Duration(seconds: 1));
    if (page > 4) return [];
    List<String> list = List.generate(10, (index) => 'Two $page$index');
    return list;
  }
}
