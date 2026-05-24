# Flicks

![Swift](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift&logoColor=white)
![iOS 16+](https://img.shields.io/badge/iOS-16%2B-000000?logo=apple&logoColor=white)
![UIKit](https://img.shields.io/badge/UIKit-Auto%20Layout-blue)
![TMDb](https://img.shields.io/badge/API-TMDb-01B4E4)

![Demo](docs/assets/demo2.gif)

> UIKit movie browser that queries the TMDb API's endpoint-switchable movie lists, loading poster images through URLSession (native)| Layer | Technology |
|---|---|
| Language | Swift 6.0 |
| UI | UIKit, Auto Layout, UIScrollView |
| Networking | URLSession (native)|
| HUD | MBProgressHUD |
| Progress | M13ProgressSuite |
| API | TMDb v3 (`/movie/now_playing`, `/movie/top_rated`) |
| Dependencies | CocoaPods |

## Architecture

A `UITabBarController` configures two instances of `MoviesViewController` with different `endpoint` strings set before `viewDidLoad`. Each instance owns its own `URLSession` and `movies: [NSDictionary]` array. `DetailViewController` receives a single `movie: NSDictionary` via `prepare(for:sender:)` and constructs both poster URLs (`w45` and `original`) from the `poster_path` key. No shared model layer or networking singleton is used — each view controller manages its own request lifecycle independently.

## Key Implementation

**Progressive poster loading:** The two-request pattern in `DetailViewController` works because `UIImageView+URLSession (native)