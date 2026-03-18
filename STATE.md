# ChuperAmigo Adventure - State Handoff
Last updated: 2026-03-15e

## File
`C:\Users\super\OneDrive\Desktop\Chuperamigos-v1\Index.html`
Single-file HTML5 browser game. No build step. Open directly in browser.
Standalone desktop copy: `C:\Users\super\OneDrive\Desktop\ChuperAmigo.html`
Firebase hosted: https://chuperamigos-96679.web.app

## Dev Server
`.claude/launch.json` -> name: "Static File Server" -> port 3000
Node at `C:\Program Files\nodejs\node.exe` (NOT in system PATH)

## Edit Constraint
Edit/Write tools FAIL on OneDrive paths. ALL edits via PowerShell scripts in:
`C:\Users\super\.claude\plans\*.ps1`
Pattern: write .ps1 -> run with `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "path.ps1"`
File uses CRLF. Use `.+?` not `[^}]+` near Unicode escapes (curly braces in \u{1f9a0} break [^}]).
NEVER chain `-replace "`n","`r`n"` onto $c -- doubles all CRs. Only apply to replacement strings.
Always sync both files: Index.html AND ChuperAmigo.html AND public/index.html (Firebase hosting).

## GitHub
Remote: https://github.com/coreyalanschmidt/ChuperAmigo.git
Branch: main. Auth: PAT required (password auth deprecated by GitHub).

## Deploy to Firebase
Run: `powershell.exe -ExecutionPolicy Bypass -File "C:\Users\super\OneDrive\Desktop\Chuperamigos-v1\deploy.ps1"`
This copies Index.html -> public/index.html, then runs `firebase deploy --only hosting`.
Requires: firebase-tools installed globally (`npm install -g firebase-tools`) + `firebase login` done.

---

## Current Game State

### Tiers: 40 - DONE
40 real sea/water creatures. r values range 6-57 (strictly increasing).
Player visual + hitbox: r * 0.95 (5% smaller than tier radius).

### TIERS array (current - 40 tiers)
 0 Bacterium        r:6   col:#aaffcc  emoji:\u{1f9a0} (microbe)
 1 Copepod          r:7   col:#44eeff  emoji:\u{1fae7} (bubble) tint:#44eeff (cyan) -- SPRITE_CP=1fae7, SPRITE_TINT=#44eeff
 2 Krill            r:8   col:#ffbbdd  emoji:\u{1f990} (shrimp)
 3 Sea Slug         r:10  col:#ff66cc  emoji:\u{1f40c} (snail) tint:#ff44bb (hot pink)
 4 Frog             r:11  col:#55cc55  emoji:\u{1f438}
 5 Mantis Shrimp    r:12  col:#0099ff  emoji:\u{1f990} tint:#33aaff (blue)
 6 Jellyfish        r:13  col:#ff88cc  SVG: jellyfish.svg tint:#ff99dd
 7 Hermit Crab      r:15  col:#cc9966  emoji:\u{1f41a} (shell)
 8 Shore Crab       r:17  col:#ff5533  emoji:\u{1f980}
 9 Oyster           r:18  col:#cccccc  emoji:\u{1f9a6}
