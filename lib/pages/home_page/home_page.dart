import 'package:flutter/cupertino.dart';
import 'package:revision_quotes_app/headers.dart';
import 'package:revision_quotes_app/routes/app_routes.dart';
import 'package:revision_quotes_app/utils/app_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppData.instance.allCategories.length,
              itemBuilder: (context, index) => ElevatedButton(
                onPressed: () {},
                child: Text(AppData.instance.allCategories[index]),
              ),
            ),
          ),
          Expanded(
            flex: 13,
            child: GridView.builder(
              itemCount: AppData.instance.allQuotes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Future.delayed(
                    const Duration(milliseconds: 500),
                    () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.instance.detailPage,
                        arguments: AppData.instance.allQuotes[index],
                      );
                    },
                  );
                },
                splashColor: Colors.amber,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppData.instance.allQuotes[index].quote,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("- ${AppData.instance.allQuotes[index].author}"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
