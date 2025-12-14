import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransPaymentPage extends StatefulWidget {
  final String snapToken;
  final String transactionCode;

  const MidtransPaymentPage({
    super.key,
    required this.snapToken,
    required this.transactionCode,
  });

  @override
  State<MidtransPaymentPage> createState() => _MidtransPaymentPageState();
}

class _MidtransPaymentPageState extends State<MidtransPaymentPage> {
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // For web platform, open payment URL in new tab
      _openPaymentInBrowser();
    } else {
      // For mobile platforms, use WebView
      _initializeWebView();
    }
  }

  Future<void> _openPaymentInBrowser() async {
    final url = _getMidtransUrl();
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // On web, we can't detect payment completion automatically
      // Show a dialog to let user manually confirm
      if (mounted) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _showWebPaymentDialog();
          }
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open payment page'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  void _showWebPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Payment In Progress'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please complete your payment in the opened tab.'),
            SizedBox(height: 16),
            Text('Click the appropriate button below after completing payment.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop({'status': 'cancelled', 'message': 'Payment cancelled'});
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop({'status': 'pending', 'message': 'Payment pending verification'});
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            
            // Check if payment is completed or cancelled
            if (url.contains('status_code=200') || url.contains('transaction_status=settlement')) {
              _handlePaymentSuccess();
            } else if (url.contains('status_code=201') || url.contains('transaction_status=pending')) {
              _handlePaymentPending();
            } else if (url.contains('status_code=202') || url.contains('transaction_status=deny')) {
              _handlePaymentFailed('Payment denied');
            } else if (url.contains('status_code=407') || url.contains('transaction_status=expire')) {
              _handlePaymentFailed('Payment expired');
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading payment page: ${error.description}'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      )
      ..loadRequest(
        Uri.parse(_getMidtransUrl()),
      );
  }

  String _getMidtransUrl() {
    // Midtrans Snap URL with the snap token
    // Use sandbox for testing, change to production URL when ready
    const baseUrl = 'https://app.sandbox.midtrans.com/snap/v2/vtweb';
    // Production URL: 'https://app.midtrans.com/snap/v2/vtweb'
    
    return '$baseUrl/${widget.snapToken}';
  }

  void _handlePaymentSuccess() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop({'status': 'success', 'message': 'Payment successful'});
      }
    });
  }

  void _handlePaymentPending() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop({'status': 'pending', 'message': 'Payment pending'});
      }
    });
  }

  void _handlePaymentFailed(String message) {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop({'status': 'failed', 'message': message});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // On web, show a simple loading screen since payment opens in new tab
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Payment - ${widget.transactionCode}'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Opening payment page...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // For mobile platforms, show WebView
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment - ${widget.transactionCode}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _showCancelDialog();
          },
        ),
      ),
      body: Stack(
        children: [
          if (_controller != null) WebViewWidget(controller: _controller!),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading payment page...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Payment'),
        content: const Text('Are you sure you want to cancel this payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop({'status': 'cancelled', 'message': 'Payment cancelled'});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
