import 'package:flutter/material.dart';
import '../common/widgets/section_header.dart';
import '../common/widgets/quick_actions.dart';

class BookingTabScreen extends StatelessWidget {
  const BookingTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      color: c.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _GradientPromoCard(),
            SizedBox(height: 12),
            _QuickActionsRow(),
            SizedBox(height: 12),
            SectionHeader(
              title: '다가오는 예약',
              actionText: '전체보기',
              onAction: _noop,
            ),
            SizedBox(height: 8),
            _BookingEmptyCard(),
          ],
        ),
      ),
    );
  }
}

class _GradientPromoCard extends StatefulWidget {
  const _GradientPromoCard();

  @override
  State<_GradientPromoCard> createState() => _GradientPromoCardState();
}

class _GradientPromoCardState extends State<_GradientPromoCard> {
  double _scale = 0.95;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 60),
      () => setState(() => _scale = 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutBack,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.primary, color.primaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이달의 추천',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: color.onPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '가을 따뜻한 톤 아트',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.onPrimary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '지금 예약하고 혜택 받기',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: color.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return QuickActionsRow(
      onNailTap: _noop,
      onLashTap: _noop,
      onBrowTap: _noop,
      onEstimateTap: _noop,
    );
  }
}

class _BookingEmptyCard extends StatelessWidget {
  const _BookingEmptyCard();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: c.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: c.onSecondaryContainer.withValues(alpha: 0.12),
            child: Icon(Icons.calendar_today, color: c.onSecondaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '예약이 비어 있어요',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: c.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '지금 예약하고 아름다움을 준비해 보세요',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: c.onSecondaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(onPressed: _noop, child: const Text('예약하기')),
        ],
      ),
    );
  }
}

void _noop() {}
