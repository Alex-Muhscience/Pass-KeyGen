import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'advanced_encryption_service.dart';

class BackupMetadata {
  final String id;
  final DateTime timestamp;
  final String deviceId;
  final String version;
  final int accountCount;
  final String checksum;

  const BackupMetadata({
    required this.id,
    required this.timestamp,
    required this.deviceId,
    required this.version,
    required this.accountCount,
    required this.checksum,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'deviceId': deviceId,
    'version': version,
    'accountCount': accountCount,
    'checksum': checksum,
  };

  factory BackupMetadata.fromJson(Map<String, dynamic> json) => BackupMetadata(
    id: json['id'],
    timestamp: DateTime.parse(json['timestamp']),
    deviceId: json['deviceId'],
    version: json['version'],
    accountCount: json['accountCount'],
    checksum: json['checksum'],
  );
}

class SyncConflict {
  final String accountId;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
  final DateTime localModified;
  final DateTime remoteModified;

  const SyncConflict({
    required this.accountId,
    required this.localData,
    required this.remoteData,
    required this.localModified,
    required this.remoteModified,
  });
}

class BackupSyncService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  static const String _deviceIdKey = 'device_id';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _syncEnabledKey = 'sync_enabled';
  static const String _backupKeyKey = 'backup_encryption_key';

  final AdvancedEncryptionService _encryptionService;
  final Uuid _uuid = const Uuid();

  BackupSyncService(this._encryptionService);

  /// Initialize backup service
  Future<void> initialize() async {
    await _ensureDeviceId();
    await _generateBackupKey();
  }

  /// Create encrypted backup of all data
  Future<String> createBackup(List<Map<String, dynamic>> accounts, String masterPassword) async {
    try {
      final deviceId = await _getDeviceId();
      final backupData = {
        'version': '1.0.0',
        'timestamp': DateTime.now().toIso8601String(),
        'deviceId': deviceId,
        'accounts': accounts,
      };

      final jsonData = jsonEncode(backupData);
      final encryptedData = await _encryptionService.encryptData(jsonData, masterPassword);
      
      final metadata = BackupMetadata(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        deviceId: deviceId,
        version: '1.0.0',
        accountCount: accounts.length,
        checksum: _calculateChecksum(encryptedData),
      );

      final backup = {
        'metadata': metadata.toJson(),
        'data': encryptedData,
      };

      return jsonEncode(backup);
    } catch (e) {
      throw Exception('Failed to create backup: $e');
    }
  }

  /// Restore data from encrypted backup
  Future<List<Map<String, dynamic>>> restoreBackup(String backupJson, String masterPassword) async {
    try {
      final backup = jsonDecode(backupJson);
      final encryptedData = backup['data'];
      final metadata = BackupMetadata.fromJson(backup['metadata']);

      // Verify checksum
      if (_calculateChecksum(encryptedData) != metadata.checksum) {
        throw Exception('Backup integrity check failed');
      }

      final decryptedData = await _encryptionService.decryptData(encryptedData, masterPassword);
      final backupData = jsonDecode(decryptedData);

      return List<Map<String, dynamic>>.from(backupData['accounts']);
    } catch (e) {
      throw Exception('Failed to restore backup: $e');
    }
  }

  /// Export backup to file
  Future<File> exportBackupToFile(String backupData, String fileName) async {
    final directory = Directory.systemTemp;
    final file = File('${directory.path}/$fileName.svault');
    await file.writeAsString(backupData);
    return file;
  }

  /// Import backup from file
  Future<String> importBackupFromFile(File file) async {
    if (!await file.exists()) {
      throw Exception('Backup file not found');
    }
    return await file.readAsString();
  }

  /// Sync data with cloud service (placeholder for actual implementation)
  Future<void> syncWithCloud(List<Map<String, dynamic>> localAccounts, String masterPassword) async {
    if (!await isSyncEnabled()) return;
    if (!await _hasInternetConnection()) return;

    try {
      // Get last sync timestamp
      final lastSync = await _getLastSyncTimestamp();
      
      // Get remote changes since last sync
      final remoteChanges = await _fetchRemoteChanges(lastSync);
      
      // Detect conflicts
      final conflicts = _detectConflicts(localAccounts, remoteChanges);
      
      if (conflicts.isNotEmpty) {
        // Handle conflicts (in a real app, this would involve user interaction)
        await _resolveConflicts(conflicts);
      }
      
      // Upload local changes
      await _uploadLocalChanges(localAccounts, lastSync, masterPassword);
      
      // Update last sync timestamp
      await _updateLastSyncTimestamp();
      
    } catch (e) {
      throw Exception('Sync failed: $e');
    }
  }

