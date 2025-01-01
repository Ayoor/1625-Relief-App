class OtpHtml {
  final String otp;

  OtpHtml({required this.otp});

  String get htmlContent => '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OTP Verification</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .header {
            text-align: center;
            padding: 10px 0;
            font-size: 24px;
            color: #333;
        }
        .content {
            font-size: 16px;
            color: #555;
            line-height: 1.5;
            text-align: center;
        }
        .otp {
            font-size: 32px;
            color: #333;
            font-weight: bold;
            margin: 20px 0;
        }
        .footer {
            margin-top: 20px;
            font-size: 12px;
            color: #888;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">Your OTP Code</div>
        <div class="content">
            <p>Hi,</p>
            <p>Your one-time password (OTP) for verification is:</p>
            <div class="otp">$otp</div>
            <p>Please use this code within the next 10 minutes.</p>
            <p>If you did not request this code, please ignore this email.</p>
        </div>
        <div class="footer">
            <p>Thank you,</p>
            <p>The 1625 Relief App Team</p>
        </div>
    </div>
</body>
</html>
''';
}
