# Product Requirements Document

## SpellingBae: English Spelling

**Tagline:** Your Spelling Bestie  
**Core Phrase:** Hear it. Say it. Spell it.  
**Mascot:** Bae the Bee  
**Platform:** iPhone dan iPad  
**Product Type:** Educational App Gamification  
**Primary Framework:** Speech  
**Secondary Framework:** AVFoundation  
**Document Version:** 1.0  
**Product Stage:** Minimum Viable Product

---

## 1. Product Overview

**SpellingBae** adalah aplikasi latihan mengeja bahasa Inggris berbasis gamifikasi untuk siswa sekolah dasar usia 7–12 tahun.

Bersama **Bae the Bee**, pengguna mendengarkan pelafalan sebuah kata, mengucapkan kata tersebut, atau mengejanya dengan suara maupun input huruf. Aplikasi kemudian mentranskripsikan jawaban pengguna, membandingkannya dengan kata target, dan memberikan umpan balik audio serta visual secara langsung.

Setiap keberhasilan memberikan bintang dan **Honey Points** yang dapat digunakan untuk membuka level, aksesori Bae, dan dekorasi sarang.

SpellingBae dirancang untuk digunakan ketika anak belajar secara mandiri di rumah, mengikuti aktivitas di kelas, atau mempersiapkan kuis dan kompetisi spelling.

---

## 2. Product Vision

Menciptakan pengalaman belajar spelling bahasa Inggris yang membuat anak merasa sedang bermain dan bertualang bersama teman, bukan sedang menjalani ujian.

SpellingBae membantu anak membangun kemampuan listening, spelling, vocabulary, dan keberanian berbicara melalui latihan singkat, interaktif, suportif, dan berulang.

---

## 3. Problem Statement

Siswa sekolah dasar sering mengalami kesulitan dalam:

- menghubungkan bunyi kata dengan susunan huruf;
- mengingat ejaan kata bahasa Inggris;
- mengetahui bagian ejaan yang masih salah;
- berlatih berbicara tanpa takut dinilai;
- menjaga motivasi untuk berlatih secara rutin;
- mengulang kata yang belum dikuasai secara terarah.

Metode latihan tradisional cenderung berfokus pada membaca, menulis, dan menghafal. Metode tersebut belum selalu memberikan umpan balik suara secara langsung atau pengalaman belajar yang personal.

---

## 4. Product Solution

SpellingBae menggabungkan **Speech** dan **AVFoundation** untuk:

1. memutar audio pelafalan kata;
2. merekam suara pengguna;
3. mengenali dan mentranskripsikan kata atau rangkaian huruf yang diucapkan;
4. membandingkan hasil transkripsi dengan jawaban target;
5. menunjukkan bagian jawaban yang benar atau salah;
6. memberikan kesempatan untuk mencoba kembali;
7. menyesuaikan latihan berdasarkan performa pengguna;
8. memberikan reward melalui sistem gamifikasi.

**AVFoundation** digunakan untuk mengelola pemutaran dan perekaman audio. **Speech** digunakan untuk mengenali dan mentranskripsikan ucapan. Penilaian ketepatan spelling dilakukan oleh logika aplikasi melalui perbandingan antara hasil transkripsi dan kata target.

---

## 5. Product Goals

### 5.1 User Goals

Pengguna dapat:

- mendengarkan pelafalan kata dengan jelas;
- mengeja kata dengan teks atau suara;
- mengucapkan kata secara utuh;
- mengetahui kesalahan spelling secara langsung;
- mengulang kata yang belum dikuasai;
- melihat perkembangan kemampuan belajarnya;
- merasa termotivasi untuk berlatih secara rutin.

### 5.2 Business and Product Goals

Produk diharapkan dapat:

- meningkatkan penyelesaian sesi latihan;
- mendorong pengguna kembali berlatih;
- meningkatkan jumlah kata yang berhasil dikuasai;
- membangun identitas produk melalui Bae the Bee;
- menyediakan fondasi untuk pengembangan materi spelling yang lebih luas.

---

## 6. Non-Goals

Versi MVP tidak ditujukan untuk:

- menilai aksen pengguna secara mendalam;
- memberikan diagnosis gangguan bicara;
- menggantikan guru bahasa Inggris;
- menyediakan percakapan bahasa Inggris bebas;
- menyelenggarakan kompetisi langsung antarpengguna;
- menyediakan fitur chat atau komunikasi sosial;
- membuat penilaian akademik resmi;
- mendukung materi bahasa selain bahasa Inggris.

