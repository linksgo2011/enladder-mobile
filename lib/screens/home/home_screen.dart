import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../books/book_list_screen.dart';
import '../../services/book_service.dart';
import '../books/book_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BookService _bookService = BookService();
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final books = await _bookService.fetchBooks();
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载书籍失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: '搜索书籍',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _performSearch();
                    },
                    child: const Text('搜索'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '推荐书籍',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookListScreen()),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('更多'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBookGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _books.length > 8 ? 8 : _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return _buildBookCard(book);
      },
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(book: book),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                'https://app.enladder.com/${book.cover}', // 使用完整的 URL
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.book, size: 60),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title ?? book.cnTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    book.author,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '难度: ${book.difficulty}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getDifficultyColor(book.difficulty),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'Easy':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  void _performSearch() {
    String searchTerm = _searchController.text.trim();
    if (searchTerm.isNotEmpty) {
      // 过滤书籍列表
      List<dynamic> searchResults = _books.where((book) {
        return (book.title?.toLowerCase().contains(searchTerm.toLowerCase()) ?? false) ||
               (book.author?.toLowerCase().contains(searchTerm.toLowerCase()) ?? false);
      }).toList();

      // 导航到搜索结果页面
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(
            searchTerm: searchTerm,
            searchType: '书籍',
            searchResults: searchResults, // 传递搜索结果
          ),
        ),
      );
    } else {
      // 如果搜索框为空，可以选择不执行任何操作或显示提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入搜索关键词')),
      );
    }
  }
}

// 更新 SearchResultsScreen 以接收搜索结果
class SearchResultsScreen extends StatelessWidget {
  final String searchTerm;
  final String searchType;
  final List<dynamic> searchResults; // 新增搜索结果参数

  const SearchResultsScreen({
    Key? key,
    required this.searchTerm,
    required this.searchType,
    required this.searchResults, // 新增搜索结果参数
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$searchType 搜索结果'),
      ),
      body: searchResults.isEmpty
          ? Center(child: Text('没找到与 "$searchTerm" 相关的结果'))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final book = searchResults[index];
                return ListTile(
                  title: Text(book.title ?? '未知书名'),
                  subtitle: Text(book.author ?? '未知作者'),
                  onTap: () {
                    // 点击后导航到书籍详情页面
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(book: book),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
