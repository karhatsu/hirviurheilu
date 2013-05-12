[Setup]
AppName=Hirviurheilu Offline
AppVersion=1.5.0
DefaultDirName={pf}\Hirviurheilu
DefaultGroupName=Hirviurheilu
OutputBaseFilename=HirviurheiluOffline-asennus

[Icons]
Name: "{group}\Hirviurheilu Offline"; Filename: "{app}\hirviurheilu.exe"
Name: "{group}\Uninstall Hirviurheilu Offline"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Hirviurheilu Offline"; Filename: "{app}\hirviurheilu.exe"

[Languages]
Name: "fi"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "en"; MessagesFile: "compiler:Default.isl"

[Messages]
fi.WelcomeLabel2=Olet asentamassa koneellesi ohjelmaa [name/ver]. %n%n****** TÄRKEÄÄ! ****** %nMikäli Hirviurheilu Offline on tällä hetkellä käynnissä, SULJE SE ENNEN KUIN ALOITAT PÄIVITYKSEN. (Jos olet asentamassa ohjelmaa ensimmäistä kertaa, voit jatkaa normaalisti.)
en.WelcomeLabel2=You are installing to your computer [name/ver]. %n%n****** IMPORTANT! ****** %nIn case Hirviurheilu Offline is running at the moment, CLOSE IT BEFORE YOU START UPGRADING. (If you are installing for the first time, you can ignore this warning.)

[InstallDelete]
Type: filesandordirs; Name: "{app}\lib"
Type: filesandordirs; Name: "{app}\src\public"
Type: filesandordirs; Name: "{app}\src\vendor"
Type: filesandordirs; Name: "{app}\src\tmp"