10 Coral            r:20  col:#ff6688  emoji:\u{1fab8}
11 Seahorse         r:22  col:#cc8844  SVG: seahorse.svg tint:#ddaa55
12 Clownfish        r:23  col:#ff6633  emoji:\u{1f420}
13 Sea Dragon       r:25  col:#44bbaa  SVG: sea-dragon.svg tint:#44ccaa
14 Pufferfish       r:26  col:#ffdd55  emoji:\u{1f421}
15 Squid            r:27  col:#cc88aa  emoji:\u{1f991}
16 Lobster          r:28  col:#1177ff  emoji:\u{1f99e} tint:#1177ff (blue)
17 Lionfish         r:30  col:#cc3333  SVG: porcupinefish.svg tint:#cc3322
18 Octopus          r:31  col:#cc6633  emoji:\u{1f419}
19 Sea Turtle       r:33  col:#33aa77  emoji:\u{1f422}
20 Sea Scorpion     r:34  col:#9933cc  emoji:\u{1f9a0} tint:#aa33ff (vivid purple)
21 Moray Eel        r:35  col:#226644  SVG: eel.svg tint:#336655
22 Sea Snake        r:36  col:#44aa88  emoji:\u{1f40d}
23 Barracuda        r:38  col:#4499aa  SVG: piranha.svg tint:#88ccdd
24 Marine Iguana    r:39  col:#445533  emoji:\u{1f98e}
25 Sea Otter        r:40  col:#aa7733  emoji:\u{1f9a6}
26 Saltwater Croc   r:41  col:#336644  emoji:\u{1f40a}
27 Anglerfish       r:43  col:#3355aa  SVG: angler-fish.svg tint:#6677ff
28 Nurse Shark      r:44  col:#886633  emoji:\u{1f988} tint:#886633
29 Seal             r:45  col:#667788  emoji:\u{1f9ad}
30 Dolphin          r:46  col:#4466aa  emoji:\u{1f42c}
31 Manta Ray        r:47  col:#336688  SVG: manta-ray.svg tint:#5599cc
32 Hammerhead       r:48  col:#778866  SVG: shark-jaws.svg tint:#99bb77
33 Sailfish         r:49  col:#2288cc  SVG: shark-fin.svg tint:#44aaff
34 Giant Squid      r:50  col:#882299  SVG: giant-squid.svg tint:#9933bb
35 Kraken           r:51  col:#bb2233  SVG: kraken-tentacle.svg tint:#ee3355
36 Humpback Whale   r:52  col:#667755  emoji:\u{1f40b}
37 Oarfish          r:54  col:#8899aa  SVG: sea-serpent.svg tint:#667788
38 Sperm Whale      r:55  col:#443322  emoji:\u{1f433}
39 Blue Whale       r:57  col:#2255bb  SVG: whale-tail.svg tint:#4477dd

### SVG Tiers (14 total)
Indices: 6, 11, 13, 17, 21, 23, 27, 31, 32, 33, 34, 35, 37, 39
CDN: https://api.iconify.design/game-icons/{name}.svg (CORS: *)

### Spawn / Density
MAX_CREATURES = 66
spawnCreature():
  hasPrey  = pTier > minT    (false at tier 0)
  hasAbove = pTier < maxT
  roll < 0.10 && hasPrey  -> prey (tiers below player, uniform)
  roll < 0.35             -> same tier (upgrade target)
  else                    -> threats (tiers above player)
  Window: minT = max(0, pTier-5), maxT = min(N-1, pTier+10)
Cull loop removes creatures outside window, then refills to MAX_CREATURES each frame.

### Evolution / Eat logic
  c.tierIdx === player.tierIdx -> eat & evolve immediately (+evolveBonus = 100 + tier*10)
  c.tierIdx <  player.tierIdx -> eat, score only (+10 + tier*3), no evo
  c.tierIdx >  player.tierIdx -> GAME OVER (death)

### Glow Colors
Lower + same tier enemies: #00ff88 (green)
Higher tier enemies (threats): #ff4444 (red)
No yellow glows. Arrow CSS: color:#00ff88.

### Sprite System
- Twemoji tiers: `buildTintedSprite()` draws to 144x144 canvas, source-atop tint at alpha 0.70.
  Cached in `tintedSpriteCache[tierIdx]` (separate from emojiCache).
- SVG tiers: fetched via Iconify CDN, currentColor replaced with tint hex at fetch time.
  Cached in `emojiCache['svg_' + tierIdx]`.
- No TINT PASS circle in drawCreature(). Tinting done off-screen.
- NPC glow pass 1 (wide bloom): globalAlpha = 0.85
- NPC glow pass 2 (tight core): globalAlpha = 1.0