  /// Enable automatic sync
  Future<void> enableSync() async {
    await _storage.write(key: _syncEnabledKey, value: 'true');
  }

  /// Disable automatic sync
  Future<void> disableSync() async {
    await _storage.write(key: _syncEnabledKey, value: 'false');
  }

  /// Check if sync is enabled
  Future<bool> isSyncEnabled() async {
    final enabled = await _storage.read(key: _syncEnabledKey);
    return enabled == 'true';
  }

  /// Get sync status information
  Future<Map<String, dynamic>> getSyncStatus() async {
    final lastSync = await _getLastSyncTimestamp();
    final isEnabled = await isSyncEnabled();
    final hasConnection = await _hasInternetConnection();
    
    return {
      'enabled': isEnabled,
      'lastSync': lastSync?.toIso8601String(),
      'hasConnection': hasConnection,
      'deviceId': await _getDeviceId(),
    };
  }

  /// Create automatic backup schedule
  Future<void> scheduleAutoBackup() async {
    // This would integrate with platform-specific background task scheduling
    // For now, it's a placeholder for the actual implementation
  }

  /// Validate backup integrity
  Future<bool> validateBackup(String backupJson) async {
    try {
      final backup = jsonDecode(backupJson);
      final encryptedData = backup['data'];
      final metadata = BackupMetadata.fromJson(backup['metadata']);
      
      return _calculateChecksum(encryptedData) == metadata.checksum;
    } catch (e) {
      return false;
    }
  }

  /// Get backup statistics
  Future<Map<String, dynamic>> getBackupStatistics() async {
    // This would return statistics about backups
    return {
      'totalBackups': 0,
      'lastBackup': null,
      'backupSize': 0,
      'syncEnabled': await isSyncEnabled(),
    };
  }

  Future<void> _ensureDeviceId() async {
    String? deviceId = await _storage.read(key: _deviceIdKey);
    if (deviceId == null) {
      deviceId = await _generateDeviceId();
      await _storage.write(key: _deviceIdKey, value: deviceId);
    }
  }

  Future<String> _generateDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceId;
    
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = '${androidInfo.model}-${androidInfo.id}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = '${iosInfo.model}-${iosInfo.identifierForVendor}';
    } else {
      deviceId = _uuid.v4();
    }
    
    return sha256.convert(utf8.encode(deviceId)).toString();
  }

  Future<String> _getDeviceId() async {
    return await _storage.read(key: _deviceIdKey) ?? 'unknown';
  }

  Future<void> _generateBackupKey() async {
    final existingKey = await _storage.read(key: _backupKeyKey);
    if (existingKey == null) {
      final key = _uuid.v4();
      await _storage.write(key: _backupKeyKey, value: key);
    }
  }

  String _calculateChecksum(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }

  Future<DateTime?> _getLastSyncTimestamp() async {
    final timestamp = await _storage.read(key: _lastSyncKey);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  Future<void> _updateLastSyncTimestamp() async {
    await _storage.write(key: _lastSyncKey, value: DateTime.now().toIso8601String());
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Placeholder methods for cloud sync implementation
  Future<List<Map<String, dynamic>>> _fetchRemoteChanges(DateTime? since) async {
    // This would fetch changes from your cloud service
    return [];
  }

  List<SyncConflict> _detectConflicts(List<Map<String, dynamic>> local, List<Map<String, dynamic>> remote) {
    // This would detect conflicts between local and remote data
    return [];
  }

  Future<void> _resolveConflicts(List<SyncConflict> conflicts) async {
    // This would resolve conflicts, possibly with user input
  }

  Future<void> _uploadLocalChanges(List<Map<String, dynamic>> accounts, DateTime? since, String masterPassword) async {
    // This would upload local changes to your cloud service
  }
}
