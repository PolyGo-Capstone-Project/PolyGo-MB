import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_client.dart';
import '../../../data/models/gift/gift_me_response.dart';
import '../../../data/models/gift/gift_present_request.dart';
import '../../../data/models/user/user_list_response.dart';
import '../../../data/repositories/gift_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/services/gift_service.dart';
import '../../../data/services/user_service.dart';
import '../../../core/utils/responsive.dart';
import '../../../../core/localization/app_localizations.dart';


class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  late final UserRepository _repo;
  List<UserItem> _users = [];
  bool _loading = true;
  String? _error;
  late final GiftRepository _giftRepo;
  GiftMeResponse? _giftResponse;

  @override
  void initState() {
    super.initState();
    _repo = UserRepository(UserService(ApiClient()));
    _giftRepo = GiftRepository(GiftService(ApiClient()));
    _loadUsers();
  }

  Future<GiftMeResponse?> _loadMyGifts() async {
    try {
      final loc = AppLocalizations.of(context);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.translate("token_missing")),
            duration: const Duration(seconds: 2),
          ),
        );
        return null;
      }

      final res = await _giftRepo.getMyGifts(
        token: token,
        pageNumber: 1,
        pageSize: 50,
      );
      return res;
    } catch (e) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.translate("list_gift_error")),
          duration: const Duration(seconds: 2),
        ),
      );
      return null;
    }
  }

  Future<void> _sendGift({
    required String userId,
    required GiftMeItem gift,
    required int quantity,
    String? message,
    required bool isAnonymous,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return;

    try {
      final request = GiftPresentRequest(
        receiverId: userId,
        giftId: gift.id,
        quantity: quantity,
        message: message,
        isAnonymous: isAnonymous,
      );

      final response = await _giftRepo.presentGift(
        token: token,
        request: request,
      );

      if (response != null) {
        final loc = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${loc.translate("gift_sent")} '
                '${response.giftName} '
                '${loc.translate("to")} '
                '${response.receiverName}'
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.translate("gift_sent_failed")),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        setState(() {
          _error = "Missing token. Please log in first.";
          _loading = false;
        });
        return;
      }

      final res = await _repo.getUsers(token);
      setState(() {
        _users = res.items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorPrimary = const Color(0xFF2563EB);
    final loc = AppLocalizations.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Failed to load users: $_error",
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUsers,
              child: Text(loc.translate("retry")),
            ),
          ],
        ),
      );
    }

    if (_users.isEmpty) {
      return Center(
        child: Text(loc.translate("error"),
          style: theme.textTheme.titleMedium,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: ListView.builder(
        padding: EdgeInsets.all(sw(context, 16)),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];

          return Container(
            margin: EdgeInsets.only(bottom: sh(context, 12)),
            padding: EdgeInsets.all(sw(context, 14)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(sw(context, 12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                          ? Image.network(
                        user.avatarUrl!,
                        width: sw(context, 60),
                        height: sw(context, 60),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildEmptyAvatar(),
                      )
                          : _buildEmptyAvatar(),
                    ),
                    SizedBox(width: sw(context, 16)),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (user.introduction != null &&
                              user.introduction!.isNotEmpty) ...[
                            SizedBox(height: sh(context, 4)),
                            Text(
                              user.introduction!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: sh(context, 10)),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _showGiftDialog(context, user),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: sw(context, 16),
                        vertical: sh(context, 10),
                      ),
                    ),
                    child: Text(
                      loc.translate("send_gift"),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
        },
      ),
    );
  }

  Widget _buildEmptyAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 30),
    );
  }

  void _showGiftDialog(BuildContext context, UserItem user) async {
    final gifts = await _loadMyGifts();
    final loc = AppLocalizations.of(context);
    if (gifts == null || gifts.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.translate("gift_not_enough")),
          duration: const Duration(seconds: 2),
        ),
      );

      return;
    }

    GiftMeItem? selectedGift;
    int quantity = 1;
    String? message;
    bool isAnonymous = false;
    int currentStep = 0;

    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final crossAxisCount = (screenWidth ~/ 150).clamp(1, 4);

        return StatefulBuilder(
          builder: (context, setState) {
            Widget stepContent() {
              if (currentStep == 0) {
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: gifts.items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final gift = gifts.items[index];
                    final isSelected = selectedGift == gift;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGift = gift;
                          quantity = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2563EB).withOpacity(0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2563EB)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x11000000),
                                blurRadius: 6,
                                offset: Offset(0, 4)),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              gift.iconUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.card_giftcard, size: 50),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              gift.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${loc.translate("owned")}: ${gift.quantity}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: quantity.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: loc.translate('quantity'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (val) {
                        final q = int.tryParse(val);
                        if (q != null && q > 0) quantity = q;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: message,
                      decoration: InputDecoration(
                        labelText: loc.translate('message_optional'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (val) => message = val,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: isAnonymous,
                          onChanged: (val) {
                            setState(() {
                              isAnonymous = val ?? false;
                            });
                          },
                        ),
                        Text(loc.translate('send_anonymously')),
                      ],
                    ),
                  ],
                );
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                currentStep == 0
                    ? '${loc.translate("choose_gift_for")} ${user.name}'
                    : loc.translate("gift_info"),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: stepContent(),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
              actions: [
                if (currentStep == 1)
                  TextButton(
                    onPressed: () => setState(() => currentStep = 0),
                    child: Text(loc.translate("back")),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (currentStep == 0) {
                      if (selectedGift == null) return;
                      setState(() => currentStep = 1);
                    } else {
                      Navigator.pop(context);
                      _sendGift(
                        userId: user.id,
                        gift: selectedGift!,
                        quantity: quantity,
                        message: message,
                        isAnonymous: isAnonymous,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    currentStep == 0
                        ? loc.translate("next")
                        : loc.translate("send_gift"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

}
