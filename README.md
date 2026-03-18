# ChuperAmigo Adventure

An agar.io-style ocean evolution browser game. Eat smaller creatures, avoid larger ones, evolve through 40 tiers from microscopic Bacterium to the legendary Kraken.

## How to Play

- Open `Index.html` in any modern browser — no install, no build step
- Move your cursor to guide your creature
- **Eat green creatures** (same tier or smaller) to grow your score
- **Avoid red creatures** (larger tier) — they'll eat you
- Evolve through 40 ocean tiers to reach the top

## Tiers (1–40)

Bacterium → Copepod → Mantis Shrimp → Krill → Sea Urchin → Horseshoe Crab → Jellyfish → Nudibranch → Seahorse → Pufferfish → Cuttlefish → Squid → Octopus → Lobster → Lionfish → Moray Eel → Sea Turtle → Manta Ray → Dolphin → Narwhal → Barracuda → Hammerhead → Anglerfish → Nurse Shark → Walrus → Orca → Sailfish → Giant Squid → Plesiosaur → Mosasaur → Tiger Shark → Oarfish → Great White Shark → Kraken → Humpback Whale → Megalodon → Blue Whale → Colossal Squid → Whale Shark → Leviathan

## Features

- 40 unique creature tiers with distinct sprites and colors
- 11 SVG creature sprites (Iconify game-icons CDN) with tinted rendering
- Twemoji emoji sprites for remaining tiers, color-tinted to match each creature
- Evolve sound effects (triangle wave chimes) and chomp/death audio
- HUD displays current and next tier with actual tinted sprite icons
- Responsive: desktop panel layout + mobile portrait (letterboxed)
- Score saved to localStorage

## Tech

- Single HTML file — vanilla HTML5, Canvas API, Web Audio API
- No frameworks, no build tools, no dependencies
- Twemoji CDN for emoji sprites
- Iconify CDN for SVG creature sprites
