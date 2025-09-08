# 🎮 Bubble Sort
A **Flutter mobile puzzle game** where players sort colored balls into matching tubes to complete levels.  
Challenge yourself with hundreds of levels featuring unique tube shapes, power-ups, and strategic gameplay mechanics.

---

## 🚀 Features

- 🎯 **5000+ Levels**: Progressive difficulty with increasing complexity
- 🏆 **Star Rating System**: Earn up to 3 stars per level based on performance
- 🔄 **Undo System**: 5 undos per level to correct mistakes
- 💡 **Hint System**: Get help finding the next move (1 hint per level)
- 💫 **Bubble Points**: In-game currency system for power-ups
- 🎁 **Welcome Bonus**: 10 free bubble points for new players
- 📺 **Rewarded Ads**: Watch ads to earn extra bubble points
- ⏭️ **Skip Levels**: Use bubble points to unlock difficult levels
- 🎨 **Dynamic Tube Shapes**: 5 different tube designs that unlock as you progress
- 📱 **Tutorial System**: Interactive tutorial for new players
- 🎵 **Background Music**: Immersive audio experience with toggle controls

---

## 🛠️ Tech Stack

- **Flutter & Dart**
- **SharedPreferences** for local data persistence
- **Google Mobile Ads** for monetization (Banner, Native, Rewarded, Interstitial)
- **Just Audio** for background music
- **Google Fonts** for custom typography
- **Custom Animations** for enhanced user experience

---

## 🎮 Game Mechanics

### Core Gameplay
- **Objective**: Sort all balls into tubes where each tube contains only one color
- **Rules**: Can only move balls to empty tubes or tubes with matching top color
- **Victory**: Complete when all tubes are either empty or contain balls of the same color

### Power-ups & Features
- **Undo Moves**: Reverse up to 5 moves per level
- **Hints**: Get suggestions for valid moves (costs 1 bubble point)
- **Level Skip**: Skip difficult levels using 5 bubble points
- **Star System**: Earn stars based on performance for level completion

### Progression System
- **Level Unlocking**: Complete levels sequentially to unlock new ones
- **Tube Shapes**: New visual tube designs every 10 levels
- **Difficulty Scaling**: More tubes and colors as you advance

---

## 📱 Key Screens

### 🏠 Home Screen
- Animated background with floating balls
- Clean menu navigation
- Bubble points display with rewards access
  ![IMG-20250908-WA0003](https://github.com/user-attachments/assets/1b12d764-e7db-4cf8-9895-1cd4cc03262d)


### 🎯 Game Screen
- Interactive tube-based puzzle interface
- Real-time move tracking and animations
- Power-up buttons (Undo, Hint, Restart)
- Skip level option for challenging puzzles
  ![IMG-20250908-WA0005](https://github.com/user-attachments/assets/edba4923-1f42-48b3-9eac-f58e4e7865f5)


### 📋 Level Selection
- Grid-based level browser with star ratings
- Lock/unlock visual indicators
- Native ads integrated between level selections
- Progress tracking across thousands of levels
  ![IMG-20250908-WA0004](https://github.com/user-attachments/assets/4a753797-1bac-4620-b2c8-a8251ce66a8d)
  ![IMG-20250908-WA0006](https://github.com/user-attachments/assets/66c67e9f-0bcb-46aa-b8c8-bdc7f4568deb)



### 🎁 Rewards Screen
- Watch rewarded video ads to earn bubble points
- Cooldown timer between ad watches
- Clear earning progress tracking
  ![IMG-20250908-WA0007](https://github.com/user-attachments/assets/9c99da59-3b11-4d50-aadc-2f57620fb481)


### ⚙️ Settings Screen
- Audio controls for background music
- Clean, minimalist interface
- Additional ad placements for monetization

---

## 💰 Monetization Strategy

### Ad Placements
- **Banner Ads**: Home screen and level selection
- **Native Ads**: Integrated within level grid and settings
- **Rewarded Ads**: Optional viewing for bubble points
- **Interstitial Ads**: Strategic placement after level completion

### In-App Economy
- **Bubble Points**: Primary currency for power-ups
- **Earning Methods**: Welcome bonus, rewarded ads, level completion
- **Spending Options**: Hints (1 point), level skips (5 points)

---

## 🎨 Visual Design

### UI/UX Features
- **Gradient Backgrounds**: Purple-blue themed color scheme
- **Glassmorphism Effects**: Modern translucent tube designs
- **Smooth Animations**: Ball movement and UI transitions
- **Responsive Design**: Adapts to different screen sizes
- **Visual Feedback**: Selection highlights, hint indicators, success animations

### Tube Shape Progression
1. **Standard** (Levels 1-10): Basic rectangular tubes
2. **Wide** (Levels 11-20): Broader tube opening
3. **Slim** (Levels 21-30): Narrow tube design
4. **Zigzag** (Levels 31-40): Unique zigzag pattern
5. **Curved** (Levels 41+): Elegant curved tube shape

---

## 📂 Project Structure

```
lib/
├── models/          # Data models (Ball, Tube, LevelData)
├── screens/         # Main app screens
├── widgets/         # Reusable UI components
├── services/        # Business logic (Ads, Audio, Points)
└── main.dart        # App entry point
```

### Key Components
- **Ball Model**: Color-based ball objects with animation support
- **Tube System**: Configurable tube shapes and capacity
- **Level Management**: Progress tracking and star ratings
- **Points Service**: Bubble points economy management
- **Ad Integration**: Multiple ad types with proper lifecycle management

---

## 📌 Summary

Bubble Sort is a **polished and engaging puzzle game** that combines strategic thinking with satisfying visual feedback. The app features a complete progression system, multiple monetization streams, and hundreds of hours of gameplay content.

Built with **Flutter best practices**, the game offers smooth performance, intuitive controls, and a rewarding player experience that keeps users engaged across thousands of challenging levels.

---
