// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'SecureVault';

  @override
  String get login => 'Connexion';

  @override
  String get loginTitle => 'Bon Retour';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour accéder à votre coffre sécurisé';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get email => 'Email';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get signUpTitle => 'Créer un Compte';

  @override
  String get signUpSubtitle =>
      'Rejoignez SecureVault pour protéger vos mots de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get biometricLogin => 'Utiliser la Biométrie';

  @override
  String get home => 'Accueil';

  @override
  String get accounts => 'Comptes';

  @override
  String get addAccount => 'Ajouter un Compte';

  @override
  String get accountName => 'Nom du Compte';

  @override
  String get website => 'Site Web';

  @override
  String get notes => 'Notes';

  @override
  String get category => 'Catégorie';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get copy => 'Copier';

  @override
  String get generate => 'Générer';

  @override
  String get settings => 'Paramètres';

  @override
  String get security => 'Sécurité';

  @override
  String get securityDashboard => 'Tableau de Bord Sécurité';

  @override
  String get securityDashboardSubtitle =>
      'Voir l\'audit de sécurité et les recommandations';

  @override
  String get securityScore => 'Score de Sécurité';

  @override
  String get excellentSecurity => 'Sécurité excellente';

  @override
  String get goodSecurity => 'Bonne sécurité';

  @override
  String get fairSecurity => 'Sécurité correcte';

  @override
  String get poorSecurity => 'Sécurité faible';

  @override
  String get criticalSecurityIssues => 'Problèmes de sécurité critiques';

  @override
  String get totalAccounts => 'Total des Comptes';

  @override
  String get issuesFound => 'Problèmes Trouvés';

  @override
  String get strongPasswords => 'Mots de Passe Forts';

  @override
  String get riskBreakdown => 'Répartition des Risques';

  @override
  String get critical => 'Critique';

  @override
  String get high => 'Élevé';

  @override
  String get medium => 'Moyen';

  @override
  String get low => 'Faible';

  @override
  String get securityIssues => 'Problèmes de Sécurité';

  @override
  String get allClear => 'Tout va bien !';

  @override
  String get noSecurityIssues => 'Aucun problème de sécurité détecté';

  @override
  String viewAllIssues(int count) {
    return 'Voir Tous les $count Problèmes';
  }

  @override
  String get passwordGenerator => 'Générateur de Mots de Passe';

  @override
  String get passwordGeneratorSubtitle => 'Générer des mots de passe sécurisés';

  @override
  String get generatedPassword => 'Mot de Passe Généré';

  @override
  String get generatedPassphrase => 'Phrase de Passe Générée';

  @override
  String get passphrase => 'Phrase de Passe';

  @override
  String get passwordAnalysis => 'Analyse du Mot de Passe';

  @override
  String get strength => 'Force';

  @override
  String get score => 'Score';

  @override
  String get entropy => 'Entropie';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get alternativeOptions => 'Options Alternatives';

  @override
  String get passwordSettings => 'Paramètres du Mot de Passe';

  @override
  String get passphraseSettings => 'Paramètres de la Phrase de Passe';

  @override
  String length(int length) {
    return 'Longueur : $length';
  }

  @override
  String wordCount(int count) {
    return 'Nombre de Mots : $count';
  }

  @override
  String get separator => 'Séparateur';

  @override
  String get space => 'Espace';

  @override
  String get includeUppercase => 'Majuscules (A-Z)';

  @override
  String get includeLowercase => 'Minuscules (a-z)';

  @override
  String get includeNumbers => 'Chiffres (0-9)';

  @override
  String get includeSymbols => 'Symboles (!@#\$)';

  @override
  String get includeNumbersInPassphrase => 'Inclure les Chiffres';

  @override
  String get capitalizeWords => 'Mettre en Majuscule';

  @override
  String get advancedOptions => 'Options Avancées';

  @override
  String get excludeSimilar => 'Exclure Similaires (il1Lo0O)';

  @override
  String get excludeAmbiguous => 'Exclure Caractères Ambigus';

  @override
  String get twoFactorAuthentication => 'Authentification à Deux Facteurs';

  @override
  String get twoFactorAuthSubtitle =>
      'Ajouter une couche de sécurité supplémentaire';

  @override
  String get secureYourAccount => 'Sécuriser Votre Compte';

  @override
  String get twoFactorDescription =>
      'L\'authentification à deux facteurs ajoute une couche de sécurité supplémentaire à votre compte en nécessitant un code de vérification de votre téléphone.';

  @override
  String get enhancedSecurity => 'Sécurité Renforcée';

  @override
  String get enhancedSecurityDesc => 'Protéger contre l\'accès non autorisé';

  @override
  String get mobileAppSupport => 'Support d\'Application Mobile';

  @override
  String get mobileAppSupportDesc =>
      'Fonctionne avec Google Authenticator, Authy, et plus';

  @override
  String get backupCodes => 'Codes de Sauvegarde';

  @override
  String get backupCodesDesc =>
      'Codes de récupération en cas de perte de votre appareil';

  @override
  String get enable2FA => 'Activer 2FA';

  @override
  String get scanQRCode => 'Scanner le Code QR';

  @override
  String get scanQRCodeDesc =>
      'Utilisez votre application d\'authentification pour scanner ce code QR';

  @override
  String get manualEntryCode => 'Code d\'Entrée Manuelle';

  @override
  String get verificationCode => 'Code de Vérification';

  @override
  String get enterSixDigitCode => 'Entrez le code à 6 chiffres';

  @override
  String get verifyAndEnable => 'Vérifier et Activer';

  @override
  String get twoFAEnabledSuccessfully => '2FA Activé avec Succès !';

  @override
  String get saveBackupCodes =>
      'Sauvegardez ces codes de sauvegarde dans un endroit sûr. Vous pouvez les utiliser pour accéder à votre compte si vous perdez votre appareil d\'authentification.';

  @override
  String get done => 'Terminé';

  @override
  String get twoFAEnabled => '2FA Activé';

  @override
  String get accountProtected =>
      'Votre compte est protégé par l\'authentification à deux facteurs';

  @override
  String get regenerate => 'Régénérer';

  @override
  String backupCodesRemaining(int count) {
    return 'Il vous reste $count codes de sauvegarde';
  }

  @override
  String get viewCodes => 'Voir les Codes';

  @override
  String get regenerateBackupCodes => 'Régénérer les Codes de Sauvegarde';

  @override
  String get generateNewBackupCodes =>
      'Générer de nouveaux codes de sauvegarde';

  @override
  String get reset2FA => 'Réinitialiser 2FA';

  @override
  String get generateNewSecretKey => 'Générer une nouvelle clé secrète';

  @override
  String get disable2FA => 'Désactiver 2FA';

  @override
  String get turnOff2FA => 'Désactiver l\'authentification à deux facteurs';

  @override
  String get copyAllCodes => 'Copier Tous les Codes';

  @override
  String get importExport => 'Importer et Exporter';

  @override
  String get import => 'Importer';

  @override
  String get export => 'Exporter';

  @override
  String get importPasswords => 'Importer les Mots de Passe';

  @override
  String get importPasswordsDesc =>
      'Importez vos mots de passe depuis d\'autres gestionnaires';

  @override
  String get exportPasswords => 'Exporter les Mots de Passe';

  @override
  String get exportPasswordsDesc =>
      'Créer une sauvegarde ou migrer vers un autre gestionnaire';

  @override
  String get exportDataWarning =>
      'Assurez-vous d\'exporter vos données de l\'autre gestionnaire de mots de passe d\'abord';

  @override
  String get sensitiveDataWarning =>
      'Les fichiers exportés contiennent des données sensibles. Stockez-les en sécurité et supprimez-les après utilisation.';

  @override
  String get chooseImportSource => 'Choisir la Source d\'Importation';

  @override
  String get chooseExportFormat => 'Choisir le Format d\'Exportation';

  @override
  String get chrome => 'Chrome';

  @override
  String get chromeImportDesc =>
      'Importer depuis l\'export de mots de passe Chrome (CSV)';

  @override
  String get firefox => 'Firefox';

  @override
  String get firefoxImportDesc =>
      'Importer depuis l\'export de mots de passe Firefox (CSV)';

  @override
  String get safari => 'Safari';

  @override
  String get safariImportDesc =>
      'Importer depuis l\'export de mots de passe Safari (CSV)';

  @override
  String get bitwarden => 'Bitwarden';

  @override
  String get bitwardenImportDesc =>
      'Importer depuis l\'export de coffre Bitwarden (JSON)';

  @override
  String get lastpass => 'LastPass';

  @override
  String get lastpassImportDesc =>
      'Importer depuis l\'export de coffre LastPass (CSV)';

  @override
  String get onepassword => '1Password';

  @override
  String get onepasswordImportDesc =>
      'Importer depuis l\'export 1Password (CSV)';

  @override
  String get genericCSV => 'CSV Générique';

  @override
  String get genericCSVDesc => 'Importer depuis n\'importe quel fichier CSV';

  @override
  String get jsonFile => 'Fichier JSON';

  @override
  String get jsonFileDesc => 'Importer depuis un fichier JSON';

  @override
  String get encryptedExport => 'Export Chiffré';

  @override
  String get encryptedExportDesc =>
      'Export sécurisé avec protection par mot de passe (Recommandé)';

  @override
  String get csvExport => 'Export CSV';

  @override
  String get csvExportDesc =>
      'Compatible avec la plupart des gestionnaires de mots de passe';

  @override
  String get jsonExport => 'Export JSON';

  @override
  String get jsonExportDesc => 'Format de données structuré avec métadonnées';

  @override
  String get secure => 'SÉCURISÉ';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get cloudSync => 'Synchronisation Cloud';

  @override
  String get cloudSyncDesc => 'Synchroniser les données entre appareils';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get privacyPolicyDesc => 'Voir notre politique de confidentialité';

  @override
  String get dataUsage => 'Utilisation des Données';

  @override
  String get dataUsageDesc => 'Voir comment vos données sont utilisées';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get system => 'Système';

  @override
  String get compactView => 'Vue Compacte';

  @override
  String get compactViewDesc => 'Afficher plus d\'éléments à l\'écran';

  @override
  String get showPasswords => 'Afficher les Mots de Passe';

  @override
  String get showPasswordsDesc => 'Afficher les mots de passe par défaut';

  @override
  String get dataManagement => 'Gestion des Données';

  @override
  String get importExportDesc =>
      'Importer depuis d\'autres gestionnaires de mots de passe';

  @override
  String get backupRestore => 'Sauvegarde et Restauration';

  @override
  String get backupRestoreDesc => 'Créer et restaurer des sauvegardes';

  @override
  String get clearCache => 'Vider le Cache';

  @override
  String get clearCacheDesc => 'Libérer de l\'espace de stockage';

  @override
  String get resetApp => 'Réinitialiser l\'App';

  @override
  String get resetAppDesc => 'Supprimer toutes les données et réinitialiser';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get helpSupport => 'Aide et Support';

  @override
  String get helpSupportDesc => 'Obtenir de l\'aide et contacter le support';

  @override
  String get rateApp => 'Noter l\'App';

  @override
  String get rateAppDesc => 'Noter SecureVault sur l\'app store';

  @override
  String get termsOfService => 'Conditions d\'Utilisation';

  @override
  String get termsOfServiceDesc => 'Voir les termes et conditions';

  @override
  String get biometricAuthentication => 'Authentification Biométrique';

  @override
  String get biometricAuthDesc =>
      'Utiliser l\'empreinte digitale ou le déverrouillage facial';

  @override
  String get autoLock => 'Verrouillage Automatique';

  @override
  String get autoLockDesc => 'Verrouiller l\'app quand inactive';

  @override
  String get autoLockTimer => 'Minuteur de Verrouillage Auto';

  @override
  String lockAfterMinutes(int minutes) {
    return 'Verrouiller après $minutes minutes';
  }

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Français';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Português';

  @override
  String get russian => 'Русский';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get arabic => 'العربية';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Avertissement';

  @override
  String get info => 'Info';

  @override
  String get confirm => 'Confirmer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Fermer';

  @override
  String get loading => 'Chargement...';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get search => 'Rechercher';

  @override
  String get searchAccounts => 'Rechercher des comptes...';

  @override
  String get noAccountsFound => 'Aucun compte trouvé';

  @override
  String get addYourFirstAccount =>
      'Ajoutez votre premier compte pour commencer';

  @override
  String get copied => 'Copié';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get developer => 'Développeur';

  @override
  String get familySharing => 'Partage Familial';

  @override
  String get overview => 'Aperçu';

  @override
  String get members => 'Membres';

  @override
  String get shared => 'Partagé';

  @override
  String get sharePassword => 'Partager le Mot de Passe';

  @override
  String get createYourFamilyVault => 'Créer Votre Coffre Familial';

  @override
  String get sharePasswordsSecurely =>
      'Partagez vos mots de passe en toute sécurité avec les membres de votre famille. Créez un coffre familial pour commencer.';

  @override
  String get createFamilyVault => 'Créer un Coffre Familial';

  @override
  String get recentActivity => 'Activité Récente';

  @override
  String get sharedItems => 'Éléments Partagés';

  @override
  String get yourName => 'Votre Nom';

  @override
  String get enterYourFullName => 'Entrez votre nom complet';

  @override
  String get yourEmail => 'Votre Email';

  @override
  String get enterYourEmailAddress => 'Entrez votre adresse email';

  @override
  String get create => 'Créer';

  @override
  String get familyVaultCreatedSuccessfully =>
      'Coffre familial créé avec succès !';

  @override
  String failedToCreateFamilyVault(String error) {
    return 'Échec de création du coffre familial : $error';
  }

  @override
  String get inviteFamilyMember => 'Inviter un Membre de la Famille';

  @override
  String get generateInviteCode =>
      'Générez un code d\'invitation à partager avec votre membre de famille.';

  @override
  String get generateCode => 'Générer le Code';

  @override
  String get inviteCodeGenerated => 'Code d\'Invitation Généré';

  @override
  String get shareThisCode => 'Partagez ce code avec votre membre de famille :';

  @override
  String get codeExpiresInDays => 'Ce code expire dans 7 jours.';

  @override
  String get copyCode => 'Copier le Code';

  @override
  String failedToGenerateInviteCode(String error) {
    return 'Échec de génération du code d\'invitation : $error';
  }

  @override
  String get passwordSharingDialog =>
      'La boîte de dialogue de partage de mot de passe s\'ouvrirait ici';

  @override
  String get editRole => 'Modifier le Rôle';

  @override
  String get remove => 'Supprimer';

  @override
  String accountId(String id) {
    return 'ID de Compte : $id';
  }

  @override
  String sharedWithMembers(int count) {
    return 'Partagé avec $count membre(s)';
  }

  @override
  String sharedOn(String date) {
    return 'Partagé le $date';
  }

  @override
  String passwordSharedWithMembers(int count) {
    return 'Mot de passe partagé avec $count membre(s)';
  }

  @override
  String failedToLoadFamilyData(String error) {
    return 'Échec du chargement des données familiales : $error';
  }
}
