// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'SecureVault';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get loginTitle => 'Bienvenido de Nuevo';

  @override
  String get loginSubtitle => 'Inicia sesión para acceder a tu bóveda segura';

  @override
  String get username => 'Nombre de Usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get signUp => 'Registrarse';

  @override
  String get signUpTitle => 'Crear Cuenta';

  @override
  String get signUpSubtitle =>
      'Únete a SecureVault para proteger tus contraseñas';

  @override
  String get forgotPassword => '¿Olvidaste tu Contraseña?';

  @override
  String get biometricLogin => 'Usar Biométrico';

  @override
  String get home => 'Inicio';

  @override
  String get accounts => 'Cuentas';

  @override
  String get addAccount => 'Agregar Cuenta';

  @override
  String get accountName => 'Nombre de la Cuenta';

  @override
  String get website => 'Sitio Web';

  @override
  String get notes => 'Notas';

  @override
  String get category => 'Categoría';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get copy => 'Copiar';

  @override
  String get generate => 'Generar';

  @override
  String get settings => 'Configuración';

  @override
  String get security => 'Seguridad';

  @override
  String get securityDashboard => 'Panel de Seguridad';

  @override
  String get securityDashboardSubtitle =>
      'Ver auditoría de seguridad y recomendaciones';

  @override
  String get securityScore => 'Puntuación de Seguridad';

  @override
  String get excellentSecurity => 'Seguridad excelente';

  @override
  String get goodSecurity => 'Buena seguridad';

  @override
  String get fairSecurity => 'Seguridad regular';

  @override
  String get poorSecurity => 'Seguridad deficiente';

  @override
  String get criticalSecurityIssues => 'Problemas críticos de seguridad';

  @override
  String get totalAccounts => 'Total de Cuentas';

  @override
  String get issuesFound => 'Problemas Encontrados';

  @override
  String get strongPasswords => 'Contraseñas Fuertes';

  @override
  String get riskBreakdown => 'Desglose de Riesgos';

  @override
  String get critical => 'Crítico';

  @override
  String get high => 'Alto';

  @override
  String get medium => 'Medio';

  @override
  String get low => 'Bajo';

  @override
  String get securityIssues => 'Problemas de Seguridad';

  @override
  String get allClear => '¡Todo Despejado!';

  @override
  String get noSecurityIssues => 'No se detectaron problemas de seguridad';

  @override
  String viewAllIssues(int count) {
    return 'Ver Todos los $count Problemas';
  }

  @override
  String get passwordGenerator => 'Generador de Contraseñas';

  @override
  String get passwordGeneratorSubtitle => 'Generar contraseñas seguras';

  @override
  String get generatedPassword => 'Contraseña Generada';

  @override
  String get generatedPassphrase => 'Frase de Contraseña Generada';

  @override
  String get passphrase => 'Frase de Contraseña';

  @override
  String get passwordAnalysis => 'Análisis de Contraseña';

  @override
  String get strength => 'Fortaleza';

  @override
  String get score => 'Puntuación';

  @override
  String get entropy => 'Entropía';

  @override
  String get suggestions => 'Sugerencias';

  @override
  String get alternativeOptions => 'Opciones Alternativas';

  @override
  String get passwordSettings => 'Configuración de Contraseña';

  @override
  String get passphraseSettings => 'Configuración de Frase de Contraseña';

  @override
  String length(int length) {
    return 'Longitud: $length';
  }

  @override
  String wordCount(int count) {
    return 'Cantidad de Palabras: $count';
  }

  @override
  String get separator => 'Separador';

  @override
  String get space => 'Espacio';

  @override
  String get includeUppercase => 'Mayúsculas (A-Z)';

  @override
  String get includeLowercase => 'Minúsculas (a-z)';

  @override
  String get includeNumbers => 'Números (0-9)';

  @override
  String get includeSymbols => 'Símbolos (!@#\$)';

  @override
  String get includeNumbersInPassphrase => 'Incluir Números';

  @override
  String get capitalizeWords => 'Capitalizar Palabras';

  @override
  String get advancedOptions => 'Opciones Avanzadas';

  @override
  String get excludeSimilar => 'Excluir Similares (il1Lo0O)';

  @override
  String get excludeAmbiguous => 'Excluir Caracteres Ambiguos';

  @override
  String get twoFactorAuthentication => 'Autenticación de Dos Factores';

  @override
  String get twoFactorAuthSubtitle => 'Agregar una capa extra de seguridad';

  @override
  String get secureYourAccount => 'Asegurar Tu Cuenta';

  @override
  String get twoFactorDescription =>
      'La autenticación de dos factores agrega una capa extra de seguridad a tu cuenta requiriendo un código de verificación de tu teléfono.';

  @override
  String get enhancedSecurity => 'Seguridad Mejorada';

  @override
  String get enhancedSecurityDesc => 'Proteger contra acceso no autorizado';

  @override
  String get mobileAppSupport => 'Soporte de Aplicación Móvil';

  @override
  String get mobileAppSupportDesc =>
      'Funciona con Google Authenticator, Authy, y más';

  @override
  String get backupCodes => 'Códigos de Respaldo';

  @override
  String get backupCodesDesc =>
      'Códigos de recuperación en caso de perder tu dispositivo';

  @override
  String get enable2FA => 'Habilitar 2FA';

  @override
  String get scanQRCode => 'Escanear Código QR';

  @override
  String get scanQRCodeDesc =>
      'Usa tu aplicación autenticadora para escanear este código QR';

  @override
  String get manualEntryCode => 'Código de Entrada Manual';

  @override
  String get verificationCode => 'Código de Verificación';

  @override
  String get enterSixDigitCode => 'Ingresa código de 6 dígitos';

  @override
  String get verifyAndEnable => 'Verificar y Habilitar';

  @override
  String get twoFAEnabledSuccessfully => '¡2FA Habilitado Exitosamente!';

  @override
  String get saveBackupCodes =>
      'Guarda estos códigos de respaldo en un lugar seguro. Puedes usarlos para acceder a tu cuenta si pierdes tu dispositivo autenticador.';

  @override
  String get done => 'Hecho';

  @override
  String get twoFAEnabled => '2FA Habilitado';

  @override
  String get accountProtected =>
      'Tu cuenta está protegida con autenticación de dos factores';

  @override
  String get regenerate => 'Regenerar';

  @override
  String backupCodesRemaining(int count) {
    return 'Te quedan $count códigos de respaldo';
  }

  @override
  String get viewCodes => 'Ver Códigos';

  @override
  String get regenerateBackupCodes => 'Regenerar Códigos de Respaldo';

  @override
  String get generateNewBackupCodes => 'Generar nuevos códigos de respaldo';

  @override
  String get reset2FA => 'Restablecer 2FA';

  @override
  String get generateNewSecretKey => 'Generar nueva clave secreta';

  @override
  String get disable2FA => 'Deshabilitar 2FA';

  @override
  String get turnOff2FA => 'Desactivar autenticación de dos factores';

  @override
  String get copyAllCodes => 'Copiar Todos los Códigos';

  @override
  String get importExport => 'Importar y Exportar';

  @override
  String get import => 'Importar';

  @override
  String get export => 'Exportar';

  @override
  String get importPasswords => 'Importar Contraseñas';

  @override
  String get importPasswordsDesc =>
      'Importa tus contraseñas de otros gestores de contraseñas';

  @override
  String get exportPasswords => 'Exportar Contraseñas';

  @override
  String get exportPasswordsDesc =>
      'Crear una copia de seguridad o migrar a otro gestor de contraseñas';

  @override
  String get exportDataWarning =>
      'Asegúrate de exportar tus datos del otro gestor de contraseñas primero';

  @override
  String get sensitiveDataWarning =>
      'Los archivos exportados contienen datos sensibles. Almacénalos de forma segura y elimínalos después del uso.';

  @override
  String get chooseImportSource => 'Elegir Fuente de Importación';

  @override
  String get chooseExportFormat => 'Elegir Formato de Exportación';

  @override
  String get chrome => 'Chrome';

  @override
  String get chromeImportDesc =>
      'Importar desde exportación de contraseñas de Chrome (CSV)';

  @override
  String get firefox => 'Firefox';

  @override
  String get firefoxImportDesc =>
      'Importar desde exportación de contraseñas de Firefox (CSV)';

  @override
  String get safari => 'Safari';

  @override
  String get safariImportDesc =>
      'Importar desde exportación de contraseñas de Safari (CSV)';

  @override
  String get bitwarden => 'Bitwarden';

  @override
  String get bitwardenImportDesc =>
      'Importar desde exportación de bóveda de Bitwarden (JSON)';

  @override
  String get lastpass => 'LastPass';

  @override
  String get lastpassImportDesc =>
      'Importar desde exportación de bóveda de LastPass (CSV)';

  @override
  String get onepassword => '1Password';

  @override
  String get onepasswordImportDesc =>
      'Importar desde exportación de 1Password (CSV)';

  @override
  String get genericCSV => 'CSV Genérico';

  @override
  String get genericCSVDesc => 'Importar desde cualquier archivo CSV';

  @override
  String get jsonFile => 'Archivo JSON';

  @override
  String get jsonFileDesc => 'Importar desde archivo JSON';

  @override
  String get encryptedExport => 'Exportación Encriptada';

  @override
  String get encryptedExportDesc =>
      'Exportación segura con protección por contraseña (Recomendado)';

  @override
  String get csvExport => 'Exportación CSV';

  @override
  String get csvExportDesc =>
      'Compatible con la mayoría de gestores de contraseñas';

  @override
  String get jsonExport => 'Exportación JSON';

  @override
  String get jsonExportDesc => 'Formato de datos estructurado con metadatos';

  @override
  String get secure => 'SEGURO';

  @override
  String get privacy => 'Privacidad';

  @override
  String get cloudSync => 'Sincronización en la Nube';

  @override
  String get cloudSyncDesc => 'Sincronizar datos entre dispositivos';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get privacyPolicyDesc => 'Ver nuestra política de privacidad';

  @override
  String get dataUsage => 'Uso de Datos';

  @override
  String get dataUsageDesc => 'Ver cómo se usan tus datos';

  @override
  String get appearance => 'Apariencia';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get compactView => 'Vista Compacta';

  @override
  String get compactViewDesc => 'Mostrar más elementos en pantalla';

  @override
  String get showPasswords => 'Mostrar Contraseñas';

  @override
  String get showPasswordsDesc => 'Mostrar contraseñas por defecto';

  @override
  String get dataManagement => 'Gestión de Datos';

  @override
  String get importExportDesc => 'Importar desde otros gestores de contraseñas';

  @override
  String get backupRestore => 'Copia de Seguridad y Restauración';

  @override
  String get backupRestoreDesc => 'Crear y restaurar copias de seguridad';

  @override
  String get clearCache => 'Limpiar Caché';

  @override
  String get clearCacheDesc => 'Liberar espacio de almacenamiento';

  @override
  String get resetApp => 'Restablecer Aplicación';

  @override
  String get resetAppDesc => 'Eliminar todos los datos y restablecer';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get helpSupport => 'Ayuda y Soporte';

  @override
  String get helpSupportDesc => 'Obtener ayuda y contactar soporte';

  @override
  String get rateApp => 'Calificar Aplicación';

  @override
  String get rateAppDesc =>
      'Calificar SecureVault en la tienda de aplicaciones';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get termsOfServiceDesc => 'Ver términos y condiciones';

  @override
  String get biometricAuthentication => 'Autenticación Biométrica';

  @override
  String get biometricAuthDesc => 'Usar huella dactilar o desbloqueo facial';

  @override
  String get autoLock => 'Bloqueo Automático';

  @override
  String get autoLockDesc => 'Bloquear aplicación cuando esté inactiva';

  @override
  String get autoLockTimer => 'Temporizador de Bloqueo Automático';

  @override
  String lockAfterMinutes(int minutes) {
    return 'Bloquear después de $minutes minutos';
  }

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

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
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get warning => 'Advertencia';

  @override
  String get info => 'Información';

  @override
  String get confirm => 'Confirmar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Cerrar';

  @override
  String get loading => 'Cargando...';

  @override
  String get noData => 'No hay datos disponibles';

  @override
  String get tryAgain => 'Intentar de Nuevo';

  @override
  String get refresh => 'Actualizar';

  @override
  String get search => 'Buscar';

  @override
  String get searchAccounts => 'Buscar cuentas...';

  @override
  String get noAccountsFound => 'No se encontraron cuentas';

  @override
  String get addYourFirstAccount => 'Agrega tu primera cuenta para comenzar';

  @override
  String get copied => 'Copiado';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get developer => 'Desarrollador';

  @override
  String get familySharing => 'Compartir en Familia';

  @override
  String get overview => 'Resumen';

  @override
  String get members => 'Miembros';

  @override
  String get shared => 'Compartido';

  @override
  String get sharePassword => 'Compartir Contraseña';

  @override
  String get createYourFamilyVault => 'Crear Tu Bóveda Familiar';

  @override
  String get sharePasswordsSecurely =>
      'Comparte contraseñas de forma segura con los miembros de tu familia. Crea una bóveda familiar para comenzar.';

  @override
  String get createFamilyVault => 'Crear Bóveda Familiar';

  @override
  String get recentActivity => 'Actividad Reciente';

  @override
  String get sharedItems => 'Elementos Compartidos';

  @override
  String get yourName => 'Tu Nombre';

  @override
  String get enterYourFullName => 'Ingresa tu nombre completo';

  @override
  String get yourEmail => 'Tu Correo Electrónico';

  @override
  String get enterYourEmailAddress =>
      'Ingresa tu dirección de correo electrónico';

  @override
  String get create => 'Crear';

  @override
  String get familyVaultCreatedSuccessfully =>
      '¡Bóveda familiar creada exitosamente!';

  @override
  String failedToCreateFamilyVault(String error) {
    return 'Error al crear la bóveda familiar: $error';
  }

  @override
  String get inviteFamilyMember => 'Invitar Miembro de la Familia';

  @override
  String get generateInviteCode =>
      'Genera un código de invitación para compartir con tu miembro de la familia.';

  @override
  String get generateCode => 'Generar Código';

  @override
  String get inviteCodeGenerated => 'Código de Invitación Generado';

  @override
  String get shareThisCode =>
      'Comparte este código con tu miembro de la familia:';

  @override
  String get codeExpiresInDays => 'Este código expira en 7 días.';

  @override
  String get copyCode => 'Copiar Código';

  @override
  String failedToGenerateInviteCode(String error) {
    return 'Error al generar código de invitación: $error';
  }

  @override
  String get passwordSharingDialog =>
      'El diálogo de compartir contraseña se abriría aquí';

  @override
  String get editRole => 'Editar Rol';

  @override
  String get remove => 'Eliminar';

  @override
  String accountId(String id) {
    return 'ID de Cuenta: $id';
  }

  @override
  String sharedWithMembers(int count) {
    return 'Compartido con $count miembro(s)';
  }

  @override
  String sharedOn(String date) {
    return 'Compartido el $date';
  }

  @override
  String passwordSharedWithMembers(int count) {
    return 'Contraseña compartida con $count miembro(s)';
  }

  @override
  String failedToLoadFamilyData(String error) {
    return 'Error al cargar datos familiares: $error';
  }
}
