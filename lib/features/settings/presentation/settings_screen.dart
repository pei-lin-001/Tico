import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _workDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 15;
  bool _autoStartBreaks = false;
  bool _autoStartPomodoros = false;
  int _longBreakInterval = 4;

  void _updateWorkDuration(int v) => setState(() => _workDuration = v.clamp(1, 120));
  void _updateShortBreakDuration(int v) => setState(() => _shortBreakDuration = v.clamp(1, 60));
  void _updateLongBreakDuration(int v) => setState(() => _longBreakDuration = v.clamp(1, 60));
  void _updateLongBreakInterval(int v) => setState(() => _longBreakInterval = v.clamp(1, 10));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
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
              Expanded(
                child: _buildDurationInput('专注', _workDuration, _updateWorkDuration),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDurationInput('短休', _shortBreakDuration, _updateShortBreakDuration),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDurationInput('长休', _longBreakDuration, _updateLongBreakDuration),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(Icons.flash_on, '自动化'),
          const SizedBox(height: 12),
          _buildToggleRow('自动开始休息', _autoStartBreaks, (v) => setState(() => _autoStartBreaks = v)),
          const SizedBox(height: 8),
          _buildToggleRow('自动开始番茄', _autoStartPomodoros, (v) => setState(() => _autoStartPomodoros = v)),
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
                const Text(
                  '几个番茄休息一次？',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
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
                    onChanged: (v) => _updateLongBreakInterval(int.tryParse(v) ?? 4),
                    controller: TextEditingController(text: '$_longBreakInterval'),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Text(
                  '专注成就效率',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationInput(String label, int value, void Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.primary.withValues(alpha: 0.4),
          ),
        ),
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
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
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
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
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
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}