### HUD - Single bar
- Left: SCORE + TIME (grouped in #left-stats)
- Center: `TIER N` (bold, tier-colored) + italic hunt-name subtitle below (e.g. "Bacterium")
- Right: BEST score
- tierNumEl = document.getElementById('tier-num')
- huntNameEl = document.getElementById('hunt-name')
- updateUI() sets: tierNumEl.textContent = 'TIER ' + (ti+1), tierNumEl.style.color = t.col,
                   huntNameEl.textContent = TIERS[ti].name
- triggerCelebration(): plays evolve sound only -- no flash, no evolution message shown

### Pause Screen
- Big icon: &#x23F8; (pause symbol, 64px)
- Resume hint: "Tap screen &nbsp;Â·&nbsp; Space / Esc to resume"
- Music button: id="music-btn", shows &#x1F3B5; Music: On / Off
- toggleMusic() JS uses \uD83C\uDFB5 in textContent strings (not HTML entities -- textContent strips them)
- Double-tap canvas = pause on mobile

### Audio
playChomp(): sine sweep 220->500Hz + triangle harmonic shimmer
playEvolveSound(): C5->E5->G5 triangle chime
playDeathSound(): 3 descending sine notes + triangle bass undertone

### isFishTier (current indices)
ti === 11 || ti === 12 || ti === 13 || ti === 14 ||
ti === 17 || ti === 21 || ti === 22 || ti === 23 ||
ti === 27 || ti === 28 || ti === 30 || ti === 31 ||
ti === 32 || ti === 33 || ti === 34 || ti === 37 || ti === 39

### Start Screen
Desktop: img width:65%; height:auto; top:-13%; left:50%; transform:translateX(-50%)
@media (max-aspect-ratio: 1/1) -- mobile portrait: object-fit:contain; height:auto; top:50%; transform:translateY(-50%)
DIVE IN button: positionDiveBtn() uses getBoundingClientRect(). targetY = (ir.top - cr.top) + ir.height * 0.35

---

## Firebase Leaderboard

### Database
URL: https://chuperamigos-96679-default-rtdb.firebaseio.com/scores
REST API only -- no SDK, no script tag, just fetch().
Rules (test mode -- EXPIRES 30 days from project creation):
  { "rules": { "scores": { ".read": true, ".write": true } } }
Update at: Firebase Console > Realtime Database > Rules > Publish

### JS (after bestScore declaration)
  const FB_URL = 'https://chuperamigos-96679-default-rtdb.firebaseio.com/scores';
  let pendingWinScore = 0;

### loadLeaderboard()
- async, AbortController with 8s timeout
- Fetches all scores, sorts descending, renders top 5 with medal emojis
- Called when win screen opens (pendingWinScore = winFinalScore set first)

### submitWinScore()
- async POST to Firebase with { name: initials, score: pendingWinScore }
- Disables input + button after submit, shows green "âœ“ SAVED" or red "OFFLINE"

---

## Win Screen
- No scroll -- fits on one screen
- Layout: trophy (&#127942;) -> title -> subtitle -> Time+Score row -> best line -> [Initials | Top 5] panel -> DIVE AGAIN
- Initials: 3-char max, auto-uppercase, Enter submits
- Top 5 panel: right side, bordered box, medal emojis
- Raw score removed (redundant)
- win-best: "â˜… New Best Score!" or "Best: X"
- restartGame() resets: input value+disabled, button disabled+text+background

---

## Background System

### Jellyfish (bgJellies)
- 22 decorative neon jellyfish drift upward
- drawBgJellies(ts) called in loop/winLoop/deathLoop
- HSL color cycling, alpha ~0.13-0.08, shadowBlur 9-20

### Starfish & Shells (bgDecor)
- 16 shapes (8 starfish type:0, 8 shells type:1) drift upward
- drawBgDecor(ts) called after drawBgJellies in all 3 loops
- Starfish: 5-point star outline. Shell: semicircle fan + 4 ribs.
- HSL cycling, alpha 0.09-0.13, shadowBlur 6

---

## Architecture Reference
- CSS: lines 7-81
- TIERS: lines ~203-245
- bgJellies + bgDecor arrays: before GAME STATE section
- drawBgJellies(), drawBgDecor(): just before function winLoop
- Firebase consts + loadLeaderboard + submitWinScore: after `let bestScore`
- updateUI(): sets tierNumEl text+color + huntNameEl.textContent
- drawCreature(): no TINT PASS circle
- Collision/eat logic: ~line 1334-1370
- spawnCreature(): ~line after initPlayer()
- Cull + refill loop: inside main loop(), just before creature update loop
- Score: localStorage.oceanBestFinal
- const N = TIERS.length; // 40

## CDN Sources
- Twemoji: https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/{cp}.png
- Iconify: https://api.iconify.design/game-icons/{name}.svg  (CORS: *)

## Checkpoints
- Index_checkpoint_2026-03-12.html  -- scale + density + glows + single-bar HUD + sounds + SVGs
- Index_checkpoint_2026-03-15.html  -- mobile letterbox + BCR button + README + git init
- Index_checkpoint_2026-03-15b.html -- hunt-name HUD + bgDecor (starfish/shells) + vivid sprites
- Index_checkpoint_2026-03-15c.html -- Firebase leaderboard + win screen redesign (top 5, initials, no scroll)
- Index_checkpoint_2026-03-15d.html -- Polish: death screen emoji fix, smoother movement, Firebase timeout, dead code
- Index_checkpoint_2026-03-15e.html -- Pause screen fix (emoji/mobile hint) + Copepod distinct sprite + spawn balance
- (2026-03-18) Hotfix: SPRITE_CP[1] + SPRITE_TINT[1] corrected for Copepod -- deployed to Firebase