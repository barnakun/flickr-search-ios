# FlickrSearch iOS App

A simple iOS application built with SwiftUI that allows users to search and browse photos from Flickr.

## 📱 Features

- **Photo Search**: Search for photos using keywords
- **Master-Detail Navigation**: Browse photos in a grid, tap to view details
- **Image Zoom**: Pinch-to-zoom and pan gestures on detail view
- **Fullscreen Mode**: Tap to view images in fullscreen
- **Infinite Scroll**: Automatically loads more photos as you scroll
- **Search Persistence**: Remembers your last search term between app launches
- **Rich Photo Information**: Displays detailed metadata including owner, upload date, views, and license

## 🛠 Technical Stack

- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Networking**: URLSession with async/await
- **Image Loading**: Kingfisher
- **Persistence**: UserDefaults
- **Testing**: XCTest with mock networking layer
- **CI/CD**: GitHub Actions
- **Code Quality**: SwiftLint

## 📋 Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/barnakun/flickr-search-ios.git
cd FlickrSearch
```

### 2. Create Configuration File

The app requires a configuration file to store the Flickr API key. Create a file called `Config.swift` in the `FlickrSearch` directory:

```swift
import Foundation

struct Config {
    static let flickrAPIKey = "<your-api-key>"
}
```

**Note**: For security puposes the API key is hidden.

### 3. Add Config.swift to Xcode Project

1. Open `FlickrSearch.xcodeproj` in Xcode
2. Right-click on the `FlickrSearch` folder in the project navigator
3. Select "Add Files to 'FlickrSearch'"
4. Choose the `Config.swift` file you created
5. Make sure it's added to the FlickrSearch target

### 4. Install Dependencies

This project uses Swift Package Manager. Dependencies should be automatically resolved when you open the project in Xcode. If needed, you can manually resolve packages:

1. In Xcode, go to **File → Packages → Resolve Package Versions**
2. Wait for Kingfisher to be downloaded and integrated

### 5. Build and Run

1. Select your target device or simulator
2. Press `Cmd + R` to build and run the app

## 📂 Project Structure

```
FlickrSearch/
├── App/
│   └── FlickrSearchApp.swift        # App entry point
├── Models/
│   └── FlickrModels.swift           # Data models for Flickr API
├── Views/
│   ├── ContentView.swift            # Main search screen
│   ├── DetailView.swift             # Photo detail screen
│   └── FullScreenImageView.swift    # Fullscreen photo viewer
├── ViewModels/
│   ├── SearchViewModel.swift        # Search logic and state management
│   └── DetailViewModel.swift        # Detail view logic
├── Services/
│   └── APIService.swift             # Flickr API integration
├── Objects/
│   ├── PhotoGridItem.swift          # Grid item component
│   └── InfoRow.swift                # Information row component
├── Utilities/
│   └── Constants.swift              # App constants
├── Resources/
│   └── Assets.xcassets              # App assets
└── Configuration/
    └── Config.swift                 # API configuration (not tracked)
```

## 🧪 Testing

The project includes basic unit tests and UI tests.

## 🔄 CI/CD

The project includes a simple GitHub Actions workflow (`.github/workflows/ios.yml`) that:
- Runs SwiftLint for code quality
- Sets up the latest stable Xcode version

## 📝 API Integration

The app integrates with the Flickr API using these endpoints:
- `flickr.photos.search` - Search for photos by keyword
- `flickr.photos.getInfo` - Get detailed information about a photo

### Rate Limiting
The app implements proper error handling for API rate limits and network issues.

## 🎨 Design Decisions

### Architecture
- **MVVM Pattern**: Clean separation between UI and business logic
- **SwiftUI**: Modern declarative UI framework
- **Async/Await**: Modern concurrency for network operations

### User Experience
- **Infinite Scroll**: Seamless pagination for better browsing
- **Image Caching**: Kingfisher provides efficient image loading and caching
- **Error States**: User-friendly error messages with retry options
- **Loading States**: Visual feedback during network operations

### Performance
- **Lazy Loading**: Images are loaded on-demand
- **Memory Management**: Proper cleanup of resources
- **Efficient Networking**: Minimal API calls with smart caching

## 🔒 Security

- API keys are stored in a separate config file (not tracked in version control)
- Proper error handling prevents information leakage
- Network requests use HTTPS

## 📄 License

This project was created as a technical assessment for SimplePay Zrt.

---

**Created by**: Barnabás Kun  
**Date**: August 2025  
**Purpose**: iOS Technical Assessment for SimplePay Zrt.