---

## 7. Target Users

### 7.1 Primary User

Siswa sekolah dasar usia 7–12 tahun yang:

- sedang belajar spelling bahasa Inggris;
- memiliki kemampuan membaca dasar;
- menggunakan iPhone atau iPad;
- membutuhkan latihan listening dan spelling;
- lebih tertarik belajar melalui permainan.

### 7.2 Secondary User

Orang tua atau guru yang ingin:

- menyediakan latihan spelling tambahan;
- mengetahui perkembangan belajar anak;
- membantu anak mempersiapkan kuis;
- memilih tingkat kesulitan yang sesuai.

Untuk MVP, pengalaman utama tetap berfokus pada anak. Dashboard khusus orang tua atau guru dapat dikembangkan pada versi berikutnya.

---

## 8. User Persona

### Primary Persona: Young English Learner

**Nama:** Mia  
**Usia:** 9 tahun  
**Kebutuhan:** Berlatih spelling untuk tugas sekolah  
**Perangkat:** iPad keluarga  
**Kesulitan:** Mudah bosan dan sering tertukar ketika mengeja kata  
**Motivasi:** Menyukai karakter lucu, koleksi item, dan pencapaian visual  
**Tujuan:** Dapat mendengarkan dan mengeja kata tanpa bantuan

### Secondary Persona: Parent

**Nama:** Sarah  
**Kebutuhan:** Menyediakan aktivitas belajar mandiri selama 10–15 menit  
**Tujuan:** Mengetahui apakah anak benar-benar mengalami perkembangan  
**Perhatian utama:** Keamanan, kemudahan penggunaan, dan konten yang sesuai usia

---

## 9. Jobs to Be Done

### Untuk siswa

> Ketika saya sedang belajar kosakata bahasa Inggris, saya ingin mendengarkan dan mengeja kata melalui aktivitas yang menyenangkan agar saya dapat mengingat ejaannya dengan lebih mudah.

### Untuk orang tua atau guru

> Ketika anak sedang berlatih spelling, saya ingin aplikasi memberikan latihan dan koreksi secara langsung agar anak dapat belajar dengan lebih mandiri.

---

## 10. Core Experience

Pengalaman inti SpellingBae mengikuti pola:

> **Hear it → Say or Spell it → Receive feedback → Earn rewards → Review mistakes**

Dalam setiap sesi, pengguna:

1. menerima kata dari Bae;
2. mendengarkan pelafalannya;
3. melihat petunjuk jika diperlukan;
4. menjawab melalui teks atau suara;
5. menerima umpan balik;
6. mendapatkan hadiah;
7. melanjutkan ke kata berikutnya;
8. melihat ringkasan sesi.

---

## 11. Core Narrative

Bae adalah lebah kecil yang mengumpulkan madu dari kata-kata yang berhasil dikuasai.

Setiap jawaban benar membantu Bae memperoleh **Honey Points**, mengisi honeycomb, dan mengembangkan sarangnya. Semakin banyak kata yang dipelajari, semakin hidup dan menarik sarang Bae.

Kesalahan tidak diposisikan sebagai kegagalan. Bae memberikan respons suportif dan mengajak pengguna mencoba kembali.

Contoh respons Bae:

- “Great job! You spelled it correctly!”
- “Almost there. Let’s listen again!”
- “That was a tricky word!”
- “You earned more honey!”
- “Bee-lievable! You mastered a new word!”

---

## 12. MVP Scope

### 12.1 Must Have

- onboarding sederhana;
- izin mikrofon dan speech recognition;
- pemilihan level kesulitan;
- pemutaran audio kata;
- mode Listen and Spell;
- mode Spell Aloud;
- mode Say the Word;
- repeat pronunciation;
- instant feedback;
- word hints;
- sistem Stars dan Honey Points;
- progress tracking;
- mistake review;
- session summary;
- karakter Bae sebagai pemandu.

### 12.2 Should Have

- daily challenge;
- badges;
- unlockable accessories;
- adaptive difficulty;
- pengaturan kecepatan audio;
- pengaturan efek suara dan musik;
- streak yang ramah anak.

### 12.3 Could Have

- profil beberapa anak;
- dashboard orang tua atau guru;
- custom word list;
- classroom mode;
- kompetisi spelling lokal;
- sinkronisasi progres antarperangkat;
- seasonal events;
- lebih banyak kostum dan dekorasi sarang.

### 12.4 Won’t Have in MVP

