import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceCapabilityProvider = Provider<DeviceCapability>((ref) {
  return DeviceCapability();
});

/// Result of a capability check.
sealed class DeviceSupport {
  const DeviceSupport();

  bool get isSupported => this is DeviceSupported;
}

class DeviceSupported extends DeviceSupport {
  const DeviceSupported();
}

class DeviceUnsupported extends DeviceSupport {
  const DeviceUnsupported(this.reason);

  final String reason;
}

/// Whether this device can realistically run the on-device model, checked
/// *before* a 2.6 GB download rather than after a crash (PRD §20, §22).
///
/// This exists because a Galaxy A06 (measured 3.55 GB RAM) downloads the model,
/// loads it, and is then killed by Android's low-memory killer the moment the
/// compositor needs frame buffers. Spending someone's 2.6 GB of bandwidth to
/// arrive at an OOM kill is the worst possible outcome.
///
/// Reads `/proc/meminfo` directly rather than using `device_info_plus`: that
/// package drags in `win32`/`win32_registry` for its Windows implementation,
/// which broke the build toolchain on this project, and it is a large
/// dependency for a single integer. Android is also where the constraint
/// actually bites — iOS devices new enough to run this app have adequate RAM,
/// and there the blocker is entitlements, not memory.
class DeviceCapability {
  /// Google's guidance for Gemma 4 E2B is 6 GB+ of device RAM, and to prefer
  /// 1–2B models below that. The threshold allows slack because reported
  /// totals fall short of the nominal spec once kernel and GPU carve-outs are
  /// taken — a nominal "6 GB" phone typically reports ~5.6 GB.
  static const int minimumRamMb = 5000;

  Future<DeviceSupport> check() async {
    // Only Android exposes /proc. Everywhere else, fail open.
    if (!Platform.isAndroid) return const DeviceSupported();

    final ramMb = await _totalRamMb();
    // An unreadable figure is treated as supported: a wrong lock-out is worse
    // than letting the load attempt proceed and fail honestly.
    if (ramMb == null || ramMb >= minimumRamMb) {
      return const DeviceSupported();
    }

    final gb = (ramMb / 1024).toStringAsFixed(1);
    return DeviceUnsupported(
      'Offline translation needs about 6 GB of memory, and this device has '
      '$gb GB. Running the model here would crash the app.',
    );
  }

  /// Total physical RAM in megabytes, or null if it can't be determined.
  ///
  /// `/proc/meminfo`'s first line is `MemTotal:  7394168 kB`.
  Future<int?> _totalRamMb() async {
    try {
      final meminfo = File('/proc/meminfo');
      if (!await meminfo.exists()) return null;

      final lines = await meminfo.readAsLines();
      final total = lines.firstWhere(
        (line) => line.startsWith('MemTotal:'),
        orElse: () => '',
      );

      final kb = int.tryParse(RegExp(r'(\d+)').firstMatch(total)?.group(1) ?? '');
      return kb == null ? null : kb ~/ 1024;
    } catch (_) {
      return null;
    }
  }
}
