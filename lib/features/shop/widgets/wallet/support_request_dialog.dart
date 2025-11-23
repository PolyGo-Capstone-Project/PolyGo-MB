import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/models/transaction/send_inquiry_model.dart';
import '../../../../data/models/transaction/wallet_transaction_model.dart';
import '../../../../data/repositories/transaction_repository.dart';
import '../../../../data/services/apis/transaction_service.dart';
import '../../../../core/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SupportTab { details, notesList, createRequest }

class SupportRequestDialog {
  static Future<bool?> show(
      BuildContext context,
      String transactionId,
      List<WalletNote> userNotes, {
        WalletTransaction? transaction,
      }) async {
    final TextEditingController _controller = TextEditingController();
    final loc = AppLocalizations.of(context);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Gradient cardBackground = isDark
        ? const LinearGradient(
      colors: [Color(0xFF1E1E1E), Color(0xFF2C2C2C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    )
        : const LinearGradient(
      colors: [Colors.white, Colors.white],
    );

    final showDetails = transaction != null &&
        ['Withdraw', 'Earn', 'Refund'].contains(transaction.transactionType);

    SupportTab currentTab;
    if (showDetails) {
      currentTab = SupportTab.details;
    } else if (userNotes.isNotEmpty) {
      currentTab = SupportTab.notesList;
    } else {
      currentTab = SupportTab.createRequest;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final hasNotes = userNotes.isNotEmpty;

            void goNextTab() {
              switch (currentTab) {
                case SupportTab.details:
                  currentTab = hasNotes ? SupportTab.notesList : SupportTab.createRequest;
                  break;
                case SupportTab.notesList:
                  currentTab = SupportTab.createRequest;
                  break;
                case SupportTab.createRequest:
                  break;
              }
            }

            void goPreviousTab() {
              switch (currentTab) {
                case SupportTab.createRequest:
                  currentTab = hasNotes ? SupportTab.notesList : (showDetails ? SupportTab.details : SupportTab.createRequest);
                  break;
                case SupportTab.notesList:
                  currentTab = showDetails ? SupportTab.details : SupportTab.notesList;
                  break;
                case SupportTab.details:
                  break;
              }
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentTab == SupportTab.details
                              ? loc.translate("transaction_details")
                              : currentTab == SupportTab.notesList
                              ? loc.translate("your_request")
                              : loc.translate("request_support"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            if (currentTab != SupportTab.details)
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: isDark ? Colors.white : Colors.black54,
                                ),
                                onPressed: () {
                                  setState(goPreviousTab);
                                },
                              ),
                            if ((currentTab != SupportTab.createRequest) &&
                                (currentTab != SupportTab.details || hasNotes || !hasNotes))
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: isDark ? Colors.white : Colors.black54,
                                ),
                                onPressed: () {
                                  setState(goNextTab);
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.maxFinite,
                      child: currentTab == SupportTab.details && showDetails
                          ? _buildDetails(context, transaction!, isDark)
                          : currentTab == SupportTab.notesList
                          ? _buildNotesList(context, loc, userNotes, isDark)
                          : _buildCreateRequest(context, loc, _controller, isDark),
                    ),
                    const SizedBox(height: 16),
                    if (currentTab == SupportTab.createRequest)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton(
                            text: loc.translate("confirm"),
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

                              if (success) {
                                setState(() {
                                  currentTab = SupportTab.notesList;
                                  userNotes.add(WalletNote(
                                    id: UniqueKey().toString(),
                                    notes: content,
                                    createdAt: DateTime.now(),
                                  ));
                                  _controller.clear();
                                });
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? loc.translate("support_request_success")
                                      : loc.translate("support_request_failed")),
                                ),
                              );
                            },
                            size: ButtonSize.sm,
                            variant: ButtonVariant.primary,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    return result;
  }

  static Widget _buildNotesList(
      BuildContext context, AppLocalizations loc, List<WalletNote> notes, bool isDark) {
    final Color textColor = isDark ? Colors.white70 : Colors.black87;
    final Color dateColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate("support_request_sent"),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
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
                    border: Border.all(
                      color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.notes,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: dateColor,
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

  static Widget _buildCreateRequest(
      BuildContext context, AppLocalizations loc, TextEditingController controller, bool isDark) {
    final Color textColor = isDark ? Colors.white70 : Colors.black87;
    final Color borderColor = isDark ? Colors.grey.shade600 : Colors.grey.shade400;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            maxLines: 3,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: loc.translate("your_request"),
              hintStyle: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildDetails(BuildContext context, WalletTransaction transaction, bool isDark) {
    final Color textColor = isDark ? Colors.white70 : Colors.black87;
    final Color labelColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    Widget row(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: Text(
                "$label:",
                style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row("Type", transaction.transactionType),
          row("Method", transaction.transactionMethod),
          row("Status", transaction.transactionStatus),
          row("Description", transaction.description),
          if (transaction.transactionType == "Withdraw") ...[
            row("Bank Name", transaction.bankName),
            row("Bank Number", transaction.bankNumber),
            row("Account Name", transaction.accountName),
          ],
        ],
      ),
    );
  }
}
