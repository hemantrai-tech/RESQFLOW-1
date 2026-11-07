# ResQFlow — From chaos to clarity

ResQFlow is an emergency-response intelligence prototype. It turns messy, multilingual reports into deduplicated incidents with visible evidence, conflicts, deterministic triage and a human review step before a simulated task is recorded.

This refresh gives the project a long-scroll, editorial landing page inspired by the pacing and visual polish of the reference portfolio. It keeps ResQFlow’s own product story, emergency context and existing local API. The topographic landscape, connected report cards, staged incident flow and scroll reveals are original ResQFlow visuals.

## Run locally

**Requirements:** Node.js 18 or newer. No `npm install` is needed; the server uses Node's built-in modules.

On Windows, extract the project ZIP and double-click `start-windows.bat`. It opens a browser and starts the local server. On macOS or Linux, run:

```sh
npm start
```

Open <http://127.0.0.1:3000>. Keep the server terminal open while using the site; press Ctrl+C to stop it. The local service binds to `127.0.0.1` by default.

The page uses Leaflet and map tiles from public CDN services and Google Fonts. A network connection is needed for those visual assets and map tiles. The site has no map API key or account requirement.

## What the site shows

- **Long-scroll story:** multilingual report intake, field extraction, deduplication, conflict review, rule-based scoring and operator approval
- **Flood exercise:** scripted English, Hindi-English and Tamil-English reports that arrive over time
- **Evidence-backed incidents:** source reports, conflicting reports, missing details, score factors and event history
- **Deterministic priority:** the current repository server computes the score in code rather than asking the LLM to choose a priority
- **Simulated resource recommendations:** units come from local demo data; the operator’s hold action records only a simulated task
- **Interactive command center:** incoming report feed, incident queue, demo resource list and Leaflet map
- **Accessible motion:** scroll reveals, timeline progress and ambient motion respect reduced-motion settings

The product brief includes voice and image intake as goals. The current repository demo accepts text reports; it does not yet ingest voice or image uploads. Unknown details remain unconfirmed rather than being invented.

## API overview

| Method and path | Purpose |
|---|---|
| `GET /api/state` | Read reports, incidents, resources, locations and simulation status |
| `GET /api/events` | Subscribe to local state changes using Server-Sent Events |
| `POST /api/reports` | Extract available fields from a text report and add it to an incident queue |
| `POST /api/simulate/start` | Start the scripted flood exercise |
| `POST /api/simulate/reset` | Reset the local exercise and state |
| `POST /api/incidents/:id/approve` | Record approval and create a simulated task if a compatible unit is available |
| `POST /api/incidents/:id/reject` | Record an operator rejection |
| `POST /api/incidents/:id/info` | Record a request for more information |

## Triage weights in the current local demo

The repository server uses the following configurable prototype weights: immediate danger 25; trapped people 7 each (capped at five); vulnerable people 15; supporting reports 3 each (capped at six); recent report 7; escalation 10; and affected people 0.5 each (capped at twenty). Scores are capped at 100. The prototype labels scores of 80+ Critical, 60+ High, 35+ Medium, and lower scores Low. These values are demonstration logic, not a validated emergency triage policy.

## Important limitations

- This is a hackathon prototype, not a public emergency reporting or dispatch service. For real emergencies in India, call 112.
- The bundled GitHub server has no user authentication, roles, production database, encrypted storage or real responder integration. Its `x-operator` value is a fixed demo label, not verified identity.
- State is saved to a local `data.json` file. Do not submit personal, medical or precise real-world emergency information.
- All tasks and responder recommendations are simulated. No emergency service is contacted.
- Location and resource data are fixed examples. Map points are not live caller or responder locations.
- Optional LLM extraction uses the configured OpenAI API and sends submitted report text to that service. Do not enable it with sensitive reports.
- Grouping, extraction and triage can be wrong or incomplete. The operator remains responsible for assessing evidence.
- The GitHub repository's Node prototype is separate from the existing Base44 showcase. Updating this repository does not automatically change that hosted Base44 app.

## Project links

- **GitHub repository:** <https://github.com/hemantrai-tech/RESQFLOW-1>
- **Existing Base44 showcase:** <https://resq-flow-core.base44.app/>
- **Emergency services in India:** <https://112.gov.in/>

## Project record

ResQFlow was developed as a 30-hour hackathon project by HACKERRS (individual entry) for the Research, Data & Build track. The landing page presents the idea and the local flood exercise; it does not claim real-world deployment or validated outcomes.
