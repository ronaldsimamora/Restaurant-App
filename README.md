# restaurant_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

**Hasil Review**
Catatan dari Reviewer

Hallo ronaldsimamora, kami ingin mengucapkan selamat! Karena kamu telah menyelesaikan tugas untuk Proyek Akhir: Favorite Restaurant App dari kelas Belajar Fundamental Aplikasi Flutter. 

Terima kasih telah sabar menunggu. Kami membutuhkan waktu untuk bisa memberikan feedback sekomprehensif mungkin kepada setiap peserta kelas. Dalam kesempatan ini ada 3 hal yang ingin kami sampaikan. 

Pertama, kamu harus bangga karena telah menyelesaikan submission sesuai dengan kriteria yang ada. Share sertifikat kamu di linkedin untuk menunjukkan skill kamu yang telah tervalidasi. Mention @dicoding di media sosial jika ingin memberi inspirasi yang lain.

Kedua, mumpung masih hangat semangatnya langsung lanjut ke kelas yang lebih advanced, yaitu Belajar Pengembangan Aplikasi Flutter Intermediate.

Ketiga, untuk meningkatkan kualitas project submission yang kamu kirimkan, berikut beberapa saran yang dapat diterapkan:

Overall Review

Kamu berhasil menyelesaikan seluruh kriteria utama pada final submission ini dengan sangat baik. Great Job!
Tidak hanya itu, kamu juga berhasil menyelesaikan tiga kriteria saran submission sebagai berikut:
Menuliskan Kode dengan Bersih
Menampilkan Pesan Error
Menerapkan 5 atau Lebih Testing
UI/UX Improvements

Setelah berhasil mengirim review, status tombol tidak langsung kembali aktif atau masih menampilkan infinite loading (CircularProgressIndicator). Disarankan untuk memperbaiki mekanisme tersebut dengan memastikan kebenaran nilai state setelah berhasil mengirimkan review restoran.
Pada aplikasi yang kamu buat saat ini hanya terdapat 2 tab atau halaman saja, maka tidak disarankan menggunakan BottomNavigationBar.
<img width="538" height="80" alt="image" src="https://github.com/user-attachments/assets/3378a775-c49c-46ac-86b5-9148b1c928f0" />
Widget BottomNavigationBar digunakan jika terdapat 3–5 destinasi atau halaman. Untuk 1–2 halaman, pertimbangkan alternatif seperti TabBar, Drawer, atau tombol navigasi sederhana. Kamu dapat membaca penjelasan lebih lanjut pada halaman berikut:
https://m1.material.io/components/bottom-navigation.
https://m2.material.io/components/bottom-navigation.
https://m3.material.io/components/navigation-bar.
Code Improvements

Disarankan agar memperhatikan kembali struktur kode pada RestaurantDetailPage, karena satu file memuat banyak widget dan logika UI. Sebaiknya beberapa bagian seperti header restoran, deskripsi, menu list, review list, dan form review dipindahkan ke widget atau berkas terpisah agar kode lebih modular, rapi, mudah dibaca, serta memudahkan proses pemeliharaan dan pengembangan selanjutnya.
Sebaiknya dalam satu berkas hanya terdapat satu buah kelas, hal ini bertujuan untuk meningkatkan keterbacaan kode dan pemeliharaan apabila ukuran project terus berkembang di kemudian hari.
Kamu dapat menggunakan perintah "Fix Imports" atau "Optimize Imports" yang tersedia di IDE untuk merapikan dan mengurutkan import secara otomatis.
Secara keseluruhan, indentasi kode sudah ditulis dengan rapi dan mengikuti best practice Dart. Pertahankan ya!
Next Step

Untuk menambah pengalamanmu di bidang Flutter, kami sangat menyarankanmu untuk mencoba mengerjakan kriteria opsional yang belum terpenuhi. Berikut penjabarannya:
Menerapkan 3 Jenis Testing yang Berbeda;
Cobalah untuk melengkapi jenis pengujian aplikasi dengan menambahkan widget test maupun integration test untuk memastikan interaksi antarkomponen aplikasi berjalan dengan baik, mendeteksi potensi kesalahan sejak dini, serta mencegah terjadinya regresi akibat perubahan atau penambahan fitur sehingga kualitas aplikasi tetap terjaga secara berkelanjutan. Kamu bisa mempelajari kembali materi tersebut pada modul berikut:
Latihan: Widget Testing
Integration Testing
Latihan: Integration Testing
Memodifikasi Notifikasi Daily Reminder;
Cobalah memodifikasi fitur schedule daily reminder menggunakan Workmanager untuk menampilkan informasi restoran secara acak yang berasal dari API, agar memperdalam pemahamanmu tentang pengelolaan background process dan penyesuaian fitur sesuai kebutuhan pengguna. Sebagai referensi, kamu bisa mempelajari kembali materi pada modul Latihan: Workmanager.
Well done! Kamu sudah berhasil menyelesaikan kelas Belajar Fundamental Aplikasi Flutter dengan sangat baik! Selanjutnya, kamu bisa coba mengeksplorasi penggunaan Declarative Navigation agar alur navigasi aplikasi jadi lebih mudah dipahami dan dikelola, terutama untuk aplikasi yang kompleks. Kamu dapat mempelajarinya pada kelas Belajar Pengembangan Aplikasi Flutter Intermediate.


Silakan berkunjung ke forum diskusi untuk mengasah kembali penguasaan ilmu kamu dan membuat ilmu kamu bisa semakin bermanfaat dengan membantu developer yang lain. 

Terima kasih telah membantu misi kami. Kesuksesan developer Indonesia adalah energi bagi kami. Jika memiliki pertanyaan terkait hasil submission, silakan mengikuti prosedur berikut.

Terima kasih


