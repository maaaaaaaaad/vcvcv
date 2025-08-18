import 'package:flutter/material.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

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
            _ProfileHeaderCard(),
            SizedBox(height: 12),
            _SectionHeader(title: '설정', actionText: '계정', onAction: _noop),
            SizedBox(height: 8),
            _ProfileActionList(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatefulWidget {
  const _ProfileHeaderCard();

  @override
  State<_ProfileHeaderCard> createState() => _ProfileHeaderCardState();
}

class _ProfileHeaderCardState extends State<_ProfileHeaderCard> {
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
    final c = Theme.of(context).colorScheme;
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutBack,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c.primary, c.primaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(Icons.person, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '젤로 사용자',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: c.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '반가워요, 오늘도 아름다워져요',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: c.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.tonal(onPressed: _noop, child: const Text('프로필')),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(actionText, style: TextStyle(color: c.primary)),
        ),
      ],
    );
  }
}

class _ProfileActionList extends StatelessWidget {
  const _ProfileActionList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ProfileActionTile(
          icon: Icons.book_online,
          color: Colors.blue,
          title: '예약 내역',
          subtitle: '지난 예약을 확인해요',
        ),
        SizedBox(height: 8),
        _ProfileActionTile(
          icon: Icons.credit_card,
          color: Colors.teal,
          title: '결제 수단',
          subtitle: '카드를 관리해요',
        ),
        SizedBox(height: 8),
        _ProfileActionTile(
          icon: Icons.notifications_none,
          color: Colors.purple,
          title: '알림 설정',
          subtitle: '푸시 알림을 관리해요',
        ),
      ],
    );
  }
}

class _ProfileActionTile extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _ProfileActionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_ProfileActionTile> createState() => _ProfileActionTileState();
}

class _ProfileActionTileState extends State<_ProfileActionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: _noop,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: widget.color.withValues(alpha: 0.12),
              child: Icon(widget.icon, color: widget.color),
            ),
            title: Text(
              widget.title,
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(widget.subtitle),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}

void _noop() {}
