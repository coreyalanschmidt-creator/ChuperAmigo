# ChuperAmigo Adventure - State Handoff
Last updated: 2026-03-18

## File
`C:\Users\super\OneDrive\Desktop\Chuperamigos-v1\Index.html`
Single-file HTML5 browser game. No build step. Open directly in browser.
Standalone desktop copy: `C:\Users\super\OneDrive\Desktop\ChuperAmigo.html`
Firebase hosted: https://chuperamigos-96679.web.app
GitHub: https://github.com/coreyalanschmidt-creator/ChuperAmigo.git

## Dev Server
`.claude/launch.json` -> name: "Static File Server" -> port 3000
Node at `C:\Program Files\nodejs\node.exe` (NOT in system PATH)

## Edit Constraint
Edit/Write tools FAIL on OneDrive paths. ALL edits via PowerShell scripts in:
`C:\Users\super\.claude\plans\*.ps1`
Pattern: write .ps1 -> run with `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "path.ps1"`
File uses CRLF. Use `.+?` not `[^}]+` near Unicode escapes.
NEVER chain `-replace` CRLF onto $c -- doubles all CRs. Only apply to replacement strings.
Always sync: Index.html AND ChuperAmigo.html AND public/index.html on every change.

## Deploy
Run: `powershell.exe -ExecutionPolicy Bypass -File "C:\Users\super\OneDrive\Desktop\Chuperamigos-v1\deploy.ps1"`
Copies Index.html -> public/index.html, then runs `firebase deploy --only hosting`.
After every deploy: update STATE.md + MEMORY.md + git commit + git push.

---

## Current Game State

### Tiers: 40 - DONE
40 real sea/water creatures. r values range 6-57 (strictly increasing).
Player visual + hitbox: r * 0.95 (5% smaller than tier radius).

### TIERS array â€” consolidated single source of truth (2026-03-18)
Each entry: { name, e, r, col, cp, tint, url }
  e:    emoji char â€” used in death screen display + canvas text CDN fallback
  cp:   Twemoji hex codepoint string (null for SVG tiers)
  tint: color override for buildTintedSprite (null = no tint applied)
  url:  Iconify SVG URL (null for Twemoji tiers)

 0 Bacterium        r:6   col:#aaffcc  cp:1f9a0  tint:null      url:null
 1 Copepod          r:7   col:#44eeff  cp:1fae7  tint:#44eeff   url:null
 2 Krill            r:8   col:#ffbbdd  cp:1f990  tint:null      url:null
 3 Sea Slug         r:10  col:#ff66cc  cp:1f40c  tint:#ff44bb   url:null
 4 Frog             r:11  col:#55cc55  cp:1f438  tint:null      url:null
 5 Mantis Shrimp    r:12  col:#0099ff  cp:1f990  tint:#33aaff   url:null
 6 Jellyfish        r:13  col:#ff88cc  cp:null   tint:#ff99dd   url:game-icons/jellyfish.svg
 7 Hermit Crab      r:15  col:#cc9966  cp:1f41a  tint:null      url:null
 8 Shore Crab       r:17  col:#ff5533  cp:1f980  tint:null      url:null
 9 Oyster           r:18  col:#cccccc  cp:1f9aa  tint:null      url:null
10 Coral            r:20  col:#ff6688  cp:1fab8  tint:null      url:null
11 Seahorse         r:22  col:#cc8844  cp:null   tint:#ddaa55   url:game-icons/seahorse.svg
12 Clownfish        r:23  col:#ff6633  cp:1f420  tint:null      url:null
13 Sea Dragon       r:25  col:#44bbaa  cp:null   tint:#44ccaa   url:game-icons/sea-dragon.svg
14 Pufferfish       r:26  col:#ffdd55  cp:1f421  tint:null      url:null
15 Squid            r:27  col:#cc88aa  cp:1f991  tint:null      url:null
16 Lobster          r:28  col:#1177ff  cp:1f99e  tint:#1177ff   url:null
17 Lionfish         r:30  col:#cc3333  cp:null   tint:#cc3322   url:game-icons/porcupinefish.svg
18 Octopus          r:31  col:#cc6633  cp:1f419  tint:null      url:null
19 Sea Turtle       r:33  col:#33aa77  cp:1f422  tint:null      url:null
20 Sea Scorpion     r:34  col:#9933cc  cp:1f982  tint:#aa33ff   url:null
21 Moray Eel        r:35  col:#226644  cp:null   tint:#336655   url:game-icons/eel.svg
22 Sea Snake        r:36  col:#44aa88  cp:1f40d  tint:null      url:null
23 Barracuda        r:38  col:#4499aa  cp:null   tint:#88ccdd   url:game-icons/piranha.svg
24 Marine Iguana    r:39  col:#445533  cp:1f98e  tint:null      url:null
25 Sea Otter        r:40  col:#aa7733  cp:1f9a6  tint:null      url:null
26 Saltwater Croc   r:41  col:#336644  cp:1f40a  tint:null      url:null
27 Anglerfish       r:43  col:#3355aa  cp:null   tint:#6677ff   url:game-icons/angler-fish.svg
28 Nurse Shark      r:44  col:#886633  cp:1f988  tint:#886633   url:null
29 Seal             r:45  col:#667788  cp:1f9ad  tint:null      url:null
30 Dolphin          r:46  col:#4466aa  cp:1f42c  tint:null      url:null
31 Manta Ray        r:47  col:#336688  cp:null   tint:#5599cc   url:game-icons/manta-ray.svg
32 Hammerhead       r:48  col:#778866  cp:null   tint:#99bb77   url:game-icons/shark-jaws.svg
33 Sailfish         r:49  col:#2288cc  cp:null   tint:#44aaff   url:game-icons/shark-fin.svg
34 Giant Squid      r:50  col:#882299  cp:null   tint:#9933bb   url:game-icons/giant-squid.svg
35 Kraken           r:51  col:#bb2233  cp:null   tint:#ee3355   url:game-icons/kraken-tentacle.svg
36 Humpback Whale   r:52  col:#667755  cp:1f40b  tint:null      url:null
37 Oarfish          r:54  col:#8899aa  cp:null   tint:#667788   url:game-icons/sea-serpent.svg
38 Sperm Whale      r:55  col:#443322  cp:1f433  tint:null      url:null
39 Blue Whale       r:57  col:#2255bb  cp:null   tint:#4477dd   url:game-icons/whale-tail.svg

