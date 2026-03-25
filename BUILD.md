# SCANsat (dev branch) — Build & Deploy

## Overview

Planetary surface scanning and mapping mod. Provides biome, altimetry, slope, and resource overlay maps. Includes MechJeb integration and Unity UI assets.

## Prerequisites

- .NET SDK with .NET Framework 4.8 targeting pack
- KSP managed assemblies
- MechJeb2 DLL in KSP GameData (for SCANmechjeb project, optional)

## Setup

KSP path is configured via the KSPBuildTools NuGet package. Create or edit a `Directory.Build.props` or `.csproj.user` at the solution level:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Project>
  <PropertyGroup>
    <KSPRoot>G:\Steam\steamapps\common\Kerbal Space Program</KSPRoot>
  </PropertyGroup>
</Project>
```

Build properties are shared via:
- `SCANsat.props` — Sets `BinariesOutputRelativePath = GameData/SCANsat/Plugins`
- `SCANsat.version.props` — Version `21.1`, min KSP `1.12.3`

## Build

```powershell
cd SCANsat-dev
dotnet restore SCANsat.sln
dotnet build SCANsat.sln -c Release
```

### Individual projects

```powershell
# Main plugin only
dotnet build SCANsat/SCANsat.csproj -c Release

# MechJeb integration (requires MechJeb2.dll in GameData)
dotnet build SCANmechjeb/SCANmechjeb.csproj -c Release

# Unity assets (no KSP dependency)
dotnet build SCANsat.Unity/SCANsat.Unity.csproj -c Release
```

Output: `GameData\SCANsat\Plugins\SCANsat.dll` (auto-deployed by KSPBuildTools)

## Deploy

KSPBuildTools handles deployment to the local `GameData\SCANsat\` folder during build. Copy the whole folder to KSP:

```powershell
$KSP = "G:\Steam\steamapps\common\Kerbal Space Program"
Copy-Item "GameData\SCANsat" "$KSP\GameData\SCANsat" -Recurse -Force
```

## Deployed Files

| Path | Purpose |
|------|---------|
| `Plugins\SCANsat.dll` | Main plugin assembly |
| `Plugins\SCANsat.Unity.dll` | Unity UI components |
| `Plugins\SCANmechjeb.dll` | MechJeb integration (optional) |
| `Resources\` | UI textures, shader bundles |
| `Patches\` | ModuleManager compatibility patches |
| `Parts\` | Scanner part configs |
| `Flags\` | Flag textures |
| `Icons\` | Toolbar icons |
| `SCANsat.version` | KSP-AVC version metadata |

## Notes

- Uses `KSPBuildTools` NuGet package (v0.0.4) for build integration.
- The `SCANsat.Unity` project has `ReferenceKSPAssemblies = false` — it only depends on Unity, not KSP.
- SCANsatkethane has source code but no `.csproj` — it's not part of the active build.
- Version attributes are auto-generated from `SCANsat.version.props` via KSPBuildTools.
