# Hospital Queue

A hospital queuing app for iPhone built with Swift and SwiftUI.

## Requirements

- Xcode 14 or later
- iOS 16+
- iPhone (no iPad/Mac target)

## How to Run

1. Open `HospitalQueue.xcodeproj` in Xcode.
2. Select an iPhone simulator or device.
3. Press Run (⌘R).

## Login (no backend)

- **Sign In:** Any email and password works.
- **Create Account:** Fill the form and tap Create Account.
- **Forgot Password:** Enter any email → Send → enter any 6 digits on OTP screen → Verify.

## Features

- **Walk-in:** Home → Emergency / ODC / Admission / Pharmacy → token → QR or View Queue Status. On Queue Status use “Simulate my turn” to test the flow → Review → Home.
- **Pre-book:** Home → Pre Book a slot → pick doctor, time and date → Book Appointment.
- **Profile:** Profile icon (top right) → Profiles, Appointments, Logout.
- **End Session:** On the token screen, toolbar → End Session to clear and go back.

## Structure

- `Shared/` – theme, buttons, fields, app state, dummy data
- `Auth/` – sign in, create account, forgot password, OTP, new password
- `Home/` – welcome, dashboard
- `Token/` – token screen, QR, queue status, your turn, review, end session
- `Navigator/` – map and amenities
- `Profile/` – profile menu, family members
- `DoctorAppointment/` – doctor list, detail, booking

All data is in-memory / UserDefaults for the assignment; no backend.
