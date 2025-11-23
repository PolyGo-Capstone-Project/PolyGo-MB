import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/models/events/event_details_model.dart';
import '../../../../data/repositories/event_repository.dart';
import '../../../../data/services/apis/event_service.dart';

class StatisticEvent extends StatefulWidget {
  final String eventId;
  final void Function(double)? onPayoutClaimed;

  const StatisticEvent({super.key, required this.eventId, this.onPayoutClaimed});

  @override
  State<StatisticEvent> createState() => _StatisticEventState();
}

class _StatisticEventState extends State<StatisticEvent> {
  late final EventRepository _eventRepository;
  EventDetailsModel? _event;
  bool _loading = true;
  bool _payoutLoading = false;

  @override
  void initState() {
    super.initState();
    final api = ApiClient();
    final service = EventService(api);
    _eventRepository = EventRepository(service);
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      if (token.isEmpty) throw Exception("Missing token");

      final detail = await _eventRepository.getEventDetails(
        token: token,
        eventId: widget.eventId,
      );

      setState(() {
        _event = detail;
        _loading = false;
      });
    } catch (e, st) {
      setState(() => _loading = false);
    }
  }

  Future<void> _claimPayout() async {
    if (_event == null) return;

    setState(() => _payoutLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";
      if (token.isEmpty) throw Exception("Missing token");

      // Gọi API claim
      await _eventRepository.claimHostPayout(
        token: token,
        eventId: _event!.id,
      );

      // Load lại chi tiết sự kiện
      final updatedEvent = await _eventRepository.getEventDetails(
        token: token,
        eventId: _event!.id,
      );

      setState(() {
        _event = updatedEvent;
        _payoutLoading = false;
      });

      final claimedAmount = updatedEvent?.hostPayoutAmount ?? 0.0;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Nhận tiền thành công: ${claimedAmount.toStringAsFixed(0)} VND"),
        ),
      );

      widget.onPayoutClaimed?.call(claimedAmount);

    } catch (e, st) {
      setState(() => _payoutLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Nhận tiền thất bại"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final colorPrimary = theme.colorScheme.primary;

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text("Thống kê sự kiện")),
        body: Center(child: CircularProgressIndicator(color: colorPrimary)),
      );
    }

    if (_event == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Thống kê sự kiện")),
        body: Center(child: Text("Không có dữ liệu sự kiện")),
      );
    }

    final e = _event!;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        title: Text("Thống kê sự kiện"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sw(context, 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (e.bannerUrl.isNotEmpty)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(e.bannerUrl, fit: BoxFit.cover),
                ),
              SizedBox(height: sh(context, 12)),
              Text(
                e.title,
                style: t.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: st(context, 20),
                ),
              ),
              SizedBox(height: sh(context, 20)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(sw(context, 20)),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(sw(context, 16)),
                  border: Border.all(color: Colors.green.shade300, width: 2),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: sw(context, 16),
                  runSpacing: sh(context, 12),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Doanh thu sự kiện",
                          style: t.titleMedium?.copyWith(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w700,
                            fontSize: st(context, 18),
                          ),
                        ),
                        SizedBox(height: sh(context, 4)),
                        Text(
                          "${e.revenue.toStringAsFixed(0)} VND",
                          style: t.headlineMedium?.copyWith(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: st(context, 24),
                          ),
                        ),
                      ],
                    ),
                    if (!e.hostPayoutClaimed && e.fee > 0)
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: sw(context, 200)),
                        child: AppButton(
                          text: "Nhận tiền về ví",
                          onPressed: _payoutLoading ? null : _claimPayout,
                          variant: ButtonVariant.primary,
                          size: ButtonSize.lg,
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: sw(context, 16), vertical: sh(context, 12)),
                        decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          borderRadius: BorderRadius.circular(sw(context, 12)),
                        ),
                        child: Text(
                          "Đã nhận ${e.hostPayoutAmount.toStringAsFixed(0)} VND",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: st(context, 16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: sh(context, 22)),
              Text(
                "Thông tin chi tiết",
                style: t.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: st(context, 18),
                ),
              ),
              SizedBox(height: sh(context, 12)),
              _buildInfoRow(Icons.people, "Số người tham gia", "${e.numberOfParticipants}"),
              _buildInfoRow(Icons.attach_money, "Phí đăng ký", "${e.fee} đ"),
              _buildInfoRow(Icons.category, "Loại gói", e.planType),
              _buildInfoRow(
                Icons.schedule,
                "Bắt đầu",
                DateFormat('dd MMM yyyy, HH:mm').format(e.startAt.toLocal()),
              ),
              _buildInfoRow(
                Icons.schedule,
                "Kết thúc",
                DateFormat('dd MMM yyyy, HH:mm').format(e.endAt!.toLocal()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: sh(context, 10)),
      child: Row(
        children: [
          Icon(icon, size: st(context, 20), color: Theme.of(context).colorScheme.primary),
          SizedBox(width: sw(context, 8)),
          Expanded(
            child: Text(
              label,
              style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: t.bodyMedium,
          ),
        ],
      ),
    );
  }
}
