import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../domain/entities/symptom.dart';
import '../theme/app_theme.dart';

class AnimatedSymptomCard extends StatefulWidget {
  final Symptom symptom;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isSelected;

  const AnimatedSymptomCard({
    super.key,
    required this.symptom,
    required this.onEdit,
    required this.onDelete,
    this.isSelected = false,
  });

  @override
  State<AnimatedSymptomCard> createState() => _AnimatedSymptomCardState();
}

class _AnimatedSymptomCardState extends State<AnimatedSymptomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = AppTheme.getSeverityColor(widget.symptom.severity);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Slidable(
              key: ValueKey(widget.symptom.id),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => widget.onEdit(),
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                    borderRadius: BorderRadius.circular(12),
                  ),
                  SlidableAction(
                    onPressed: (_) => widget.onDelete(),
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? severityColor.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isSelected
                        ? severityColor
                        : Colors.grey.shade200,
                    width: widget.isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: severityColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildSeverityIndicator(severityColor),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.symptom.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  TimeOfDay.fromDateTime(widget.symptom.occurredAt)
                                      .format(context),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                if (widget.symptom.notes != null &&
                                    widget.symptom.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.symptom.notes!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeverityIndicator(Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getSeverityIcon(widget.symptom.severity),
        color: color,
        size: 24,
      ),
    );
  }

  IconData _getSeverityIcon(SeverityLevel severity) {
    switch (severity) {
      case SeverityLevel.mild:
        return Icons.sentiment_satisfied;
      case SeverityLevel.moderate:
        return Icons.sentiment_neutral;
      case SeverityLevel.severe:
        return Icons.sentiment_dissatisfied;
      case SeverityLevel.critical:
        return Icons.warning_rounded;
    }
  }
}