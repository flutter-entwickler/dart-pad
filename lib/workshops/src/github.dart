import 'package:dart_pad/util/github.dart';
import 'package:http/http.dart' as http;

import 'exceptions.dart';
import 'fetcher_impl.dart';

class GithubWorkshopFetcher extends WorkshopFetcherImpl {
  static const String _apiHostname = 'api.github.com';

  final String owner;
  final String repo;
  final String? ref;
  final String? path;

  GithubWorkshopFetcher({
    required this.owner,
    required this.repo,
    this.ref,
    this.path,
  });

  @override
  Future<String> loadFileContents(List<String> relativePath) async {
    final url = _buildFileUrl(relativePath);
    final res = await http.get(url);

    final statusCode = res.statusCode;
    if (statusCode == 404) {
      throw WorkshopFetchException(WorkshopFetchExceptionType.contentNotFound);
    } else if (statusCode == 403) {
      throw WorkshopFetchException(
          WorkshopFetchExceptionType.rateLimitExceeded);
    } else if (statusCode != 200) {
      throw WorkshopFetchException(WorkshopFetchExceptionType.unknown);
    }

    return extractGitHubResponseBody(res.body);
  }

  Uri _buildFileUrl(List<String> pathSegments) {
    final p = path;
    final filePath = <String>[if (p != null) p, ...pathSegments];
    return Uri(
      scheme: 'https',
      host: _apiHostname,
      pathSegments: [
        'repos',
        owner,
        repo,
        'contents',
        ...filePath,
      ],
      queryParameters: {if (ref != null) 'ref': ref},
    );
  }
}
