# SC Launcher — сборка

Требования: Windows и установленный .NET Framework 4.x SDK/Visual Studio Build Tools.

Из каталога проекта выполните в PowerShell:

```powershell
$csc = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe'
& $csc /nologo /target:winexe /platform:anycpu /optimize+ `
  /win32manifest:app.manifest /win32icon:star-conflict.ico `
  /resource:star-conflict-logo.png,SCLogo.png `
  /resource:star-conflict.ico,SCAppIcon.ico `
  /reference:System.dll /reference:System.Core.dll `
  /reference:System.Drawing.dll /reference:System.Windows.Forms.dll `
  /reference:System.Runtime.Serialization.dll `
  /out:SC-Launcher.exe Program.cs
```

Никакие оригинальные файлы Star Conflict для сборки не нужны.
