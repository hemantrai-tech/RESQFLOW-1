# ResQFlow

**ResQFlow is a disaster-response coordination prototype that turns incoming text reports into grouped incidents, transparent demo triage scores, and human-approved simulated tasks.**

**What works in this repository:** a local Node.js app runs a 12-report flood exercise or accepts typed reports, extracts fields with rules by default, groups nearby reports, shows evidence and score factors, and lets an operator approve, reject, or request more information. Approval creates a simulated task only; it does not contact responders.

**The proof and the limits:** this repository is a text-based prototype with fixed campus locations and demo resources. Voice, photo, WhatsApp, SMS, satellite messaging, Gemini, production dispatch, and validated triage are not implemented here. A small handwritten sanity benchmark is included, but there is no representative accuracy result.

## Demo and pitch deck

- [Watch the silent demo video](assets/ResQFlow_demo_clean_silent.mp4)
- [View the pitch deck](assets/ResQFlow_Pitch_Deck.pdf)
- [Open the GitHub repository](https://github.com/hemantrai-tech/RESQFLOW-1)
- [Open the Base44 showcase](https://resq-flow-core.base44.app/)

The Base44 showcase is a separate app and may not behave like this repository. The demo video and deck are presentation materials; verify the features described below against this code. Deck concepts for voice, photos, SMS/offline delivery, Gemini, and satellite connectivity are plans or design claims, not working features in this Node.js repo. In the deck's roadmap, two-way SMS is marked as a next phase and satellite messaging as a later roadmap item.

## Run locally

**Requirements:** Node.js 18 or newer. No package installation is needed; the server uses Node's built-in modules.

From the project directory, run:

```sh
npm start
```

On Windows, you can also double-click `start-windows.bat`.

Open <http://127.0.0.1:3000>. Keep the terminal open while using the app; press Ctrl+C to stop the server. By default, the server binds to `127.0.0.1` on port `3000`. Set `PORT` to change the port.

The page loads Google Fonts, Leaflet, and map tiles from public services, so those visual assets need an internet connection. The API and the rule-based report flow run locally without an API key.

### Optional OpenAI extraction

By default, report extraction uses keyword and regular-expression rules in `server.js`. If `OPENAI_API_KEY` is set, the server attempts extraction through the OpenAI Chat Completions API using `gpt-4o-mini` by default. `AI_MODEL` can override the model. If the API call fails, extraction falls back to the local rules. This is not Gemini integration. Sending a report to the optional API sends its text to OpenAI; do not use real personal, medical, or emergency data.

## What you can try

1. Start the app and use the flood simulation to play the 12 scripted reports over time.
2. Submit a typed report in the page, such as `Tamil-English: Block B la water full ah iruku, 2 students stuck`.
3. Inspect the resulting incident, source reports, missing details, score factors, location, and suggested demo resource.
4. Approve, reject, or request more information. Approval records a simulated task in local state when a compatible demo team is available.
5. Reset the simulation to clear the local exercise state.

The sample reports include English, Hindi-English, and Tamil-English text, plus a deliberately conflicting “safe” report and a report with no known location. The script and map locations are fixed examples, not live incident data. User-submitted reports are limited to 500 characters.

## Rule extraction sanity benchmark

Run the no-key extraction benchmark with:

```sh
node scripts/benchmark-extraction.js
```

Current result: **10/10 exact field matches (100%)** on the small, handwritten fixture set in `benchmarks/report-extraction.json`. The set checks type, fixed location, language label, trapped-person count, immediate-danger flag, and explicit safe/conflict flag across English, Tamil-English, and Hindi-English examples. Two native-script examples are listed separately as unscored because Tamil-script and Devanagari semantic extraction are not implemented.

This is a repeatable sanity check for the current rules, not a representative or independently labelled evaluation set. The fixtures are hand-authored, small, and overlap with the supported vocabulary. Do not present 100% as real-world accuracy. A credible accuracy claim needs a larger held-out dataset labelled by fluent speakers and emergency-response reviewers, with errors reported by language and field.

## How this repository works

| Stage | Current implementation |
| --- | --- |
| Intake | Typed text in the local page, or the built-in 12-report scripted exercise |
| Extraction | Local keyword/regex rules by default; optional OpenAI extraction when configured |
| Incident grouping | Deterministic match using report type, fixed-location proximity, and time proximity |
| Triage | Fixed prototype weights, score factors shown in the app, and score bands |
| Human review | Approve, reject, or request more information through local API actions |
| Response | Demo resource recommendation and simulated task record; no external dispatch |
| Persistence | Local `data.json` file; not a production database |

The four fixed locations are Hostel Block B, Block C, Medical Centre, and Main Road. The demo has one boat team, one medical unit, and one fire unit. Locations and units are hardcoded in `server.js`.

## Prototype triage logic

The server computes a score from these configurable weights in `server.js`:

| Factor | Weight in the prototype |
| --- | ---: |
| Immediate danger | 25 |
| People trapped | 7 per person, capped at 5 |
| Vulnerable people | 15 |
| Supporting reports | 3 per report, capped at 6 |
| Recent report | 7 |
| Escalation | 10 |
| People affected | 0.5 per person, capped at 20 |

Scores are capped at 100. Labels are Critical (80+), High (60-79), Medium (35-59), and Low (below 35). These are demo weights, not validated emergency triage guidance. They have not been evaluated against a representative, expert-labelled dataset, and no accuracy or response-time claim is made.

## API

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/api/state` | Read reports, incidents, demo teams, fixed locations, and simulation status |
| `GET` | `/api/events` | Subscribe to local state changes using Server-Sent Events |
| `POST` | `/api/reports` | Extract fields from typed text and add the report to an incident |
| `POST` | `/api/simulate/start` | Start the scripted exercise |
| `POST` | `/api/simulate/reset` | Reset local demo state |
| `POST` | `/api/incidents/:id/approve` | Approve an incident and record a simulated task if a compatible unit is available |
| `POST` | `/api/incidents/:id/reject` | Record an operator rejection |
| `POST` | `/api/incidents/:id/info` | Record a request for more information |

## What's built, simulated, and planned

| Capability | Status in this repository |
| --- | --- |
| Local command-center page and map | Built; uses fixed demo locations and public map assets |
| Typed report intake | Built |
| Rule-based extraction without an API key | Built; limited keyword and regex coverage, not a validated language model |
| Tamil-English and Hindi-English demo examples | Included in the script; this does not establish broad multilingual accuracy |
| OpenAI extraction | Optional code path; requires `OPENAI_API_KEY` and internet; not required for the basic demo |
| Incident grouping and score calculation | Built as deterministic prototype logic; may misclassify or mis-group reports |
| Human approve/reject/info controls | Built; actions only change local demo state |
| Real voice, photo, WhatsApp, or SMS intake | Not built in this repo |
| Offline or satellite messaging | Not built; satellite is a roadmap concept in the deck |
| Gemini integration | Not built in this repo |
| Real responder dispatch or live team locations | Not built; resource suggestions are simulated |
| Production security, database, or validated triage | Not built |

## Repository files

| File | Purpose |
| --- | --- |
| `index.html` | Landing page and interactive demo interface |
| `server.js` | Zero-dependency local API, demo data, extraction, grouping, scoring, and simulated review actions |
| `package.json` | `npm start` script and Node.js engine requirement |
| `start-windows.bat` | Windows convenience launcher |
| `scripts/benchmark-extraction.js` | Runs the repeatable local rule extraction sanity benchmark |
| `benchmarks/report-extraction.json` | Handwritten scored benchmark fixtures |
| `benchmarks/report-extraction-unscored.json` | Native-script examples excluded from the score because those parsers are not implemented |
| `assets/ResQFlow_demo_clean_silent.mp4` | Supplied silent presentation video |
| `assets/ResQFlow_Pitch_Deck.pdf` | Supplied pitch deck |

## Limitations and safe use

- This is a hackathon prototype, not an emergency reporting or dispatch service. For emergencies in India, call [112](https://112.gov.in/).
- Do not submit personal, medical, or precise real-world emergency information. Local state is written to `data.json` without production access controls or encryption.
- The `x-operator` request header is a caller-supplied demo label, not verified identity. The app has no user authentication or roles.
- No emergency agency or responder is contacted. Recommendations, task records, locations, and teams are simulated.
- Extraction, grouping, and triage can be wrong or incomplete. A person must check the source reports and details.
- A configured OpenAI key sends submitted report text to the OpenAI API. Keep sensitive information out of this demo.
- This repo has no real-world pilot evidence, representative accuracy score, or validated triage policy. Its small sanity benchmark is not a field-performance claim.

## For judges and reviewers

The clearest way to verify the current build is to run it locally and follow the text-report flow above. The supplied video and deck explain the broader product vision, but claims in those materials should be treated as proposed or illustrative unless marked as implemented in this README and visible in this repository. The hosted Base44 showcase is separate from the code here; this repository does not currently provide a matching, publicly hosted version of the Node demo.

## Project

ResQFlow was developed as a 30-hour hackathon project by HACKERRS (individual entry) for the Research, Data & Build track. The repository contains a focused prototype and a broader product concept; it does not represent a deployed emergency service.