- multiplayer daring;
- chat antarpengguna;
- public leaderboard;
- penilaian aksen secara mendalam;
- fitur jejaring sosial;
- materi bahasa selain bahasa Inggris.

---

# 13. Feature Requirements

## 13.1 Onboarding

Onboarding memperkenalkan:

- nama aplikasi;
- Bae the Bee;
- cara mendengarkan kata;
- cara menggunakan mikrofon;
- cara mendapatkan Honey Points;
- tujuan latihan.

Onboarding maksimal terdiri dari empat layar dan dapat dilewati.

### Acceptance Criteria

- pengguna memahami aktivitas utama tanpa membaca instruksi panjang;
- pengguna dapat memilih rentang tingkat kemampuan;
- aplikasi meminta izin mikrofon hanya ketika diperlukan;
- penolakan izin tidak membuat aplikasi berhenti berfungsi sepenuhnya.

---

## 13.2 Listen and Spell

Pengguna mendengarkan sebuah kata lalu mengetik atau menyusun huruf untuk membentuk jawaban yang benar.

### Requirements

- tersedia tombol untuk memutar audio;
- tersedia input keyboard atau pilihan susunan huruf;
- pengguna dapat menghapus dan memperbaiki jawaban;
- aplikasi membandingkan jawaban tanpa membedakan huruf kapital;
- hasil ditampilkan segera setelah jawaban dikirim.

### Acceptance Criteria

- jawaban yang sesuai dengan kata target dinilai benar;
- huruf yang salah atau tertukar ditampilkan dengan jelas;
- pengguna dapat mencoba kembali;
- kata selesai setelah benar atau setelah batas percobaan tercapai.

---

## 13.3 Spell Aloud

Pengguna mengeja kata dengan menyebutkan setiap huruf melalui mikrofon.

Contoh:

> Target word: CAT  
> Spoken response: “C, A, T”

### Requirements

- aplikasi merekam suara pengguna;
- Speech mentranskripsikan huruf yang disebutkan;
- aplikasi menormalisasi hasil transkripsi;
- hasil dibandingkan dengan urutan huruf kata target;
- pengguna dapat melihat hasil huruf yang dikenali.

### Normalization

Aplikasi perlu menangani kemungkinan transkripsi seperti:

- “C A T”;
- “C, A, T”;
- “see ay tee”;
- huruf kecil dan huruf kapital;
- spasi dan tanda baca yang tidak relevan.

### Acceptance Criteria

- setiap huruf hasil pengenalan ditampilkan;
- sistem menunjukkan huruf yang benar, salah, atau terlewat;
- pengguna dapat merekam ulang;
- aplikasi tidak menyatakan kualitas aksen pengguna;
- kegagalan transkripsi menghasilkan pesan yang mudah dipahami.

---

## 13.4 Say the Word

Pengguna mengucapkan kata secara utuh melalui mikrofon.

### Requirements

- aplikasi merekam kata yang diucapkan;
- Speech mentranskripsikan kata;
- hasil transkripsi dibandingkan dengan kata target;
- aplikasi menerima variasi kapitalisasi;
- aplikasi memberikan kesempatan untuk mencoba kembali.

### Acceptance Criteria

- kata dinilai benar ketika transkripsi sesuai dengan target;
- pengguna dapat melihat kata yang dikenali aplikasi;
- aplikasi memberi respons yang suportif ketika ucapan tidak dikenali;
- fitur tidak mengklaim melakukan penilaian fonetik secara mendalam.

---

## 13.5 Repeat Pronunciation

Pengguna dapat memutar ulang pelafalan kata.

### Requirements

- tombol audio selalu terlihat selama latihan;
- audio dapat diputar ulang tanpa batas penalti;
- tersedia kecepatan normal;
- kecepatan lambat dapat ditambahkan apabila kualitas audio tetap jelas.

### Acceptance Criteria

- audio dapat dihentikan dan diputar kembali;
- pemutaran audio tidak tumpang tindih;
- perekaman tidak dimulai ketika audio target masih diputar;
- audio berhenti ketika pengguna keluar dari layar latihan.

---

## 13.6 Word Hints

Petunjuk membantu pengguna tanpa langsung memberikan jawaban.

Jenis petunjuk:

1. gambar;
2. definisi sederhana;
3. contoh kalimat;
4. jumlah huruf;
5. huruf pertama;
6. pemutaran audio ulang;
7. pemisahan sederhana berdasarkan bunyi atau suku kata.

### Rules

