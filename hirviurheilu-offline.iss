[Setup]
AppName=Hirviurheilu Offline
AppVersion=1.2.0
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
Type: filesandordirs; Name: "{app}\src\vendor"