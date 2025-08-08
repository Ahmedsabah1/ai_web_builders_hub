import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/tool.dart';
import '../../../core/constants/app_constants.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final Tool? tool;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
    this.tool,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _webViewController;
  String _currentUrl = '';
  String _currentTitle = '';
  bool _isLoading = true;
  bool _canGoBack = false;
  bool _canGoForward = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
    _currentTitle = widget.title;
  }

  Future<void> _refresh() async {
    await _webViewController?.reload();
  }

  Future<void> _goBack() async {
    if (_canGoBack) {
      await _webViewController?.goBack();
    }
  }

  Future<void> _goForward() async {
    if (_canGoForward) {
      await _webViewController?.goForward();
    }
  }

  Future<void> _openInBrowser() async {
    final Uri uri = Uri.parse(_currentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open URL in browser'),
          ),
        );
      }
    }
  }

  Future<void> _shareUrl() async {
    await Share.share(
      _currentUrl,
      subject: _currentTitle,
    );
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh'),
              onTap: () {
                Navigator.pop(context);
                _refresh();
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text('Open in Browser'),
              onTap: () {
                Navigator.pop(context);
                _openInBrowser();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _shareUrl();
              },
            ),
            if (widget.tool != null) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Tool Information'),
                subtitle: Text(widget.tool!.description),
                onTap: () {
                  Navigator.pop(context);
                  _showToolInfo();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showToolInfo() {
    if (widget.tool == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.tool!.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(widget.tool!.description),
              
              if (widget.tool!.category != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(widget.tool!.category!.name),
              ],
              
              if (widget.tool!.pricing != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Pricing',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(widget.tool!.pricing!),
              ],
              
              if (widget.tool!.skillLevel != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Skill Level',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(widget.tool!.skillLevel!),
              ],
              
              if (widget.tool!.rating != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Rating',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('${widget.tool!.rating!.toStringAsFixed(1)}/5.0'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentTitle,
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (_currentUrl != widget.url)
              Text(
                Uri.parse(_currentUrl).host,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _canGoBack ? _goBack : null,
            icon: const Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: _canGoForward ? _goForward : null,
            icon: const Icon(Icons.arrow_forward_ios),
          ),
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: _showMenu,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          if (_isLoading)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          
          // WebView
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(widget.url),
              ),
              initialSettings: InAppWebViewSettings(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                iframeAllow: 'camera; microphone',
                iframeAllowFullscreen: true,
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  _isLoading = true;
                  _currentUrl = url?.toString() ?? '';
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  _isLoading = false;
                  _currentUrl = url?.toString() ?? '';
                });
                
                // Get page title
                final title = await controller.getTitle();
                if (title != null && title.isNotEmpty) {
                  setState(() {
                    _currentTitle = title;
                  });
                }
                
                // Update navigation buttons
                final canGoBack = await controller.canGoBack();
                final canGoForward = await controller.canGoForward();
                setState(() {
                  _canGoBack = canGoBack;
                  _canGoForward = canGoForward;
                });
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              onTitleChanged: (controller, title) {
                if (title != null && title.isNotEmpty) {
                  setState(() {
                    _currentTitle = title;
                  });
                }
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url;
                
                // Handle external links that should open in system browser
                if (uri != null) {
                  final url = uri.toString();
                  if (url.startsWith('mailto:') ||
                      url.startsWith('tel:') ||
                      url.startsWith('sms:')) {
                    final Uri externalUri = Uri.parse(url);
                    if (await canLaunchUrl(externalUri)) {
                      await launchUrl(externalUri);
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                }
                
                return NavigationActionPolicy.ALLOW;
              },
            ),
          ),
        ],
      ),
    );
  }
}