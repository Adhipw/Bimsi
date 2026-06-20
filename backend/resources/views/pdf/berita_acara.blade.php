<!DOCTYPE html>
<html>
<head>
    <title>Berita Acara Sidang Skripsi</title>
    <style>
        body { font-family: sans-serif; font-size: 14px; line-height: 1.5; }
        .header { text-align: center; font-weight: bold; font-size: 16px; margin-bottom: 20px; border-bottom: 2px solid #000; padding-bottom: 10px; }
        .content { margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        td { padding: 5px; vertical-align: top; }
        .ttd-container { width: 100%; margin-top: 50px; }
        .ttd-box { width: 33%; float: left; text-align: center; }
    </style>
</head>
<body>
    <div class="header">
        BERITA ACARA SIDANG {{ strtoupper($sidang->jenis_sidang) }} SKRIPSI<br>
        PROGRAM STUDI {{ strtoupper($sidang->mahasiswa->programStudi->nama ?? '') }}
    </div>

    <div class="content">
        <p>Pada hari ini, tanggal <strong>{{ $sidang->tanggal_sidang }}</strong>, bertempat di ruang <strong>{{ $sidang->ruangan->nama_ruangan ?? '-' }}</strong>, telah dilaksanakan Sidang {{ ucfirst($sidang->jenis_sidang) }} Skripsi atas mahasiswa:</p>
        
        <table>
            <tr>
                <td width="30%">Nama Mahasiswa</td>
                <td width="5%">:</td>
                <td>{{ $sidang->mahasiswa->user->name }}</td>
            </tr>
            <tr>
                <td>NIM</td>
                <td>:</td>
                <td>{{ $sidang->mahasiswa->nim }}</td>
            </tr>
            <tr>
                <td>Judul Skripsi</td>
                <td>:</td>
                <td><strong>{{ $sidang->pengajuanJudul->judul }}</strong></td>
            </tr>
            <tr>
                <td>Waktu Sidang</td>
                <td>:</td>
                <td>{{ $sidang->waktu_mulai }} s.d {{ $sidang->waktu_selesai }} WIB</td>
            </tr>
        </table>

        <p style="margin-top: 20px;">Dinyatakan lulus/tidak lulus dengan susunan Penguji sebagai berikut:</p>
        
        <table border="1">
            <tr>
                <th>No</th>
                <th>Nama Dosen Penguji</th>
                <th>Jabatan</th>
            </tr>
            @foreach($sidang->pengujis as $index => $penguji)
            <tr>
                <td style="text-align: center">{{ $index + 1 }}</td>
                <td>{{ $penguji->dosen->user->name }}</td>
                <td>{{ $penguji->peran }}</td>
            </tr>
            @endforeach
        </table>

        <div class="ttd-container">
            <div class="ttd-box">
                Penguji 1<br><br><br><br>
                <strong><u>(...............................)</u></strong>
            </div>
            <div class="ttd-box">
                Penguji 2<br><br><br><br>
                <strong><u>(...............................)</u></strong>
            </div>
            <div class="ttd-box" style="clear: both; width: 100%; margin-top: 40px">
                Mengetahui,<br>
                Ketua Program Studi<br><br><br><br>
                <strong><u>(...............................)</u></strong>
            </div>
        </div>
    </div>
</body>
</html>
