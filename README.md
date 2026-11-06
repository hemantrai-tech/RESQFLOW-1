# ResQFlow — Emergency Response Command Center Prototype

**ResQFlow turns a stream of simulated emergency reports into a live incident queue for a human operator.** It groups related reports, shows the evidence and conflicts behind an incident, calculates a transparent rule-based priority, and recommends a nearby simulated response unit. An operator must approve a response before the prototype records a simulated task.

> **Demo only:** ResQFlow is not an emergency dispatch service and must not be used to make real-world response decisions. It has no authentication, real responder integration, validated triage model, or production data store. For real emergencies in India, contact the official emergency number 112.

## Download and open the ZIP

1. Open [`RESQFLOW-1.zip`](RESQFLOW-1.zip) in this repository and choose **Download raw file** (or use the repository's green **Code → Download ZIP** button to get the whole repository).
2. In Windows, right-click the downloaded ZIP and choose **Extract All…**. In macOS, double-click the ZIP. On Linux, run `unzip RESQFLOW-1.zip`.
3. Open the extracted `RESQFLOW-1` folder.
4. On Windows, double-click `start-windows.bat`. On any platform, use the commands below.

GitHub displays ZIP files as binary downloads; it does not show their contents as a normal source-code page. The archive is valid and contains the four app files plus the Windows launcher.

## Run locally

**Requirements:** Node.js 18 or newer. No `npm install` is needed; the backend uses Node's built-in modules. An internet connection is needed for the browser's map tiles and CDN-hosted Leaflet, GSAP, and fonts.

From the extracted folder, run:

```sh
node server.js
```

Then visit <http://localhost:3000>. Keep the terminal open while using the app. Press `Ctrl+C` in that terminal to stop the server. On Windows, `start-windows.bat` starts the server and opens the browser for you.

The server binds to `127.0.0.1` by default so the unauthenticated demo API is not exposed to your local network.

## What is included

- **Multilingual demo reports:** A scripted flood scenario contains English, Hindi-English, and Tamil-English examples, alongside fire and medical reports.
- **Incident grouping:** Reports are grouped with simple type, location-distance, and time-proximity heuristics. This is not embedding-based semantic matching.
- **Explainable priority:** Server-side rules score reported danger, trapped or vulnerable people, report count, recency, escalation, and affected-person count. The displayed score is a prototype heuristic, not a validated triage standard.
- **Evidence and conflicts:** The incident view shows supporting and conflicting reports, missing information, score factors, and an event timeline.
- **Simulated resource recommendation:** It suggests the nearest available unit in the demo data with the capability associated with an incident type. Approval creates only a local simulated task.
- **Optional extraction with an LLM:** If an OpenAI API key is configured, the server requests structured extraction. Without a key, it uses local keyword rules. Priority scoring and resource recommendations remain deterministic server-side logic.
- **Live interface updates:** The browser receives state changes using Server-Sent Events.

## Optional LLM mode

The app works without an API key. To enable optional OpenAI report extraction, set the key in the shell before starting the server. Reports you submit will then be sent to the configured OpenAI API for extraction. Use only sample, non-sensitive demo reports.

PowerShell:

```powershell
$env:OPENAI_API_KEY = "your-key"
$env:AI_MODEL = "gpt-4o-mini"
node server.js
```

Command Prompt:

```bat
set OPENAI_API_KEY=your-key
set AI_MODEL=gpt-4o-mini
node server.js
```

Do not put real keys in the source files, ZIP, screenshots, or GitHub. Close the shell when finished to clear its session variables.

## Repository contents

```text
RESQFLOW-1/
├── index.html         Browser interface and visualization
├── server.js          Local HTTP API, simulation, grouping, scoring, and recommendations
├── package.json       Node.js metadata and start script
├── README.md          Setup, feature overview, and limitations
└── start-windows.bat  Windows convenience launcher
```

`data.json` is created beside `server.js` when the app saves state. It is local demo data and is not included in the repository ZIP.

## API overview

| Method and path | Purpose |
|---|---|
| `GET /api/state` | Read current reports, incidents, resources, and simulation status. |
| `GET /api/events` | Subscribe to updates using Server-Sent Events. |
| `POST /api/reports` | Extract fields from a report and add it to an incident queue. |
| `POST /api/simulate/start` | Start the scripted report scenario. |
| `POST /api/simulate/reset` | Reset the local simulation and its state. |
| `POST /api/incidents/:id/approve` | Record operator approval and create a simulated task. |
| `POST /api/incidents/:id/reject` | Record operator rejection. |
| `POST /api/incidents/:id/info` | Record a request for more information. |

## Limitations and safe use

- The app uses fixed example locations and a small, scripted set of reports and response units.
- Grouping thresholds, location matching, priority weights, and resource positions are demonstration logic, not validated operational policy.
- The server has no user authentication or role management. Keep it on localhost; do not expose it to the internet or a shared network.
- Local state is stored in `data.json`; it is not encrypted or suitable for real incident information.
- Optional LLM extraction can fail and falls back to keyword rules. It may misclassify reports or miss important details.
- Map tiles and frontend libraries load from third-party hosts.
- No benchmark results or real-world response outcomes are included.

## Project links

- **Repository:** <https://github.com/hemantrai-tech/RESQFLOW-1>
- **Live showcase:** <https://resq-flow-core.base44.app/>

