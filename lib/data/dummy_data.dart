import '../models/user.dart';
import '../models/materi.dart';
import '../models/kuis.dart';
import '../models/hasil_kuis.dart';

/// Data contoh (dummy) — dipakai selama belum ada backend/API.
/// Struktur & isinya disalin dari `DB` pada prototipe HTML supaya perilaku
/// akun demo & konten tetap sama persis.
class DummyData {
  static List<AppUser> users() => [
        AppUser(
          id: 'U1',
          nama: 'Ryo Febriyansah',
          email: 'ryo@siswa.sch.id',
          password: '123456',
          role: UserRole.siswa,
          kelas: 'X TKJ 1',
          induk: 'E41250266',
        ),
        AppUser(
          id: 'U2',
          nama: 'Sari Dewi, S.Pd',
          email: 'sari@guru.sch.id',
          password: '123456',
          role: UserRole.guru,
        ),
        AppUser(
          id: 'U4',
          nama: 'Andi Wirawan',
          email: 'andi@siswa.sch.id',
          password: '123456',
          role: UserRole.siswa,
          kelas: 'X TKJ 1',
          induk: 'E41250271',
        ),
        AppUser(
          id: 'U5',
          nama: 'Putri Amelia',
          email: 'putri@siswa.sch.id',
          password: '123456',
          role: UserRole.siswa,
          kelas: 'X TKJ 2',
          induk: 'E41250284',
        ),
      ];

        static List<Kuis> kuis() => [
        Kuis(
          id: 'K1',
          judul: 'Kuis Perangkat Komputer',
          materiId: 'M1',
          level: 'Mudah',
          oleh: 'Budi Santoso',
          tanggal: '03 Sep 2026',
          waktu: 5,
          kkm: 75,
          soal: [
            Soal(
              pertanyaan: 'Perangkat keras yang berfungsi sebagai otak komputer disebut...',
              opsi: ['RAM', 'CPU', 'Monitor', 'Keyboard'],
              jawaban: 1,
            ),
            Soal(
              pertanyaan: 'Alat untuk menampilkan hasil kerja komputer secara visual adalah...',
              opsi: ['Printer', 'Speaker', 'Monitor', 'Mouse'],
              jawaban: 2,
            ),
            Soal(
              pertanyaan: 'Berikut yang termasuk perangkat input adalah...',
              opsi: ['Keyboard', 'Printer', 'Speaker', 'Monitor'],
              jawaban: 0,
            ),
          ],
        ),
        Kuis(
          id: 'K2',
          judul: 'Kuis Microsoft Word',
          materiId: 'M2',
          level: 'Sedang',
          oleh: 'Budi Santoso',
          tanggal: '05 Sep 2026',
          waktu: 7,
          kkm: 75,
          soal: [
            Soal(
              pertanyaan: 'Untuk membuat teks tebal pada Word digunakan ikon...',
              opsi: ['I (Italic)', 'B (Bold)', 'U (Underline)', 'S (Strikethrough)'],
              jawaban: 1,
            ),
            Soal(
              pertanyaan: 'Fitur menggabungkan beberapa sel pada tabel disebut...',
              opsi: ['Split Cells', 'Insert Table', 'Merge Cells', 'Delete Cells'],
              jawaban: 2,
            ),
            Soal(
              pertanyaan: 'Ekstensi file default dokumen Word 2016 ke atas adalah...',
              opsi: ['.doc', '.pdf', '.txt', '.docx'],
              jawaban: 3,
            ),
          ],
        ),
        Kuis(
          id: 'K3',
          judul: 'Kuis Internet & Email',
          materiId: 'M3',
          level: 'Sulit',
          oleh: 'Sari Dewi, S.Pd',
          tanggal: '08 Sep 2026',
          waktu: 10,
          kkm: 80,
          soal: [
            Soal(
              pertanyaan: 'Protokol yang umum digunakan untuk mengirim email adalah...',
              opsi: ['HTTP', 'SMTP', 'FTP', 'SSH'],
              jawaban: 1,
            ),
            Soal(
              pertanyaan: 'Pada alamat email "siswa@sekolah.sch.id", bagian domain adalah...',
              opsi: ['siswa', '@', 'sekolah.sch.id', '.id'],
              jawaban: 2,
            ),
            Soal(
              pertanyaan: 'Berikut ini yang bukan merupakan browser internet adalah...',
              opsi: ['Chrome', 'Firefox', 'Microsoft Word', 'Edge'],
              jawaban: 2,
            ),
          ],
        ),
      ];

