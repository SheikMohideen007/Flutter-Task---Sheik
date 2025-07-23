# flutter_task

# 🔥 Flutter Firebase File Management App

A Flutter application demonstrating Firebase Authentication, file upload to Firebase Storage (images and PDFs), and real-time download & preview functionality — built with clean architecture and state management using **Provider**.

---

## 📱 Features

### ✅ Authentication
- User Sign In / Sign Up with Firebase Authentication
- Input validation (email, strong password with uppercase, lowercase, number & special character)
- SnackBar feedback for errors and success

### 📁 File Upload & Management
- Upload **images** or **PDFs** to Firebase Storage after login
- Track **upload progress** in real time
- List uploaded files with:
  - 🔍 **Preview** button:
    - Resized preview for images
    - Native PDF viewer for PDFs
  - ⬇️ **Download** button:
    - Resized image download with gallery save
    - PDF download with appropriate success message

### 🖼️ Image Resizing
- Images are resized to predefined dimensions before being previewed or downloaded (ensuring performance and consistency)

### 👤 Sign Out
- Secure Firebase logout functionality

### 🗂️ State Management
- Used **Provider** for managing state cleanly
- Separation of business logic and UI for better scalability and maintainability

---

## 📂 Folder Structure

