# WheelOne demo — reproducible steps

## Pre-demo (10 min before)
- [ ] `docker compose up -d` — web, redis, vision-worker, vision-api
- [ ] Confirm Rails on :3000 — open http://localhost:3000/account/visualizations
- [ ] Check `docker compose ps` — all 4 services "running" / healthy
- [ ] Open `/account/visualizations` — list loads, only real visualizations visible (no stuck/debug rows)
- [ ] Log in as demo account

## Demo flow (~3 min)
1. Show the car list (`/account/cars`). Pick a car. (10s)
2. Show the rim list (`/account/rims`). Pick a rim. (10s)
3. Navigate to `/account/visualizations`, click **Pridėti naują vizualizaciją**.
4. Select the car + rim, click **Sukurti vizualizaciją** → redirected to show page in `Apdorojama` (processing) state. (5s)
5. [wait ~90s] Status pill flips to **Paruošta**, generated image appears — no page reload.
   - Narration: "CableReady push over Action Cable — live update without polling."
6. Show the rendered image. Compare to original car + rim photos side by side.
7. Navigate back to `/account/visualizations` — new card with thumbnail visible.

## If generation fails during demo
1. Show page displays error state with red icon + **"Nepavyko sugeneruoti"**.
2. Click **"Bandyti dar kartą"** — status resets to `Ruošiama`, processing begins again.
3. Narration: "Sidekiq retries up to 5 times automatically, then hard fail with manual retry affordance."

## Kill-switch if everything breaks
- Pre-recorded screen capture at `Claude--Projects--WheelOne/demo/live_update.mov`
- Play that recording instead and narrate over it.

## Security note (if asked)
The Python → Rails callback is authenticated with HMAC-SHA256 (`X-Wheelone-Signature` header).
Unsigned or tampered requests return 401. Secret is shared via environment variable (`CALLBACK_HMAC_SECRET`).

## Index live-update note
Status pill updates for existing visualizations update live on the index via CableReady.
New rows do **not** auto-appear on the index when a visualization is created — navigate back manually after creation. This is by design (user is redirected to the show page on create).

## Sidekiq dashboard
Available at http://localhost:3000/sidekiq — check for stuck jobs in the retry/dead sets before the demo.
