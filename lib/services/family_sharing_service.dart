import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';

class FamilyMember {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin', 'member', 'child'
  final DateTime joinedAt;
  final bool isActive;
  final List<String> permissions;

  FamilyMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.joinedAt,
    required this.isActive,
    required this.permissions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'joinedAt': joinedAt.toIso8601String(),
    'isActive': isActive,
    'permissions': permissions,
  };

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
    joinedAt: DateTime.parse(json['joinedAt']),
    isActive: json['isActive'],
    permissions: List<String>.from(json['permissions']),
  );
}

class SharedItem {
  final String id;
  final String accountId;
  final String sharedBy;
  final List<String> sharedWith;
  final DateTime sharedAt;
  final String permissions; // 'view', 'edit', 'admin'
  final bool isActive;

  SharedItem({
    required this.id,
    required this.accountId,
    required this.sharedBy,
    required this.sharedWith,
    required this.sharedAt,
    required this.permissions,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'accountId': accountId,
    'sharedBy': sharedBy,
    'sharedWith': sharedWith,
    'sharedAt': sharedAt.toIso8601String(),
    'permissions': permissions,
    'isActive': isActive,
  };

  factory SharedItem.fromJson(Map<String, dynamic> json) => SharedItem(
    id: json['id'],
    accountId: json['accountId'],
    sharedBy: json['sharedBy'],
    sharedWith: List<String>.from(json['sharedWith']),
    sharedAt: DateTime.parse(json['sharedAt']),
    permissions: json['permissions'],
    isActive: json['isActive'],
  );
}

class FamilySharingService {
  static const _storage = FlutterSecureStorage();
  static const String _familyMembersKey = 'family_members';
  static const String _sharedItemsKey = 'shared_items';
  static const String _familyIdKey = 'family_id';
  static const String _inviteCodesKey = 'invite_codes';

  // Family Management
  static Future<String> createFamily(String adminName, String adminEmail) async {
    final familyId = _generateFamilyId();
    final admin = FamilyMember(
      id: _generateMemberId(),
      name: adminName,
      email: adminEmail,
      role: 'admin',
      joinedAt: DateTime.now(),
      isActive: true,
      permissions: ['create', 'read', 'update', 'delete', 'share', 'invite'],
    );

    await _storage.write(key: _familyIdKey, value: familyId);
    await _saveFamilyMembers([admin]);
    
    return familyId;
  }

  static Future<String?> getFamilyId() async {
    return await _storage.read(key: _familyIdKey);
  }

