# Flight Booking App Assignment

This repository contains a Flight Booking mobile application built using **Flutter** and **Riverpod** for state management, exactly matching the provided Dribbble UI design.

A premium, high-performance Flutter-based flight booking application featuring a modern glassmorphic design, advanced filtering, and real-time API integration. Exactly matching the provided Dribbble UI design.

## 📱 Screenshots

<img width="1206" height="2622" alt="image" src="https://github.com/user-attachments/assets/be60beb6-21fb-4674-9de3-c1438f6ec7cc" />, 
<img width="1206" height="2622" alt="image" src="https://github.com/user-attachments/assets/c30e2baa-aa88-4169-ae9f-cd1a6e652bf5" />,
<img width="1206" height="2622" alt="image" src="https://github.com/user-attachments/assets/1be5d74a-b471-493f-9ec1-b4ce9ec7344d" />
<img width="1206" height="2622" alt="image" src="https://github.com/user-attachments/assets/e5cec7e0-82e5-48eb-9d98-59306bc4cccb" />


## ✨ Features

- **Pixel-Perfect UI/UX**: Closely mimics the Dribbble design including custom Ticket Shapes, dotted flight paths, and soft drop shadows using `CustomClipper` and `BackdropFilter`.
- **Flight Search**: Dynamic search with airport autocomplete, date picker, and passenger count selector.
- **Advanced Filtering**: Filter search results by airline, price range ($0-$2000), stops, and aircraft type.
- **60FPS Optimized**: Built with native layout tools ensuring smooth performance across devices.
- **Real-time API**: Seamless integration with the Flight Booking REST API (`flight.wigian.in/flight_api.php`) for live data.
- **Interactive Details**: Comprehensive flight data including terminal, gate, class, and seat assignments.
- **Barcode Support**: SVG-based barcode rendering for professional boarding passes.

## 🧠 Thought Process & Approach

1.  **UI Breakdown**: I analyzed the Dribbble shot and separated the UI into 3 core screens: *Home*, *Search Results*, and *Flight Details*. The most complex visual widget was the "Ticket" view which I solved beautifully and efficiently using a `CustomClipper` overlay over a shadowed `PhysicalShape`/`Container`.
2.  **State Management**: I picked Riverpod (`flutter_riverpod`) because of its robustness in handling asynchronous loading states (`AsyncValue`) compared to older Provider patterns. FutureProviders elegantly handle API calls, eliminating manual `setState` or loading flags.
3.  **API Mapping**: I generated typed Dart models (`Flight`, `Airport`, `Passenger`, etc.) to parse JSON maps safely, avoiding runtime `TypeError` issues.
4.  **Mocking vs Live Data**: The structure for 'Saved Trips' has been mocked to maintain the premium UI layout. Since the provided API did not include a user-specific booking history endpoint, this section is ready for real data integration as soon as the relevant endpoint is available. **If the company requires a live integration for this section, I am ready to update it immediately with Local Storage (SQLite/SharedPrefs) or a new API endpoint.**

## 🛠️ Tech Stack

- **Framework**: Flutter (iOS/Android)
- **State Management**: `flutter_riverpod` (AsyncValue handling)
- **HTTP Client**: `http` (REST API Integration)
- **Typography & Assets**: `google_fonts`, `flutter_svg`
- **UI Components**: Shimmer (Loading states), CustomPaint (Dotted Lines).

## 🚀 Getting Started

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/ankitraaz/Webingo_flight_booking_ui.git
    cd webingoasses
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

## Prerequisites
*   Flutter SDK (^3.10.7)
*   Dart SDK

## ⏳ Time Taken
- **UI Layout & Parsing**: ~3 Hours
- **Riverpod & API Architecture**: ~2 Hours
- **Custom Widget Painting**: ~1 Hour
- **Total**: **~6 Hours**

---
Thank you for reviewing!


