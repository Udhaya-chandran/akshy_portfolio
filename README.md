# Akshay Kumar M - Premium Portfolio Website

A stunning, cinematic portfolio website built with Flutter for video editor and graphic designer Akshay Kumar M.

## 🎨 Design Features

- **Cinematic Editorial Design**: Dark, bold aesthetic perfect for a video editor's portfolio
- **Premium UI/UX**: Inspired by top-tier portfolio websites
- **Smooth Animations**: Fade-in slides, parallax effects, and hover states
- **Fully Responsive**: Works beautifully on all screen sizes
- **Interactive Elements**: Floating navigation, animated backgrounds, and dynamic sections

## 🚀 Tech Stack

- Flutter (Web)
- Google Fonts (Bebas Neue, Rajdhani, Space Mono, Inter)
- Custom animations and transitions
- Responsive layouts

## 📦 Installation

1. Make sure you have Flutter installed:
```bash
flutter --version
```

2. Navigate to the project directory:
```bash
cd akshay_portfolio
```

3. Get dependencies:
```bash
flutter pub get
```

4. Run the project:
```bash
flutter run -d chrome
```

For production build:
```bash
flutter build web
```

## 🎯 Sections

- **Hero Section**: Bold introduction with animated text and CTAs
- **About**: Professional background and highlights
- **Skills**: Video editing, design, and creative tools
- **Experience**: Work history at Video & Photography Studios and Trice Technologies
- **Gaming**: YouTube gaming content and streaming
- **Portfolio**: Categorized work samples
- **Education & Languages**: Academic background
- **Contact**: Contact form and information

## 🎨 Color Palette

- Primary: Cyan (#00D9FF)
- Secondary: Red (#FF6B6B)
- Background: Dark (#0A0A0A)
- Surface: Dark Grey (#1A1A1A)

## 🔧 Customization

### Adding Portfolio Items
The portfolio section uses a grid layout. To add actual portfolio items, replace the placeholder containers in `_buildPortfolioSection()` with real content.

### Changing Colors
Update the color scheme in `AkshayPortfolioApp`:
```dart
colorScheme: ColorScheme.dark(
  primary: const Color(0xFF00D9FF),
  secondary: const Color(0xFFFF6B6B),
  // ... other colors
),
```

### Adding Images
1. Create an `assets/images` folder
2. Add images to pubspec.yaml:
```yaml
flutter:
  assets:
    - assets/images/
```
3. Use `Image.asset()` or `Image.network()` in the code

### Updating Content
All text content is directly in the widgets. Search for the section you want to update and modify the text strings.

## 📱 Responsive Design

The website automatically adapts to different screen sizes:
- Desktop: Full layout with side-by-side sections
- Tablet: Adjusted spacing and font sizes
- Mobile: Stacked layouts (Note: You may want to add MediaQuery breakpoints for optimal mobile experience)

## 🌐 Deployment

### Deploy to Firebase Hosting
```bash
flutter build web
firebase init hosting
firebase deploy
```

### Deploy to GitHub Pages
```bash
flutter build web --base-href "/your-repo-name/"
```

### Deploy to Netlify
1. Build the project: `flutter build web`
2. Drag the `build/web` folder to Netlify

## 📄 License

This portfolio website is created for Akshay Kumar M.

## 🤝 Support

For any questions or support, contact:
- Email: Akshaytheking101@gmail.com
- Phone: +91 9061399383

---

**Created with ❤️ using Flutter**
