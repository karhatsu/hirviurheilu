[Setup]
AppName=Hirviurheilu Offline
AppVersion=1.3.1
DefaultDirName={pf}\Hirviurheilu
DefaultGroupName=Hirviurheilu
OutputBaseFilename=HirviurheiluOffline-asennus

[Icons]
Name: "{group}\Hirviurheilu Offline"; Filename: "{app}\hirviurheilu.exe"
Name: "{group}\Poista Hirviurheilu Offline"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Hirviurheilu Offline"; Filename: "{app}\hirviurheilu.exe"

[Languages]
Name: "fi"; MessagesFile: "compiler:Languages\Finnish.isl"

[InstallDelete]
Type: filesandordirs; Name: "{app}\lib"
Type: filesandordirs; Name: "{app}\src\public"
Type: filesandordirs; Name: "{app}\src\vendor"
Type: filesandordirs; Name: "{app}\src\tmp"