  static Future<List<FamilyMember>> getFamilyMembers() async {
    try {
      final membersJson = await _storage.read(key: _familyMembersKey);
      if (membersJson != null) {
        final List<dynamic> membersList = jsonDecode(membersJson);
        return membersList.map((json) => FamilyMember.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading family members: $e');
    }
    return [];
  }

  static Future<void> _saveFamilyMembers(List<FamilyMember> members) async {
    final membersJson = jsonEncode(members.map((m) => m.toJson()).toList());
    await _storage.write(key: _familyMembersKey, value: membersJson);
  }

  // Invitation System
  static Future<String> generateInviteCode(String inviterName, String role) async {
    final inviteCode = _generateInviteCode();
    final invitation = {
      'code': inviteCode,
      'inviterName': inviterName,
      'role': role,
      'createdAt': DateTime.now().toIso8601String(),
      'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      'isUsed': false,
    };

    final existingCodes = await _getInviteCodes();
    existingCodes[inviteCode] = invitation;
    await _saveInviteCodes(existingCodes);

    return inviteCode;
  }

  static Future<bool> joinFamilyWithCode(String inviteCode, String memberName, String memberEmail) async {
    final inviteCodes = await _getInviteCodes();
    final invitation = inviteCodes[inviteCode];

    if (invitation == null || invitation['isUsed'] == true) {
      return false;
    }

    final expiresAt = DateTime.parse(invitation['expiresAt']);
    if (DateTime.now().isAfter(expiresAt)) {
      return false;
    }

    // Add new member
    final newMember = FamilyMember(
      id: _generateMemberId(),
      name: memberName,
      email: memberEmail,
      role: invitation['role'],
      joinedAt: DateTime.now(),
      isActive: true,
      permissions: _getDefaultPermissions(invitation['role']),
    );

    final members = await getFamilyMembers();
    members.add(newMember);
    await _saveFamilyMembers(members);

    // Mark invitation as used
    invitation['isUsed'] = true;
    inviteCodes[inviteCode] = invitation;
    await _saveInviteCodes(inviteCodes);

    return true;
  }

  static Future<Map<String, dynamic>> _getInviteCodes() async {
    try {
      final codesJson = await _storage.read(key: _inviteCodesKey);
      if (codesJson != null) {
        return Map<String, dynamic>.from(jsonDecode(codesJson));
      }
    } catch (e) {
      debugPrint('Error loading invite codes: $e');
    }
    return {};
  }

  static Future<void> _saveInviteCodes(Map<String, dynamic> codes) async {
    final codesJson = jsonEncode(codes);
    await _storage.write(key: _inviteCodesKey, value: codesJson);
  }

  // Password Sharing
  static Future<String> shareAccount(String accountId, List<String> memberIds, String permissions) async {
    final shareId = _generateShareId();
    final currentUser = await _getCurrentUserId();
    
    final sharedItem = SharedItem(
      id: shareId,
      accountId: accountId,
      sharedBy: currentUser,
      sharedWith: memberIds,
      sharedAt: DateTime.now(),
      permissions: permissions,
      isActive: true,
    );

    final sharedItems = await getSharedItems();
    sharedItems.add(sharedItem);
    await _saveSharedItems(sharedItems);

    return shareId;
  }

  static Future<List<SharedItem>> getSharedItems() async {
    try {
      final itemsJson = await _storage.read(key: _sharedItemsKey);
      if (itemsJson != null) {
        final List<dynamic> itemsList = jsonDecode(itemsJson);
        return itemsList.map((json) => SharedItem.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading shared items: $e');
    }
    return [];
  }

  static Future<void> _saveSharedItems(List<SharedItem> items) async {
    final itemsJson = jsonEncode(items.map((i) => i.toJson()).toList());
    await _storage.write(key: _sharedItemsKey, value: itemsJson);
  }

  static Future<List<SharedItem>> getItemsSharedWithMe() async {
    final currentUserId = await _getCurrentUserId();
    final allSharedItems = await getSharedItems();
    
    return allSharedItems.where((item) => 
      item.sharedWith.contains(currentUserId) && item.isActive
    ).toList();
  }

  static Future<List<SharedItem>> getItemsSharedByMe() async {
    final currentUserId = await _getCurrentUserId();
    final allSharedItems = await getSharedItems();
    
    return allSharedItems.where((item) => 
      item.sharedBy == currentUserId && item.isActive
    ).toList();
  }

  static Future<void> revokeShare(String shareId) async {
    final sharedItems = await getSharedItems();
    final index = sharedItems.indexWhere((item) => item.id == shareId);
    
    if (index != -1) {
      sharedItems[index] = SharedItem(
        id: sharedItems[index].id,
        accountId: sharedItems[index].accountId,
        sharedBy: sharedItems[index].sharedBy,
        sharedWith: sharedItems[index].sharedWith,
        sharedAt: sharedItems[index].sharedAt,
        permissions: sharedItems[index].permissions,
        isActive: false,
      );
      await _saveSharedItems(sharedItems);
    }
  }

  // Member Management
  static Future<void> removeFamilyMember(String memberId) async {
    final members = await getFamilyMembers();
    final updatedMembers = members.where((m) => m.id != memberId).toList();
    await _saveFamilyMembers(updatedMembers);

    // Revoke all shares involving this member
    final sharedItems = await getSharedItems();
    final updatedShares = sharedItems.map((item) {
      if (item.sharedBy == memberId || item.sharedWith.contains(memberId)) {
        return SharedItem(
          id: item.id,
          accountId: item.accountId,
          sharedBy: item.sharedBy,
          sharedWith: item.sharedWith.where((id) => id != memberId).toList(),
          sharedAt: item.sharedAt,
          permissions: item.permissions,
          isActive: item.sharedBy != memberId,
        );
      }
      return item;
    }).toList();
    await _saveSharedItems(updatedShares);
  }

  static Future<void> updateMemberRole(String memberId, String newRole) async {
    final members = await getFamilyMembers();
    final memberIndex = members.indexWhere((m) => m.id == memberId);
    
    if (memberIndex != -1) {
      final updatedMember = FamilyMember(
        id: members[memberIndex].id,
        name: members[memberIndex].name,
        email: members[memberIndex].email,
        role: newRole,
        joinedAt: members[memberIndex].joinedAt,
        isActive: members[memberIndex].isActive,
        permissions: _getDefaultPermissions(newRole),
      );
      
      members[memberIndex] = updatedMember;
      await _saveFamilyMembers(members);
    }
  }

  // Helper Methods
  static String _generateFamilyId() {
    return 'fam_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
  }

  static String _generateMemberId() {
    return 'mem_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
  }

  static String _generateShareId() {
    return 'shr_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
  }

  static String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  static Future<String> _getCurrentUserId() async {
    // In a real app, this would come from authentication
    return await _storage.read(key: 'current_user_id') ?? 'user_${Random().nextInt(9999)}';
  }

  static List<String> _getDefaultPermissions(String role) {
    switch (role) {
      case 'admin':
        return ['create', 'read', 'update', 'delete', 'share', 'invite'];
      case 'member':
        return ['create', 'read', 'update', 'share'];
      case 'child':
        return ['read'];
      default:
        return ['read'];
    }
  }

  // Family Statistics
  static Future<Map<String, int>> getFamilyStats() async {
    final members = await getFamilyMembers();
    final sharedItems = await getSharedItems();
    final activeShares = sharedItems.where((item) => item.isActive).length;

    return {
      'totalMembers': members.length,
      'activeMembers': members.where((m) => m.isActive).length,
      'totalShares': activeShares,
      'adminCount': members.where((m) => m.role == 'admin').length,
    };
  }
}