- petunjuk digunakan secara bertahap;
- penggunaan petunjuk dapat mengurangi bonus bintang;
- pengguna tidak kehilangan progres karena menggunakan petunjuk.

---

## 13.7 Instant Feedback

Aplikasi memberikan feedback segera setelah pengguna menjawab.

### Correct Answer

- animasi positif;
- suara pendek;
- respons Bae;
- tambahan Honey Points;
- tampilan kata yang benar.

### Incorrect Answer

- tidak menggunakan pesan negatif;
- menunjukkan perbedaan jawaban;
- menawarkan audio ulang;
- menawarkan petunjuk;
- memberikan kesempatan mencoba kembali.

### Example

**Target:** SCHOOL  
**User answer:** SCool

Aplikasi dapat menunjukkan:

- huruf yang benar;
- huruf yang terlewat;
- posisi huruf yang berbeda;
- bentuk kata target yang benar setelah percobaan selesai.

---

## 13.8 Adaptive Difficulty

Aplikasi menyesuaikan latihan berdasarkan performa pengguna.

### Factors

- jumlah jawaban benar;
- jumlah percobaan;
- penggunaan petunjuk;
- kata yang sering salah;
- panjang kata;
- tingkat kesulitan kosakata;
- waktu sejak kata terakhir dipelajari.

### Basic MVP Logic

- tiga atau lebih jawaban benar berturut-turut: tawarkan kata lebih sulit;
- dua atau lebih kesalahan pada kata yang sama: masukkan ke Mistake Review;
- kata yang berhasil beberapa kali: tandai sebagai Mastered;
- kata lama yang belum dilatih kembali: masukkan ke sesi review.

---

## 13.9 Daily Challenge

Bae memberikan satu sesi latihan harian.

Contoh:

- spell five words correctly;
- complete one Spell Aloud session;
- review three difficult words;
- earn three stars.

### Reward

- bonus Honey Points;
- badge progress;
- item dekorasi tertentu;
- animasi sarang.

Daily Challenge tidak boleh memberikan tekanan berlebihan. Pengguna yang melewatkan satu hari tetap dapat melanjutkan progres normal.

---

## 13.10 Stars and Honey Points

### Stars

Setiap level memberikan maksimal tiga bintang.

Contoh logika:

- tiga bintang: benar tanpa atau dengan sedikit bantuan;
- dua bintang: benar setelah beberapa percobaan;
- satu bintang: menyelesaikan kata dengan bantuan penuh.

### Honey Points

Honey Points digunakan untuk:

- membuka aksesori Bae;
- membeli dekorasi sarang;
- membuka tema visual;
- mengisi honeycomb progression.

Honey Points tidak dapat dibeli dengan uang pada versi MVP.

---

## 13.11 Badges and Levels

Contoh badges:

- **First Flight:** menyelesaikan latihan pertama;
- **Perfect Speller:** menjawab sepuluh kata dengan benar;
- **Brave Speaker:** menyelesaikan mode suara;
- **Nectar Collector:** mengumpulkan sejumlah Honey Points;
- **Word Master:** menguasai satu kelompok kata;
- **Daily Helper:** menyelesaikan beberapa Daily Challenge.

Level dapat dibagi menjadi:

1. Tiny Words;
2. Busy Bee;
3. Word Explorer;
4. Spelling Star;
5. Hive Champion.

---

## 13.12 Learning Progress

Aplikasi menampilkan:

- jumlah kata yang dipelajari;
- jumlah kata yang dikuasai;
- jumlah kata yang perlu diulang;
- akurasi jawaban;
- jumlah sesi;
- total Honey Points;
- badge yang diperoleh.

Progress harus mudah dipahami anak melalui visual, bukan hanya angka.

Status kata:

- **New**;
- **Learning**;
- **Practicing**;
- **Mastered**;
- **Needs Review**.

---

## 13.13 Mistake Review

Kata yang sering salah dimasukkan ke sesi khusus.

### Requirements

- kata salah tersimpan secara lokal;
- kata diprioritaskan berdasarkan jumlah kesalahan;
- pengguna dapat membuka sesi review kapan saja;
- kata keluar dari daftar prioritas setelah berhasil dijawab beberapa kali.

### Acceptance Criteria

- pengguna dapat melihat kata yang perlu diulang;
- review tidak hanya menampilkan kata yang baru saja salah;
- progres kata diperbarui setelah sesi selesai.

---

# 14. Information Architecture

Navigasi utama MVP terdiri dari:

## Home

Menampilkan:

- sapaan dari Bae;
- tombol Start Practice;
- Daily Challenge;
- jumlah Honey Points;
- progres level;
- akses ke Mistake Review.

## Practice

Menampilkan pilihan:

- Listen and Spell;
- Spell Aloud;
- Say the Word;
- Mixed Practice.

## Progress

Menampilkan:

- kata yang dipelajari;
- kata yang dikuasai;
- kata yang perlu diulang;
- badges;
- statistik sederhana.

## Hive

Menampilkan:

- Bae;
- aksesori;
- dekorasi sarang;
- item yang sudah dibuka.

## Settings

Menampilkan:

- sound effects;
- music;
- audio speed;
- microphone permission status;
- reset progress;
- accessibility options;
- privacy information.

---

# 15. Primary User Flow

## First-Time User Flow

1. Pengguna membuka SpellingBae.
2. Bae memperkenalkan diri.
3. Pengguna memilih tingkat awal.
4. Aplikasi menjelaskan latihan singkat.
5. Pengguna memulai Listen and Spell.
6. Ketika memilih fitur suara, aplikasi meminta izin.
7. Pengguna menyelesaikan lima kata.
8. Pengguna menerima Honey Points.
9. Ringkasan sesi ditampilkan.
10. Pengguna membuka dekorasi pertama.

## Returning User Flow

1. Pengguna membuka aplikasi.
2. Bae menampilkan progres dan Daily Challenge.
3. Pengguna memilih Continue Practice.
4. Aplikasi menyajikan campuran kata baru dan review.
5. Pengguna menyelesaikan sesi.
6. Progres dan reward diperbarui.

---

# 16. Content Requirements

Setiap kata memiliki data berikut:

- unique identifier;
- word;
- level;
- category;
- difficulty;
- pronunciation audio;
- simple definition;
- example sentence;
- image reference;
- first-letter hint;
- letter count;
- mastery status.

### Initial Content Recommendation

MVP dapat dimulai dengan 150–300 kata yang dibagi berdasarkan:

- panjang kata;
- tingkat kesulitan;
- topik;
- frekuensi penggunaan;
- kesesuaian usia.

Contoh kategori:

- animals;
- school;
- family;
- food;
- nature;
- colors;
- actions;
- places;
- daily objects.

---

# 17. Difficulty Framework

## Beginner

- tiga sampai empat huruf;
- pola suara sederhana;
- kosakata umum;
- bantuan gambar tersedia.

Contoh: cat, dog, sun, book.

## Intermediate

- lima sampai tujuh huruf;
- silent letters sederhana;
- kombinasi huruf;
- petunjuk lebih terbatas.

Contoh: school, friend, yellow, garden.

## Advanced

- kata lebih panjang;
- pola ejaan tidak langsung;
- kosakata akademik dasar;
- audio dan definisi menjadi petunjuk utama.

Contoh: beautiful, different, language, important.

---

# 18. Functional Requirements Summary

| ID | Requirement | Priority |
|---|---|---|
| FR-01 | Aplikasi dapat memutar audio kata | Must |
| FR-02 | Aplikasi dapat merekam suara pengguna | Must |
| FR-03 | Aplikasi dapat mentranskripsikan ucapan | Must |
| FR-04 | Aplikasi dapat membandingkan jawaban dengan kata target | Must |
| FR-05 | Aplikasi memberikan feedback langsung | Must |
| FR-06 | Pengguna dapat mengetik atau menyusun huruf | Must |
| FR-07 | Pengguna dapat mengeja menggunakan suara | Must |
| FR-08 | Pengguna dapat mengucapkan kata secara utuh | Must |
| FR-09 | Pengguna dapat menggunakan petunjuk | Must |
| FR-10 | Aplikasi menyimpan progres belajar | Must |
| FR-11 | Aplikasi menyediakan Mistake Review | Must |
| FR-12 | Aplikasi memberikan Stars dan Honey Points | Must |
| FR-13 | Aplikasi menyediakan Daily Challenge | Should |
| FR-14 | Aplikasi menyesuaikan tingkat kesulitan | Should |
| FR-15 | Pengguna dapat membuka aksesori dan dekorasi | Should |

---

# 19. Technical Requirements

## 19.1 Speech

Speech digunakan untuk:

- mengenali kata yang diucapkan;
- mentranskripsikan rangkaian huruf;
- memberikan hasil transkripsi kepada logika evaluasi;
- menampilkan hasil yang berhasil dikenali.

Aplikasi perlu menangani:

- ucapan yang tidak dikenali;
- hasil transkripsi kosong;
- gangguan suara lingkungan;
- izin yang ditolak;
- koneksi atau layanan pengenalan yang tidak tersedia;
- perbedaan hasil transkripsi huruf dan kata.

## 19.2 AVFoundation

AVFoundation digunakan untuk:

- mengatur audio session;
- memutar pelafalan kata;
- merekam input mikrofon;
- mengelola konflik antara playback dan recording;
- menghentikan audio ketika layar berubah;
- mengatur volume dan kecepatan playback apabila digunakan.

## 19.3 Application Logic

Logika aplikasi bertanggung jawab untuk:

- membersihkan hasil transkripsi;
- menormalisasi huruf;
- menghapus tanda baca yang tidak diperlukan;
- membandingkan jawaban dengan kata target;
- menentukan feedback;
- memperbarui mastery level;
- menghitung Stars dan Honey Points.

---

# 20. Data Model

## User Profile

- user ID lokal;
- display name atau nickname;
- selected level;
- total Honey Points;
- current level;
- unlocked items;
- settings;
- onboarding status.

## Word Progress

- word ID;
- attempts;
- correct attempts;
- incorrect attempts;
- hint usage;
- last practiced date;
- mastery status;
- next review priority.

## Session Record

- session ID;
- session date;
- mode;
- number of words;
- correct answers;
- incorrect answers;
- Honey Points earned;
- duration.

## Reward Inventory

- item ID;
- item type;
- unlock status;
- equipped status;
- unlock requirement.

---

# 21. Privacy and Child Safety

Karena target utama adalah anak-anak, produk harus meminimalkan pengumpulan data.

### Requirements

- aplikasi tidak menyimpan rekaman suara secara permanen secara default;
- audio digunakan hanya untuk proses pengenalan yang diperlukan;
- tidak tersedia chat atau komunikasi antarpengguna;
- tidak tersedia profil publik;
- tidak menggunakan public leaderboard;
- pengaturan dan informasi privasi harus mudah ditemukan;
- izin mikrofon dijelaskan menggunakan bahasa yang sederhana;
- data progres disimpan secara lokal pada MVP jika sinkronisasi belum diperlukan;
- data yang tidak diperlukan untuk fungsi belajar tidak boleh dikumpulkan.

Contoh penjelasan izin:

> “SpellingBae needs the microphone so Bae can hear the word or letters you say.”

---

# 22. Permission States

## Microphone Permission Granted

Semua mode tersedia.

## Microphone Permission Denied

Mode berikut tetap tersedia:

- Listen and Spell;
- letter arrangement;
- progress;
- Mistake Review;
- Hive customization.

Mode suara menampilkan penjelasan dan tombol untuk membuka pengaturan perangkat.

## Speech Recognition Unavailable

Aplikasi:

- tidak menghapus jawaban pengguna;
- memberikan pesan yang ramah;
- menyediakan mode teks sebagai alternatif;
- memungkinkan pengguna mencoba kembali.

---

# 23. Accessibility Requirements

SpellingBae harus mendukung kebutuhan pengguna dengan kemampuan yang beragam.

### Requirements

- ukuran teks dapat menyesuaikan pengaturan perangkat;
- elemen interaktif memiliki label yang jelas;
- warna bukan satu-satunya indikator benar atau salah;
- feedback menggunakan kombinasi teks, simbol, animasi, dan suara;
- tombol memiliki area sentuh yang cukup besar;
- tersedia pengaturan untuk mematikan musik atau efek suara;
- animasi tidak terlalu cepat;
- instruksi dapat dibacakan;
- mode latihan teks tetap dapat digunakan tanpa mikrofon.

---

# 24. Visual and Interaction Guidelines

## Character Direction

Bae the Bee harus terlihat:

- ceria;
- suportif;
- penasaran;
- tidak menghakimi;
- ekspresif;
- mudah dikenali dalam ukuran kecil.

## Interface Direction

- warna cerah tetapi tidak berlebihan;
- satu tugas utama per layar;
- instruksi singkat;
- tombol utama terlihat jelas;
- feedback benar dan salah mudah dibedakan;
- elemen dekoratif tidak mengganggu proses belajar;
- progress divisualisasikan melalui honeycomb dan sarang.

## Tone of Voice

Gunakan bahasa:

- positif;
- singkat;
- mudah dipahami;
- memotivasi;
- tidak menghukum.

Hindari:

- “You failed”;
- “Wrong again”;
- “Bad score”;
- pesan yang membandingkan anak dengan pengguna lain.

---

# 25. Gamification Economy

## Reward Sources

Pengguna memperoleh Honey Points dari:

- menjawab dengan benar;
- menyelesaikan sesi;
- menguasai kata;
- menyelesaikan Daily Challenge;
- memperoleh badge;
- menyelesaikan Mistake Review.

## Reward Spending

Honey Points dapat digunakan untuk:

- topi dan aksesori Bae;
- warna sayap;
- dekorasi honeycomb;
- bunga;
- latar sarang;
- efek perayaan.

## Design Principle

Reward harus memperkuat proses belajar, bukan menggantikannya.

Pengguna tetap menerima progres walaupun menggunakan petunjuk atau membutuhkan beberapa percobaan. Reward tambahan diberikan untuk konsistensi dan perkembangan, bukan hanya kesempurnaan.

---

# 26. Success Metrics

## Primary Metrics

- persentase sesi yang diselesaikan;
- jumlah kata yang dipraktikkan per sesi;
- peningkatan mastery rate;
- jumlah pengguna yang kembali berlatih;
- persentase penggunaan Mistake Review;
- keberhasilan penyelesaian mode suara.

## Secondary Metrics

- rata-rata durasi sesi;
- jumlah Daily Challenge yang diselesaikan;
- jumlah kata yang dikuasai;
- penggunaan petunjuk;
- frekuensi pemutaran ulang audio;
- jumlah item yang berhasil dibuka.

## Quality Metrics

- persentase transkripsi yang menghasilkan respons;
- tingkat kegagalan perekaman;
- jumlah crash;
- waktu respons setelah pengguna selesai berbicara;
- persentase pengguna yang menolak izin mikrofon;
- persentase pengguna yang beralih ke mode teks.

---

# 27. Analytics Events

Contoh event yang dapat dicatat:

- onboarding_started;
- onboarding_completed;
- practice_started;
- practice_completed;
- word_presented;
- audio_replayed;
- hint_used;
- answer_submitted;
- answer_correct;
- answer_incorrect;
- voice_recording_started;
- voice_transcription_succeeded;
- voice_transcription_failed;
- mistake_review_started;
- word_mastered;
- badge_unlocked;
- reward_unlocked;
- daily_challenge_completed.

Analytics tidak boleh menyimpan rekaman suara atau isi sensitif yang tidak diperlukan.

---

# 28. Error Handling

## Audio Cannot Play

Pesan:

> “Bae couldn’t play the word. Let’s try again.”

Tindakan:

- tombol retry;
- fallback ke kata lain;
- tidak mengurangi skor.

## Voice Cannot Be Recognized

Pesan:

> “Bae didn’t catch that. Please try again.”

Tindakan:

- rekam ulang;
- pindah ke input teks;
- putar audio target kembali.

## Noisy Environment

Pesan:

> “It sounds a little noisy. Try moving somewhere quieter.”

## Permission Denied

Pesan:

> “Bae needs microphone access to hear you. You can still practice by typing.”

## Interrupted Recording

Perekaman dibatalkan dengan aman dan pengguna dapat mencoba kembali tanpa penalti.

---

# 29. MVP Acceptance Criteria

MVP dapat dinyatakan siap diuji ketika:

1. pengguna dapat menyelesaikan onboarding;
2. pengguna dapat memilih tingkat awal;
3. aplikasi dapat memutar audio kata;
4. pengguna dapat menyelesaikan Listen and Spell;
5. pengguna dapat menggunakan Spell Aloud;
6. pengguna dapat menggunakan Say the Word;
7. jawaban dapat dibandingkan dengan kata target;
8. feedback benar dan salah ditampilkan;
9. pengguna dapat menggunakan petunjuk;
10. Stars dan Honey Points dihitung;
11. progres kata tersimpan;
12. kata salah masuk ke Mistake Review;
13. sesi menampilkan ringkasan;
14. aplikasi tetap dapat digunakan ketika izin mikrofon ditolak;
15. rekaman suara tidak disimpan secara permanen secara default;
16. tampilan utama berfungsi pada iPhone dan iPad;
17. tidak terdapat error kritis yang menghalangi penyelesaian sesi.

---

# 30. Suggested MVP Session

Satu sesi awal terdiri dari lima kata.

### Session Composition

- dua kata baru;
- dua kata yang sedang dipelajari;
- satu kata dari Mistake Review.

### Interaction Mix

