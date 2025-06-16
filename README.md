📱 MCSEI Mobile Application

📌 Overview

The Medical NFC Mobile App is a powerful tool that enhances healthcare accessibility and efficiency. This application allows patients and medical professionals to manage medical data securely using NFC (Near Field Communication) technology.

🚀 Features

📝 1. Medical Data Entry

Users can enter specific medical information through a simple and intuitive interface.

Fields may include: allergies, medications, chronic conditions, and emergency contact info.

🔄 2. NFC Write

The app enables users to write medical data directly to an NFC card.

Cards can be used for quick access in emergencies or during clinical visits.

📂 3. Import from JSON

Users can import medical records from a JSON file exported from the desktop version of the system.

Once imported, the data can be edited or written to the NFC card.

📥 4. NFC Read

The app supports reading medical data from NFC cards to view it on the mobile screen.

Ensures accurate data retrieval anytime.

🔐 5. OTP Verification for Radiology

To securely access sensitive radiology data, the app supports an OTP-based decryption mechanism.

After entering a valid OTP, a secure radiology image URL is decrypted and opened in the device browser.

🛡 Security Highlights

Data on NFC card is stored in encrypted format.

OTP verification ensures authorized access to sensitive radiology records.

📲 Technologies Used

Flutter for mobile development (cross-platform)

NFC integration via platform-specific APIs

Local file management for JSON read/write

HTTP client for OTP verification and secure communication


🧪 How to Test

Run the app on a device with NFC support.

Input sample medical data and tap "Write to NFC".

Scan the NFC card using "Read from NFC".

Try importing a JSON file exported from the desktop app.

Tap on the radiology section, enter OTP, and view the radiology image securely in the browser.

🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

📧 Contact

Developed by: MCSEI team

📄 License

MIT