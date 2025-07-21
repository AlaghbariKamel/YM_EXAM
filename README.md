# 🚀 Swift Login App (CheckDeliveryLogin API)

A Swift-based iOS application implementing a login screen that interacts with the `CheckDeliveryLogin` API.  
This project follows **MVVM architecture** and applies design patterns to ensure a clean, maintainable, and scalable codebase.

---

## 🛠️ Technologies Used

- 🧠 **Swift** (Latest version)
- 🧰 **Xcode** (Latest production version)
- 🧩 **MVVM Architecture**
- 🌐 **URLSession** – for API communication
- 🖼️ **UIKit** – for user interface

---

## 📌 Features Implemented

- ✅ **User Authentication**  
  Login functionality with `CheckDeliveryLogin` API integration.
  
- ✅ **MVVM Architecture**  
  Clear separation of concerns: Model, View, ViewModel.
  
- ✅ **Reusable Network Layer**  
  A generic `APIClient` class using `URLSession`.
  
- ✅ **Pixel-perfect UI**  
  Designed based on the provided Figma layout.
  
- ✅ **Robust Error Handling**  
  Covers invalid credentials, API errors, and edge cases.
  
- ✅ **Localization Support**  
  Arabic language support (Language No: 2).
  
- ✅ **Git Best Practices**  
  Clean commit history with meaningful messages and atomic commits.

---

## 📱 Screenshots

> _Add your screenshots below using image links or markdown image embeds._

| Login Screen | Error Message |
|--------------|---------------|
| ![](https://via.placeholder.com/200x400) | ![](https://via.placeholder.com/200x400) |

---

## 🧱 Project Structure (MVVM)

```bash
.
├── Models/
│   └── User.swift
├── Views/
│   └── LoginViewController.swift
├── ViewModels/
│   └── LoginViewModel.swift
├── Network/
│   └── APIClient.swift
├── Resources/
│   └── Localizable.strings
└── Utilities/
    └── Extensions.swift

🚀 Getting Started

1. Clone the Repository
git clone https://github.com/AlaghbariKamel/YM_EXAM.git
cd Test_exam_kamel_alaghbari
2. Open in Xcode
open Test_exam_kamel_alaghbari.xcodeproj
3. Run the App
Select a simulator and hit Cmd + R.

🌍 Localization

Language	Code
English	en
Arabic	ar
Localization files are stored under Resources/.

📦 Dependencies

No external dependencies — uses native Swift and UIKit.

🧪 Testing

Add Unit Tests (if available)
# Navigate to the test target in Xcode
# Run tests with Cmd + U
🤝 Contribution

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

📄 License

This project is licensed under the MIT License.

📫 Contact

For questions or suggestions, feel free to reach out:

👨‍💻 Kamel Alaghbari
🌐 https://www.linkedin.com/in/kamel-alaghbari-23506982


Let me know if you want this saved as a downloadable `README.md` file or tailored with your actual GitHub repo, screenshots, or contact info.

