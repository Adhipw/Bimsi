<!DOCTYPE html>
<html>
<head>
    <title>SK Pembimbing Skripsi</title>
    <style>
        body { font-family: sans-serif; font-size: 14px; line-height: 1.5; }
        .header { text-align: center; font-weight: bold; font-size: 16px; margin-bottom: 20px; border-bottom: 2px solid #000; padding-bottom: 10px; }
        .content { margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        td { padding: 5px; vertical-align: top; }
        .ttd { width: 300px; float: right; margin-top: 50px; text-align: center; }
    </style>
</head>
<body>
    <div class="header">
        SURAT KEPUTUSAN KETUA PROGRAM STUDI<br>
        TENTANG PENETAPAN DOSEN PEMBIMBING SKRIPSI
    </div>

    <div class="content">
        <p>Menetapkan susunan Dosen Pembimbing Skripsi untuk mahasiswa di bawah ini:</p>
        
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
                <td>Program Studi</td>
                <td>:</td>
                <td>{{ $sidang->mahasiswa->programStudi->nama ?? '-' }}</td>
            </tr>
            <tr>
                <td>Judul Skripsi</td>
                <td>:</td>
                <td><strong>{{ $sidang->pengajuanJudul->judul }}</strong></td>
            </tr>
        </table>

        <p style="margin-top: 20px;">Dengan susunan pembimbing sebagai berikut:</p>
        
        <table border="1">
            <tr>
                <th>Peran</th>
                <th>Nama Dosen</th>
                <th>NIDN</th>
            </tr>
            @foreach($sidang->pengajuanJudul->pembimbings as $pembimbing)
            <tr>
                <td style="text-align: center">{{ $pembimbing->peran }}</td>
                <td>{{ $pembimbing->dosen->user->name }}</td>
                <td>{{ $pembimbing->dosen->nidn }}</td>
            </tr>
            @endforeach
        </table>

        <p style="margin-top: 20px;">Surat Keputusan ini berlaku sejak tanggal ditetapkan hingga selesainya proses penyusunan skripsi mahasiswa yang bersangkutan.</p>

        <div class="ttd">
            Ditetapkan di: Jakarta<br>
            Pada tanggal: {{ date('d F Y') }}<br><br><br><br>
            <strong><u>Ketua Program Studi</u></strong>
        </div>
    </div>
</body>
</html>
