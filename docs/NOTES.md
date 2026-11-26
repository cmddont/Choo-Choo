# Choo-Choo Charles — agent notes

## Game identity (Phase 0 triage)

Observed (sourced):

- Title: Choo-Choo Charles, developer/publisher Two Star Games (solo dev Gavin Eisenbeisz).
- Engine: Unreal Engine 4, gameplay in Blueprints (Wikipedia; developer interview).
- Store: Steam AppID 1766740, released 2022-12-09; also itch.io (Windows, 1.9 GB zip, "Version 1").
- Mode: single-player only. Developer FAQ (2021-10): "No" multiplayer planned for
  initial release; press coverage (Dec 2022) confirms none shipped.
- Platforms: Windows, plus later console/mobile ports (irrelevant for modding).

Unknown (needs the owner's install to record per AGENTS.md rule 5):

- Installed build id / exe SHA-256.
- UE4 engine version (check `ChooChooCharles/Binaries/Win64/*.dll` product version or the
  `.ue4` manifest) and whether the Steam build ships `steam_api64.dll` with
  `SteamAPI_InitFlat` (per networking-steam-spacewar.md, must actually run the ctypes check).

## Prior work (Phase 1 research)

Checked 2026-11-26:

- `data/directory.yaml` (full file, grep for "choo"/"charles"): no entries.
- `games/` in this repo: no folder for this game.
- GitHub issues/PRs in cranebeaker/coop-anything mentioning "charles": none (API search).
- Nexus Mods choochoocharles section: 3 mods listed, none surfaced as co-op in search
  results — needs a direct look at the mod list to confirm (unknown).

Conclusion: **Path 2, build from zero.**

## Plan sketch (Phases 2-5, subject to triage of the real install)

1. Owner copies the game install into `local/` (never touch the real install).
2. Record build id, exe SHA-256, UE4 version.
3. UE4 Blueprint game → likely tooling: UE4SS (Lua/Blueprint hooks) as the mod runtime;
   decompile with UE tooling if native hooks are needed.
4. Puppet second player + train: the game's core object is the train; question of whether
   each player drives their own train or shares one (design decision for the owner).
5. Authority: host-runs-AI model (playbook 1.2) is the simplest fit for an open-world
   single-host game; Charles ownership by host.
6. Networking: Steam Spacewar relay (AppID 480) per playbook — the game is on Steam so it
   ships a Steamworks DLL; check it exports `SteamAPI_InitFlat` first.
7. QA with the repo's tools (chaos, flight, fuzz, ownership) before any human playtest.

## Blocking needs from the owner

- The game is Windows-only; this workspace is Linux. Playtesting needs a Windows machine
  (or VM) with the game installed, plus a second copy/account for two-client tests.
- AGENTS.md rule 1: ask before downloads (UE4SS, Steamworks.NET DLL, Ghidra) — none done yet.
- Claim issue: nobody covers this game yet; AGENTS.md says open a "claim a game" issue
  before starting — needs the owner's GitHub (not connected in this session).

## Identity (recorded 2026-11-26 from the uploaded install, 2.1 GiB zip)

- Game dir: `Choo-Choo Charles/`, launcher `Obscure.exe` (internal project name Obscure).
- Main binary: `Obscure/Binaries/Win64/Obscure-Win64-Shipping.exe`
  SHA-256: df538d829af67d63c102de968235c064305e9bcc36f4b17124a9c16706aee1e5
- Launcher `Obscure.exe`
  SHA-256: b844bb048c67087d2aef5b724198f33f963a21e534146a0d1339ddc189a39111
- Engine: Unreal Engine 4.26.0 (string in shipping exe).
- Steamworks: SDK v147, `Engine/Binaries/ThirdParty/Steamworks/Steamv147/Win64/steam_api64.dll`.
- Exports checked by PE dump: has `SteamAPI_Init`, `SteamAPI_InitSafe`,
  `SteamAPI_Shutdown`, `SteamAPI_RestartAppIfNecessary`; **no** `SteamAPI_InitFlat`
  → playbook says use a proxy-DLL (steam_appid.txt / dll-hijack) relay setup, not flat-API.

## Modding implication

UE 4.26 → UE4SS supports it. All-Blueprint gameplay confirmed by engine layout
(Engine + Obscure/ content dirs). Next: install UE4SS into the local copy and check
Blueprint hooks enumerate; then Steam Spacewar relay for lobby/invites.
