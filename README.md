# HealthAge MVP

HealthAge is a home healthcare platform MVP combining a backend API, a Flutter mobile app UI, and a browser preview prototype.

## What is included

### Backend
- Express API with registration and service request endpoints
- Practitioner listing, emergency dispatch stub, and admin overview routes
- In-memory data flow for fast demoing and prototyping

### Flutter mobile app
- Patient/Family app prototype with sign in / sign up screens
- Home dashboard, service booking, live tracking, telehealth and provider views
- Mock workflows for care requests, emergency SOS, and practitioner matching

### Browser preview
- `frontend_web/index.html` is a clickable phone-frame prototype
- Includes tabs for sign in, practitioners, appointments, telehealth chat, and dispatch tracking
- Useful when Flutter is not installed locally

## Demo features and current flow

- Sign in / create account UI on the patient app
- Booking and service request UI for home visits, telehealth, emergency, and medication support
- Emergency SOS flow in the browser preview
- Practitioner list and profile navigation
- Live dispatch tracking view with animated responder progress
- Telehealth consultation screen and chat simulation

## Run the backend

```bash
cd backend
npm install
npm start
```

Then visit the API at `http://localhost:3000/`.

## Run the browser preview

Start the prototype server and open the page in your browser:

```bash
cd frontend_web
npx http-server . -p 8000
```

Then open:

```bash
http://127.0.0.1:8000/
```

If the page returns a connection error, make sure the preview server is running.

## Run the Flutter app

The Flutter app folder contains the UI source and a `pubspec.yaml` manifest.

If Flutter is installed locally:

```bash
cd frontend_flutter
flutter pub get
flutter run
```

If Flutter is not installed, use the browser preview at `frontend_web/index.html`.

## Share the prototype with colleagues

The browser prototype is a static HTML file, so it can be shared very easily.

### Fastest option: GitHub Pages
1. Create a GitHub repository for the project.
2. Upload the contents of the `frontend_web` folder to the repository.
3. Enable GitHub Pages from the repository settings.
4. Share the public URL with colleagues.

### Alternative: Google Drive / Gmail workspace
1. Upload the contents of `frontend_web` to Google Drive.
2. Open the `index.html` file in a browser or use a simple static host tool.
3. For a more polished experience, use a small static hosting service such as Netlify or Vercel.

> For a quick demo, the local preview server already works well, but GitHub Pages or Netlify is the easiest way to let others review it remotely.

## Notes and next steps

Current prototype status:
- UI screens are implemented for patient/family flows
- Auth is wired as a demo flow, but not yet connected to a persistent backend
- In-app messaging and caregiver photo upload are planned features for the next sprint
- Confirm caregiver arrival, confirm service completion, and instant rating are part of the product scope

Next priorities:
- Wire Flutter auth and service requests to the backend API
- Add persistent storage for accounts, jobs, and ratings
- Implement caregiver photo upload and dispute-proof completion evidence
- Add in-app messaging/buzz between caregiver and patient

## Verification

```bash
cd backend
npm test
```
