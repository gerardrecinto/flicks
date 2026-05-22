# Flicks

![Swift](https://img.shields.io/badge/Swift-3%2B-F05138?logo=swift&logoColor=white)
![iOS 9+](https://img.shields.io/badge/iOS-9%2B-000000?logo=apple&logoColor=white)
![UIKit](https://img.shields.io/badge/UIKit-Auto%20Layout-blue)
![TMDb](https://img.shields.io/badge/API-TMDb-01B4E4)

![Demo](docs/assets/demo2.gif)

iOS movie browser built with Swift and UIKit, powered by The Movie Database (TMDb) API.

## Features

- Now Playing and Top Rated movie lists via tab bar navigation
- Movie detail view with progressive image loading (low-res placeholder to full resolution)
- Search across movie titles
- Pull-to-refresh and loading state indicators
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
git clone https://github.com/gerardrecinto/flicks-ios.git
cd flicks-ios
pod install
open MovieViewer.xcworkspace
```

Add your TMDb API key before building.
