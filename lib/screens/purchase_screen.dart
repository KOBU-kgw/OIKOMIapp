import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../services/purchase_service.dart';
import '../widgets/adaptive/adaptive_app_bar.dart';
import 'threshold_editor_screen.dart';

const _privacyUrl = 'https://kobu-kgw.github.io/OIKOMIapp/privacy.html';
const _termsUrl = 'https://kobu-kgw.github.io/OIKOMIapp/terms.html';

/// カスタム閾値パック購入画面。
/// 「価格・買い切りであること・対象機能」を明示し、復元ボタンを常設する（審査要件）。
class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final _service = PurchaseService();

  @override
  void initState() {
    super.initState();
    _service.isUnlocked.addListener(_onUnlocked);
    _service.lastError.addListener(_onError);
  }

  @override
  void dispose() {
    _service.isUnlocked.removeListener(_onUnlocked);
    _service.lastError.removeListener(_onError);
    super.dispose();
  }

  void _onUnlocked() {
    if (!_service.isUnlocked.value || !mounted) return;
    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.purchaseSuccess)));
    // 購入完了 → そのまま閾値エディタへ
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ThresholdEditorScreen()),
    );
  }

  void _onError() {
    final message = _service.lastError.value;
    if (message == null || !mounted) return;
    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.purchaseErrorGeneric)));
  }

  Future<void> _launchUrl(String url) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(l.settingsUrlError)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: adaptiveAppBar(title: l.purchaseScreenTitle),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(Icons.tune, size: 56, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              l.purchaseHeadline,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l.purchaseBody,
              style: const TextStyle(fontSize: 15, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l.purchaseOneTime,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 購入ボタン（ストア未接続・商品未取得時は無効化して理由を表示）
            ValueListenableBuilder(
              valueListenable: _service.product,
              builder: (context, product, _) {
                return ValueListenableBuilder(
                  valueListenable: _service.purchasePending,
                  builder: (context, pending, _) {
                    final canBuy = product != null && !pending;
                    return Column(
                      children: [
                        FilledButton(
                          onPressed: canBuy ? _service.buy : null,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                          child: pending
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5),
                                )
                              : Text(
                                  product != null
                                      ? l.purchaseButton(product.price)
                                      : l.purchaseUnavailable,
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                        const SizedBox(height: 8),
                        // 復元は常設（別端末・再インストール時の回復手段）
                        TextButton(
                          onPressed: pending ? null : _service.restore,
                          child: Text(l.settingsRestorePurchase),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            Text(
              l.purchaseScopeNote,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _launchUrl(_termsUrl),
                  child: Text(l.settingsTermsOfService,
                      style: const TextStyle(fontSize: 12)),
                ),
                TextButton(
                  onPressed: () => _launchUrl(_privacyUrl),
                  child: Text(l.settingsPrivacyPolicy,
                      style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