  static List<Materi> materi() => [
        Materi(
          id: 'M1',
          bab: 'Bab 1',
          judul: 'Mengenal Perangkat Komputer',
          kelas: 'X TKJ',
          deskripsi: 'Pengenalan hardware & software dasar untuk pemula.',
          isi:
              'Komputer terdiri dari perangkat keras (hardware) seperti CPU, monitor, keyboard, dan mouse, '
              'serta perangkat lunak (software) yang menjalankan perintah pengguna.',
          pdfName: 'Bab1-Mengenal-Perangkat-Komputer.pdf',
          ukuran: '248 KB',
          oleh: 'Budi Santoso',
          tanggal: '02 Sep 2026',
        ),
        Materi(
          id: 'M2',
          bab: 'Bab 2',
          judul: 'Dasar Microsoft Word',
          kelas: 'X TKJ',
          deskripsi: 'Membuat dan memformat dokumen sederhana.',
          isi:
              'Microsoft Word digunakan untuk membuat dokumen teks. Fitur dasar meliputi pengetikan, '
              'pengaturan huruf (bold, italic, underline), penyisipan gambar, dan pengaturan halaman.',
          pdfName: 'Bab2-Dasar-Microsoft-Word.pdf',
          ukuran: '312 KB',
          oleh: 'Budi Santoso',
          tanggal: '04 Sep 2026',
        ),
        Materi(
          id: 'M3',
          bab: 'Bab 3',
          judul: 'Internet & Email',
          kelas: 'X TKJ',
          deskripsi: 'Menggunakan internet dan membuat surel (email).',
          isi:
              'Internet memungkinkan pertukaran informasi secara global. Email adalah salah satu layanan '
              'internet untuk mengirim pesan elektronik.',
          pdfName: 'Bab3-Internet-dan-Email.pdf',
          ukuran: '196 KB',
          oleh: 'Sari Dewi, S.Pd',
          tanggal: '07 Sep 2026',
        ),
        Materi(
          id: 'M4',
          bab: 'Bab 4',
          judul: 'Dasar Microsoft Excel',
          kelas: 'X TKJ',
          deskripsi: 'Pengolahan data dan rumus sederhana.',
          isi:
              'Microsoft Excel digunakan untuk mengolah data berbentuk tabel. Rumus dasar seperti SUM, '
              'AVERAGE, dan format sel membantu pengolahan data lebih cepat dan rapi.',
          pdfName: 'Bab4-Dasar-Microsoft-Excel.pdf',
          ukuran: '274 KB',
          oleh: 'Sari Dewi, S.Pd',
          tanggal: '09 Sep 2026',
        ),
      ];

  static List<HasilKuis> hasil() => [
      HasilKuis(
        id: 'H1',
        siswaId: 'U1',
        siswa: 'Ryo Febriyansah',
        kuisId: 'K1',
        kuis: 'Kuis Perangkat Komputer',
        level: 'Mudah',
        nilai: 100,
        kkm: 75,
        durasi: 142,
        benar: 3,
        jawabanSiswa: [1, 2, 0],
        tanggal: '10 Sep 2026',
        status: StatusValidasi.divalidasi,
      ),
      HasilKuis(
        id: 'H2',
        siswaId: 'U4',
        siswa: 'Andi Wirawan',
        kuisId: 'K2',
        kuis: 'Kuis Microsoft Word',
        level: 'Sedang',
        nilai: 73,
        kkm: 75,
        durasi: 398,
        benar: 2,
        jawabanSiswa: [1, 2, 0],
        tanggal: '12 Sep 2026',
      ),
      HasilKuis(
        id: 'H3',
        siswaId: 'U5',
        siswa: 'Putri Amelia',
        kuisId: 'K3',
        kuis: 'Kuis Internet & Email',
        level: 'Sulit',
        nilai: 65,
        kkm: 75,
        durasi: 571,
        benar: 2,
        jawabanSiswa: [1, 0, 2],
        tanggal: '13 Sep 2026',
      ),
    ];

}
