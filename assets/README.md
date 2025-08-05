# Assets Directory Structure

This directory contains all the static assets used in the Weather App.

## 📁 Directory Structure

```
assets/
├── images/          # Background images, logos, general graphics
│   ├── backgrounds/ # Weather background images
│   ├── logos/       # App logos and branding
│   └── ui/          # UI-related images
├── icons/           # Weather icons and UI icons
│   ├── weather/     # Weather condition icons (sun, cloud, rain, etc.)
│   ├── ui/          # UI icons (search, location, settings, etc.)
│   └── app/         # App icons for different platforms
├── animations/      # Animation files
│   ├── lottie/      # Lottie animation files (.json)
│   ├── rive/        # Rive animation files (.riv)
│   └── gif/         # GIF animations
├── fonts/           # Custom fonts
│   └── weather/     # Weather-specific fonts
└── weather/         # Weather-specific assets
    ├── backgrounds/ # Weather condition backgrounds
    ├── particles/   # Particle effects (rain, snow, etc.)
    └── gradients/   # Gradient textures
```

## 🎨 Recommended Assets to Add

### Weather Icons (assets/icons/weather/)
- `clear_day.svg` - Clear sunny day
- `clear_night.svg` - Clear night with moon
- `cloudy.svg` - Cloudy weather
- `partly_cloudy_day.svg` - Partly cloudy day
- `partly_cloudy_night.svg` - Partly cloudy night
- `rain.svg` - Rainy weather
- `snow.svg` - Snow weather
- `storm.svg` - Thunderstorm
- `fog.svg` - Foggy weather
- `wind.svg` - Windy weather

### UI Icons (assets/icons/ui/)
- `search.svg` - Search icon
- `location.svg` - Location/GPS icon
- `settings.svg` - Settings icon
- `refresh.svg` - Refresh icon
- `favorite.svg` - Favorite/bookmark icon
- `back.svg` - Back arrow icon

### Background Images (assets/images/backgrounds/)
- `sunny_day.jpg` - Sunny day background
- `cloudy_day.jpg` - Cloudy day background
- `rainy_day.jpg` - Rainy day background
- `night_clear.jpg` - Clear night background
- `night_cloudy.jpg` - Cloudy night background

### Animations (assets/animations/lottie/)
- `loading_weather.json` - Loading animation
- `rain_animation.json` - Rain particle animation
- `snow_animation.json` - Snow particle animation
- `cloud_animation.json` - Moving clouds animation
- `sun_rays.json` - Sun rays animation

## 📝 Usage in pubspec.yaml

Add these assets to your `pubspec.yaml` file:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
    - assets/weather/
    - assets/fonts/

  fonts:
    - family: WeatherFont
      fonts:
        - asset: assets/fonts/weather/WeatherFont-Regular.ttf
        - asset: assets/fonts/weather/WeatherFont-Bold.ttf
          weight: 700
```

## 🎯 Usage in Code

```dart
// Loading images
Image.asset('assets/images/backgrounds/sunny_day.jpg')

// Loading icons
SvgPicture.asset('assets/icons/weather/clear_day.svg')

// Loading animations
Lottie.asset('assets/animations/lottie/rain_animation.json')

// Using custom fonts
Text(
  'Weather App',
  style: TextStyle(
    fontFamily: 'WeatherFont',
    fontWeight: FontWeight.bold,
  ),
)
```

## 📏 Recommended Sizes

### Icons
- **Weather Icons**: 64x64px, 128x128px (SVG preferred)
- **UI Icons**: 24x24px, 32x32px (SVG preferred)
- **App Icons**: 1024x1024px (PNG)

### Images
- **Background Images**: 1080x1920px or higher
- **UI Graphics**: Various sizes as needed

### Animations
- **Lottie Files**: Optimized for mobile (< 200KB recommended)
- **Rive Files**: Optimized for mobile (< 500KB recommended)

## 🎨 Color Palette Suggestion

For consistency across your weather app assets:

- **Primary Blue**: #4A90E2
- **Secondary Purple**: #6B73FF
- **Accent Yellow**: #F5A623
- **Text Dark**: #2C3E50
- **Text Light**: #FFFFFF
- **Background Light**: #F8F9FA
- **Background Dark**: #2C3E50
