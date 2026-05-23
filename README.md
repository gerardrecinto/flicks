# Flicks

![Swift](https://img.shields.io/badge/Swift-3%2B-F05138?logo=swift&logoColor=white)
![iOS 9+](https://img.shields.io/badge/iOS-9%2B-000000?logo=apple&logoColor=white)
![UIKit](https://img.shields.io/badge/UIKit-Auto%20Layout-blue)
![AFNetworking](https://img.shields.io/badge/Networking-AFNetworking-lightgrey)
![TMDb](https://img.shields.io/badge/API-TMDb-01B4E4)

![Demo](docs/assets/demo2.gif)

> UIKit movie browser that queries the TMDb API's endpoint-switchable movie lists, loading poster images through AFNetworking's `UIImageView` category with a two-pass low-to-high resolution progressive fade, backed by `MBProgressHUD` for load-state feedback.

## Features

- **Endpoint-driven view controller:** `MoviesViewController` holds a `var endpoint: String` set by the tab bar before presentation, letting a single view controller class serve both `now_playing` and `top_rated` by substituting the string directly into the TMDb URL — no subclassing required
- **MBProgressHUD load indicator:** `MBProgressHUD.showAdded(to: self.view, animated: true)` fires before the `URLSession.dataTask` and `MBProgressHUD.hide(for: self.view, animated: true)` runs in the completion handler, giving a blocking spinner during the initial fetch
- **AFNetworking image fade-in:** `MovieCell.posterView.setImageWith(_:placeholderImage:success:failure:)` checks whether `imageResponse` is `nil` — on a cache miss it sets `posterView.alpha = 0` and animates to `1.0` over 0.3 seconds via `UIView.animate`; on a cache hit it sets the image directly
- **Progressive image loading in detail view:** `DetailViewController` calls `setImageWith` twice on the same `posterImageView` — first with a `w45` thumbnail to display quickly, then inside the `success` completion block calls `setImageWith` again with the `original` resolution URL using the thumbnail as the placeholder, so the large image replaces the small one without a flash
- **UIScrollView detail layout:** `scrollView.contentSize` is explicitly set to `infoView.frame.origin.y + infoView.frame.size.height` so the overview text scrolls when it overflows the screen
- **Inline search bar filtering:** `UISearchBar.textDidChange` filters `movies: [NSDictionary]` into `filteredData` using `String.range(of:options:.caseInsensitive)` on the `"title"` key, then reloads the table — no additional network call on search input
- **Pull-to-refresh:** A `UIRefreshControl` inserted at subview index 0; its `valueChanged` action fires a new `URLSession.dataTask` to `api.themoviedb.org/3/movie/{endpoint}` and calls `endRefreshing()` in the response handler
- **Error state label:** A hidden `errorLabel` outlet is revealed (`isHidden = false`) when the `URLSessionDataTask` completion receives a non-nil `error`, giving feedback without an alert controller

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 3 |
| UI | UIKit, Auto Layout, UIScrollView |
| Networking | AFNetworking (UIImageView+AFNetworking, URLSession) |
| HUD | MBProgressHUD |
| Progress | M13ProgressSuite |
| API | TMDb v3 (`/movie/now_playing`, `/movie/top_rated`) |
| Dependencies | CocoaPods |

## Architecture

A `UITabBarController` configures two instances of `MoviesViewController` with different `endpoint` strings set before `viewDidLoad`. Each instance owns its own `URLSession` and `movies: [NSDictionary]` array. `DetailViewController` receives a single `movie: NSDictionary` via `prepare(for:sender:)` and constructs both poster URLs (`w45` and `original`) from the `poster_path` key. No shared model layer or networking singleton is used — each view controller manages its own request lifecycle independently.

## Key Implementation

**Progressive poster loading:** The two-request pattern in `DetailViewController` works because `UIImageView+AFNetworking` cancels any in-flight request when a new `setImageWith` call is made on the same image view — but only after the outer `success` block completes. Setting `alpha = 0` before the first `animate` prevents a white-flash between thumbnail and full resolution.

**`filteredData` toggle in data source methods:** Both `numberOfRowsInSection` and `cellForRowAt` check `searchBar.text!.isEmpty` and branch between `movies` and `filteredData`, keeping the full dataset intact so clearing the search bar immediately restores all results without a network round-trip.

**MBProgressHUD thread safety:** `showAdded` and `hide` are called from the `URLSession` completion handler dispatched to `OperationQueue.main`, matching MBProgressHUD's requirement that UI updates run on the main thread.

## Setup

```bash
git clone https://github.com/gerardrecinto/flicks-ios.git
cd flicks-ios
pod install
open MovieViewer.xcworkspace
```

Add your TMDb API key to `MoviesViewController.swift` before building.
