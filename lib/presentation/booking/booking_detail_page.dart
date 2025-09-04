import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/design_system/app_colors.dart';
import '../../domain/entities/service_item.dart';
import '../common/widgets/shop_image.dart';
import '../common/widgets/image_viewer.dart';

class BookingDetailPage extends StatefulWidget {
  final String shopId;
  final String shopName;
  final List<ServiceItem> services;
  final List<String>? imageUrls;

  const BookingDetailPage({
    super.key,
    required this.shopId,
    required this.shopName,
    required this.services,
    this.imageUrls,
  });

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedServiceIndex;
  String? _selectedTime;

  List<String> get _timeSlots {
    return [
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '12:00',
      '13:00',
      '13:30',
      '14:00',
      '14:30',
      '15:00',
      '15:30',
      '16:00',
      '16:30',
      '17:00',
      '17:30',
      '18:00',
    ];
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      helpText: '예약 날짜 선택',
      cancelText: '취소',
      confirmText: '선택',
    );
    if (d != null) {
      setState(() => _selectedDate = d);
    }
  }

  void _confirm() {
    if (_selectedServiceIndex == null || _selectedTime == null) return;
    final svc = widget.services[_selectedServiceIndex!];
    final msg =
        '${widget.shopName} ${_fmtDate(_selectedDate)} $_selectedTime\n${svc.name} 예약이 준비되었어요';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    Navigator.of(context).maybePop();
  }

  void _openMap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final c = Theme.of(context).colorScheme;
        final t = Theme.of(context).textTheme;
        return SizedBox(
          height: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '지도',
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: c.onSurfaceVariant,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map, size: 64, color: c.primary),
                      const SizedBox(height: 8),
                      Text('지도 모킹', style: t.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final hasImages = widget.imageUrls != null && widget.imageUrls!.isNotEmpty;
    final urls = widget.imageUrls ?? const <String>[];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: const Text('예약하기'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImages)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: _AutoCarousel(urls: urls),
                ),
              ),
            if (hasImages) const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.shopName,
                    style: t.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: _pickDate,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event),
                      const SizedBox(width: 6),
                      Text(_fmtDate(_selectedDate)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.outlineVariant),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.place, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '서울시 중구 을지로 00길 12 3층',
                                    style: t.bodyMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.alternate_email, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '@jelloshop_official',
                                    style: t.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.schedule, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '영업: 월-금 10:00-19:00 · 토 10:00-16:00 · 일 휴무',
                                    style: t.bodyMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _openMap,
                        icon: const Icon(Icons.map),
                        color: c.primary,
                        tooltip: '지도',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '시술 선택',
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.services.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: c.outlineVariant),
                itemBuilder: (context, index) {
                  final s = widget.services[index];
                  final selected = _selectedServiceIndex == index;
                  return ListTile(
                    title: Text(
                      s.name,
                      style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text('${s.durationMinutes}분'),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${s.price}원',
                          style: t.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: c.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        AnimatedScale(
                          scale: selected ? 1 : 0.9,
                          duration: const Duration(milliseconds: 120),
                          child: Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selected ? c.primary : c.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => setState(() => _selectedServiceIndex = index),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '시간 선택',
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((time) {
                final selected = _selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedTime = time),
                  selectedColor: c.primary,
                  labelStyle: TextStyle(
                    color: selected ? c.onPrimary : c.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    (_selectedServiceIndex != null && _selectedTime != null)
                    ? AppColors.primaryBlue
                    : c.surfaceVariant,
                foregroundColor:
                    (_selectedServiceIndex != null && _selectedTime != null)
                    ? Colors.white
                    : c.onSurfaceVariant,
              ),
              onPressed:
                  (_selectedServiceIndex != null && _selectedTime != null)
                  ? _confirm
                  : null,
              child: const Text('예약 내용 확인'),
            ),
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    return '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
  }
}

class _AutoCarousel extends StatefulWidget {
  final List<String> urls;

  const _AutoCarousel({required this.urls});

  @override
  State<_AutoCarousel> createState() => _AutoCarouselState();
}

class _AutoCarouselState extends State<_AutoCarousel> {
  late final PageController _controller;
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final n = widget.urls.length;
    _controller = PageController(initialPage: n > 1 ? 1 : 0);
    if (n > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!mounted) return;
        final current = _controller.page?.round() ?? 1;
        _controller.animateToPage(
          current + 1,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _openViewer() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => ImageViewer(urls: widget.urls, initialIndex: _index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.urls.length;
    if (n <= 1) {
      final u = widget.urls.isNotEmpty ? widget.urls.first : '';
      return GestureDetector(
        onTap: _openViewer,
        child: ShopImage(src: u, fit: BoxFit.cover),
      );
    }
    return GestureDetector(
      onTap: _openViewer,
      child: PageView.builder(
        controller: _controller,
        itemCount: n + 2,
        onPageChanged: (i) {
          final logical = (i - 1 + n) % n;
          setState(() => _index = logical);
          if (i == 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _controller.jumpToPage(n);
            });
          } else if (i == n + 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _controller.jumpToPage(1);
            });
          }
        },
        itemBuilder: (context, i) {
          final logical = (i - 1 + n) % n;
          final u = widget.urls[logical];
          return ShopImage(src: u, fit: BoxFit.cover);
        },
      ),
    );
  }
}