- dua Listen and Spell;
- satu Spell Aloud;
- satu Say the Word;
- satu mode campuran.

### Session Duration

Target durasi sekitar 5–10 menit agar sesuai dengan rentang fokus pengguna anak.

---

# 31. Product Roadmap

## Phase 1 — Core MVP

- onboarding;
- word audio;
- Listen and Spell;
- Spell Aloud;
- Say the Word;
- instant feedback;
- basic rewards;
- progress;
- Mistake Review.

## Phase 2 — Engagement

- Daily Challenge;
- badges;
- expanded Hive customization;
- adaptive difficulty;
- lebih banyak kategori kata;
- streak yang ramah anak.

## Phase 3 — Parent and Teacher Support

- parent dashboard;
- weekly progress summary;
- custom word list;
- classroom assignments;
- exportable learning report.

## Phase 4 — Advanced Experience

- thematic learning worlds;
- local spelling competition;
- richer pronunciation support;
- cloud synchronization;
- multiple learner profiles;
- seasonal learning events.

---

# 32. Risks and Mitigations

## Risk: Spoken Letters Are Transcribed Incorrectly

**Mitigation:**

- normalisasi nama huruf;
- tampilkan hasil transkripsi;
- sediakan retry;
- sediakan input teks;
- gunakan kata dan instruksi yang jelas.

## Risk: Noisy Environments Reduce Recognition Accuracy

**Mitigation:**

- deteksi hasil kosong;
- tampilkan saran lingkungan lebih tenang;
- batasi panjang rekaman;
- berikan mode alternatif tanpa suara.

## Risk: Gamification Distracts from Learning

**Mitigation:**

- reward diberikan setelah aktivitas belajar;
- animasi dibuat singkat;
- progress kata tetap menjadi fokus;
- aksesori tidak menghalangi layar latihan.

## Risk: Children Feel Punished by Incorrect Answers

**Mitigation:**

- gunakan bahasa suportif;
- tidak mengurangi reward yang sudah diperoleh;
- berikan petunjuk;
- izinkan percobaan ulang;
- tampilkan perkembangan, bukan hanya skor.

## Risk: Difficulty Is Not Appropriate

**Mitigation:**

- pemilihan level awal;
- adaptive difficulty;
- opsi mengubah level;
- review performa kata;
- pengujian dengan pengguna sesuai usia.

---

# 33. Open Questions

Beberapa keputusan yang perlu ditentukan pada tahap desain dan pengembangan:

1. Apakah pelafalan kata menggunakan rekaman manusia atau text-to-speech?
2. Apakah semua fitur dapat digunakan tanpa koneksi internet?
3. Berapa jumlah kata untuk versi pertama?
4. Apakah aplikasi hanya menggunakan American English atau menyediakan British English?
5. Apakah pengguna dapat memilih avatar selain Bae?
6. Apakah progres hanya disimpan lokal atau menggunakan cloud?
7. Apakah orang tua perlu membuat PIN untuk membuka Settings?
8. Berapa kali pengguna dapat mencoba sebelum jawaban ditampilkan?
9. Apakah Honey Points hanya untuk dekorasi atau juga membuka materi?
10. Apakah aplikasi mendukung beberapa profil anak pada satu perangkat?

---

# 34. Final Challenge Response

## English

**SpellingBae is a gamified English spelling-practice application that utilizes Speech and AVFoundation to play clear word-pronunciation audio, record and transcribe users’ spoken spelling, compare their responses with the correct answers, and provide immediate audio-visual feedback for elementary school students when practicing English vocabulary and spelling.**

## Bahasa Indonesia

**SpellingBae merupakan aplikasi latihan mengeja bahasa Inggris berbasis gamifikasi yang memanfaatkan Speech dan AVFoundation untuk memutar audio pelafalan kata dengan jelas, merekam dan mentranskripsikan ejaan yang diucapkan pengguna, membandingkan respons mereka dengan jawaban yang benar, serta memberikan umpan balik audio dan visual secara langsung kepada siswa sekolah dasar ketika berlatih kosakata dan ejaan bahasa Inggris.**

---

# 35. Product Summary

**SpellingBae: English Spelling** menghadirkan pengalaman belajar spelling yang menggabungkan audio, pengenalan ucapan, koreksi langsung, latihan berulang, dan reward visual.

Dengan bantuan Bae the Bee, pengguna dapat mendengarkan, mengucapkan, dan mengeja kata sambil mengembangkan sarang mereka.

> **Hear it. Say it. Spell it with your spelling bestie.**
