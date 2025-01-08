class TimeSheetHTML{
  final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f4f4f4;
    }
    .email-container {
      background-color: #ffffff;
      margin: 20px auto;
      padding: 20px;
      max-width: 600px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    .header {
      background-color: #87cdf8;
      padding: 20px;
      text-align: center;
    }
    .header h1 {
      color: #f38347;
      margin: 0;
      font-size: 36px;
    }
    .content {
      margin: 20px 0;
      color: #333333;
      font-size: 16px;
    }
    .content a {
      color: #00b140;
      text-decoration: none;
      font-weight: bold;
    }
    .footer {
      text-align: center;
      margin-top: 20px;
    }
    .footer img {
      height: 50px;
      margin: 10px;
    }
    .app-links img {
      width: 150px;
      margin: 10px;
    }
    #docImage {
      max-width: 100%;
      height: auto;
    }
  </style>
</head>
<body>
  <div class="email-container">
    <div class="header">
      <h1>1625 Independent People</h1>
    </div>
    <br>
    <div class="content">
      <p>Hi Ayodele,</p>
      <p>Your generated relief timesheet is here.</p>
      <p> <strong>Download</strong> the attached file to view it.</p>
      <img id ="docImage" src="https://okrstars.com/webimg/s2t/timesheet.png" alt="timesheet" />
    </div>
    
  </div>
</body>
</html>

''';
}