# Isaac's Tasks

CSC 305 Todo application built with a FlutterFlow-style Flutter structure and a published web experience.

## Week 5 revision

- Adds a Zen Quotes API call (`https://zenquotes.io/api/random`)
- Displays a random inspirational quote and author on every Tasks page load
- Preserves task creation, completion, filtering, and deletion
- Persists browser tasks locally for the published demo
- Includes a profile field for hometown

## Acceptance criteria

1. A quote is requested from Zen Quotes when the Tasks page loads.
2. The quote text and author appear at the bottom of the Tasks page.
3. A friendly fallback appears if the external service is unavailable.
4. Existing task workflows continue to work.

## Run the Flutter app

```bash
flutter pub get
flutter run
```

The `docs/` folder contains the web-published version used for the assignment demo.
