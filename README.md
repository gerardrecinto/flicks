# Flicks

An iOS movie browser built with Swift and UIKit, powered by The Movie Database (TMDb) API.

## Features

- Now Playing and Top Rated movie lists via tab bar navigation
- Movie detail view with progressive image loading (low-res placeholder → full resolution)
- Search across movie titles
- Pull-to-refresh and loading state indicators
- Network error handling with user-facing messages
- Smooth image fade-in on load

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift |
| UI | UIKit, Auto Layout |
| Networking | TMDb API, AFNetworking |
| Dependencies | CocoaPods |

## Setup

```bash
git clone https://github.com/gerardrecinto/flicks.git
cd flicks
pod install
open MovieViewer.xcworkspace
```

Add your TMDb API key to the project before building.

## Demo

![Demo](https://imgur.com/a/K5bcZv1.gif)
