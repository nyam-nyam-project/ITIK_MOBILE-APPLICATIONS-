/// Peran pengguna. Operator sengaja TIDAK disertakan di aplikasi mobile ini
/// (operator hanya tersedia di website admin) — sesuai kesepakatan scope.
enum UserRole { siswa, guru }

extension UserRoleX on UserRole {
  String get label => this == UserRole.siswa ? 'Siswa' : 'Guru';

  static UserRole fromString(String v) => v == 'guru' ? UserRole.guru : UserRole.siswa;

  String get value => this == UserRole.siswa ? 'siswa' : 'guru';
}

class AppUser {
  final String id;
  final String nama;
  final String email;
  final String password;
  final UserRole role;
  final String? kelas;
  final String? induk; // NIS, khusus siswa

  AppUser({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
    required this.role,
    this.kelas,
    this.induk,
  });

  String get initials {
    final parts = nama.trim().split(RegExp(r'\s+'));
    final letters = parts.take(2).map((e) => e.isNotEmpty ? e[0] : '').join();
    return letters.toUpperCase();
  }
}
