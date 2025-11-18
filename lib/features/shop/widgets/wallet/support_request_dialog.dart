import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../data/models/transaction/send_inquiry_model.dart';
import '../../../../data/models/transaction/wallet_transaction_model.dart';
import '../../../../data/repositories/transaction_repository.dart';
import '../../../../data/services/apis/transaction_service.dart';
import '../../../../core/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportRequestDialog {
  static Future<bool?> show(
      BuildContext context,
      String transactionId,
      List<WalletNote> userNotes,
      ) async {
    final TextEditingController _controller = TextEditingController();
    final loc = AppLocalizations.of(context);

    bool showRequestForm = userNotes.isEmpty;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final hasNotes = userNotes.isNotEmpty;

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(showRequestForm
                      ? loc.translate("request_support")
                      : loc.translate("your_request")),
                  if (hasNotes)
                    IconButton(
                      icon: Icon(
                        showRequestForm
                            ? Icons.arrow_back
                            : Icons.arrow_forward,
                      ),
                      onPressed: () {
                        setState(() {
                          showRequestForm = !showRequestForm;
                        });
                      },
                    ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: showRequestForm
                    ? _buildCreateRequest(context, loc, _controller)
                    : _buildNotesList(context, loc, userNotes),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, null),
                  child: Text(loc.translate("cancel")),
                ),
                if (showRequestForm)
                  ElevatedButton(
                    onPressed: () async {
                      final content = _controller.text.trim();
                      if (content.isEmpty) return;

                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('token');
                      if (token == null) {
                        Navigator.pop(ctx, false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Token không tồn tại!")),
                        );
                        return;
                      }

                      final repo = TransactionRepository(
                        TransactionService(ApiClient()),
                      );

                      final success = await repo.sendInquiry(
                        token: token,
                        transactionId: transactionId,
                        request: SendInquiryRequest(userNotes: content),
                      );

                      Navigator.pop(ctx, success);
                    },
                    child: Text(loc.translate("confirm")),
                  ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result
              ? loc.translate("support_request_success")
              : loc.translate("support_request_failed")),
        ),
      );
    }

    return result;
  }

  // UI: List userNotes
  static Widget _buildNotesList(
      BuildContext context, AppLocalizations loc, List<WalletNote> notes) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate("support_request_sent"),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Sử dụng ListView nếu nhiều note, để scroll được
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final note = notes[index];
                final formattedDate =
                    "${note.createdAt.toLocal().year}-${note.createdAt.toLocal().month.toString().padLeft(2,'0')}-${note.createdAt.toLocal().day.toString().padLeft(2,'0')} "
                    "${note.createdAt.toLocal().hour.toString().padLeft(2,'0')}:${note.createdAt.toLocal().minute.toString().padLeft(2,'0')}";
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.notes,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // UI: Create request form
  static Widget _buildCreateRequest(
      BuildContext context, AppLocalizations loc, TextEditingController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(loc.translate("your_support_request")),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: loc.translate("your_problem"),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