SVG CDN base: https://api.iconify.design/  (CORS: *)
Twemoji CDN:  https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/

### Spawn / Density
MAX_CREATURES = 66
roll < 0.10 && hasPrey -> prey (lower tiers)
roll < 0.35            -> same tier
else                   -> threats (higher tiers)
Window: minT = max(0, pTier-5), maxT = min(N-1, pTier+10)

### Sprite System â€” CONSOLIDATED (2026-03-18)
SPRITE_CP, SPRITE_TINT, SPRITE_URL, SPRITE_EMOJI arrays REMOVED.
All data is in TIERS[i].cp / .tint / .url / .e

- getEmojiImg(tierIdx): reads t.url (SVG path) or t.cp (Twemoji path)
- getTintedImg(tierIdx, img): reads TIERS[tierIdx].tint
- prewarmEmojiCache(): iterates TIERS.length
- Canvas fallback on CDN fail: draws t.e (always correct emoji)
- To change a tier sprite: edit ONLY the TIERS entry. One place, no desync possible.

### HUD
- Left: SCORE + TIME
- Center: TIER N (bold, tier col) + italic name below
- Right: BEST
- tierNumEl, huntNameEl DOM refs. updateUI() sets both.
- triggerCelebration(): evolve sound only

### Pause Screen
- Icon: &#x23F8; | Music btn: &#x1F3B5; (HTML entities â€” NOT raw emoji bytes)
- toggleMusic() JS uses \uD83C\uDFB5 in textContent strings
- Resume hint: "Tap screen Â· Space / Esc to resume"

### Audio
playChomp(): sine sweep 220->500Hz + triangle shimmer
playEvolveSound(): C5->E5->G5 triangle chime
playDeathSound(): 3 descending sine notes + triangle bass

### isFishTier indices
11,12,13,14,17,21,22,23,27,28,30,31,32,33,34,37,39

---

## Firebase Leaderboard
DB URL: https://chuperamigos-96679-default-rtdb.firebaseio.com/scores
REST API only (fetch, no SDK). Top 5 shared across all devices.
const FB_URL declared after bestScore. loadLeaderboard() + submitWinScore() functions.
âš ï¸ Test mode rules expire 30 days from project creation â€” update in Firebase Console > Realtime DB > Rules.

## Win Screen
No scroll. Layout: trophy -> title -> subtitle -> Time+Score -> best -> [Initials|Top5] -> DIVE AGAIN
Initials: 3 chars, auto-uppercase, Enter submits. restartGame() resets form state.

---

## Background
- bgJellies (22): neon jellyfish drift upward, HSL cycling
- bgDecor (16): starfish (type:0) + shells (type:1) drift upward
- drawBgJellies() + drawBgDecor() called in all 3 render loops (loop/winLoop/deathLoop)

---

## Architecture Reference
- CSS: lines ~7-81
- TIERS array: lines ~316000 (now includes cp/tint/url/e per entry)
- Firebase consts + functions: after `let bestScore`
- bgJellies + bgDecor: before GAME STATE section
- drawBgJellies(), drawBgDecor(): just before winLoop
- getEmojiImg(), getTintedImg(): ~line 497000
- drawCreature(): ~line 495000
- spawnCreature(): after initPlayer()
- Score: localStorage.oceanBestFinal
- const N = TIERS.length; // 40

---

## Checkpoints
- Index_checkpoint_2026-03-12.html  -- scale + SVGs + HUD + sounds
- Index_checkpoint_2026-03-15.html  -- mobile fix + git init
- Index_checkpoint_2026-03-15b.html -- hunt-name HUD + bgDecor + vivid sprites
- Index_checkpoint_2026-03-15c.html -- Firebase leaderboard + win screen redesign
- Index_checkpoint_2026-03-15d.html -- Polish: death screen fix, smoother movement, Firebase timeout
- Index_checkpoint_2026-03-15e.html -- Pause screen fix + Copepod sprite + spawn balance
- Index_checkpoint_2026-03-18.html  -- TIERS consolidation (SPRITE_* arrays merged in); Copepod fixed for good