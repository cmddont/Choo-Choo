# Choo-Choo Co-op mod (work in progress)

UE4SS Lua mod for Choo-Choo Charles (UE 4.26). Goal: online co-op via a
Steamworks relay (proxy-DLL + steam_appid.txt, Spacewar AppID 480 for testing).

Layout:
- `Scripts/main.lua` — entry point: enumerate Blueprint classes, log the ones
  we need to hook (player pawn, train, Charles AI, world state).
- Install: copy `mod/` contents into the game copy at
  `Obscure/Binaries/Win64/` next to UE4SS.dll (UE4SS not downloaded yet —
  playbook rule 1: ask before downloads).

Known from identity pass: Steamworks v147 has no SteamAPI_InitFlat, so the
relay must load the game's own steam_api64.dll and forward exports
(proxy-DLL pattern), or use Steamworks.NET-style flat wrappers in Lua via
Blueprint calls instead.
