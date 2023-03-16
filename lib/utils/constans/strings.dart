// App
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String appTitle = 'Flutter Clean Architecture';

// Networking and APIs
const String baseUrl = 'https://newsapi.org/v2';
String defaultApiKey = dotenv.env['API_KEY'] ?? "";
const String defaultSources = 'bbc-news, abc-news, al-jazeera-english';

// Storage and Databases
const String articlesTableName = 'articles_table';
const String databaseName = 'app_database.db';
