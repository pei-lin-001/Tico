import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/timer_settings.dart';
import '../../../shared/widgets/glass_container.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(timerSettingsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        borderRadius: 32,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '配置设置',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
                fontFamily: 'Cormorant Garamond',
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(Icons.access_time, '计时时长'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildDurationInput('专注', settings.workDuration, (v) => _update(settings: settings.copyWith(workDuration: v)))),
                const SizedBox(width: 12),
                Expanded(child: _buildDurationInput('短休', settings.shortBreakDuration, (v) => _update(settings: settings.copyWith(shortBreakDuration: v)))),
                const SizedBox(width: 12),
                Expanded(child: _buildDurationInput('长休', settings.longBreakDuration, (v) => _update(settings: settings.copyWith(longBreakDuration: v)))),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(Icons.flash_on, '自动化'),
            const SizedBox(height: 12),
            _buildToggleRow('自动开始休息', settings.autoStartBreak, (v) => _update(settings: settings.copyWith(autoStartBreak: v))),
            const SizedBox(height: 8),
            _buildToggleRow('自动开始番茄', settings.autoStartPomodoro, (v) => _update(settings: settings.copyWith(autoStartPomodoro: v))),
            const SizedBox(height: 24),
            _buildSectionTitle(Icons.repeat, '长休间隔'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white40,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('几个番茄休息一次？', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
                  Container(
                    width: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white40,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary10),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (v) {
                        final val = int.tryParse(v) ?? 4;
                        _update(settings: settings.copyWith(longBreakInterval: val.clamp(1, 10)));
                      },
                      controller: TextEditingController(text: '${settings.longBreakInterval}'),
                      decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text('专注成就效率', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.primary.withValues(alpha: 0.4))),
                  const SizedBox(height: 12),
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _update({required TimerSettings settings}) {
    ref.read(timerSettingsProvider.notifier).update(settings);
  }

  Widget _buildSectionTitle(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.primary.withValues(alpha: 0.6))),
      ],
    );
  }

  Widget _buildDurationInput(String label, int value, void Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1, color: AppColors.primary.withValues(alpha: 0.4))),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white40,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary10),
          ),
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            onChanged: (v) => onChanged(int.tryParse(v) ?? value),
            controller: TextEditingController(text: '$value'),
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow(String label, bool value, void Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white40,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                color: value ? AppColors.primary : AppColors.primary20,
                borderRadius: BorderRadius.circular(14),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(width: 24, height: 24, decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}