<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Kode OTP Verifikasi Anda</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; margin: 0; padding: 0; }
        .container { max-width: 600px; margin: 40px auto; background-color: #ffffff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .header { text-align: center; border-bottom: 1px solid #eeeeee; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: bold; color: #2c3e50; }
        .content { color: #333333; line-height: 1.6; }
        .otp-box { background-color: #f8f9fa; border: 1px dashed #ced4da; padding: 15px; text-align: center; margin: 20px 0; border-radius: 4px; }
        .otp-code { font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #0056b3; }
        .footer { text-align: center; font-size: 12px; color: #888888; margin-top: 30px; border-top: 1px solid #eeeeee; padding-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">BimsiUbsi</div>
        </div>
        <div class="content">
            <p>Halo,</p>
            <p>Anda menerima email ini karena ada permintaan untuk membuat akun Super Admin atau memverifikasi akses Anda. Berikut adalah kode OTP Anda:</p>
            
            <div class="otp-box">
                <span class="otp-code">{{ $otpCode }}</span>
            </div>

            <p>Kode ini hanya berlaku selama <strong>10 menit</strong>. Jangan bagikan kode ini kepada siapapun.</p>
            <p>Jika Anda tidak meminta kode ini, silakan abaikan email ini.</p>
            <br>
            <p>Salam hangat,<br>Tim BimsiUbsi</p>
        </div>
        <div class="footer">
            &copy; {{ date('Y') }} Sistem Informasi Bimbingan Skripsi. Semua Hak Cipta Dilindungi.
        </div>
    </div>
</body>
</html>
