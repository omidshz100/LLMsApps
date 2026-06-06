# LLMsApps 🤖

**LLMsApps** is a beautifully designed, native iOS application built with SwiftUI that allows you to run Large Language Models (LLMs) completely offline and locally on your iPhone or iPad.

Powered by the custom [EasyLlama](https://github.com/omidshz100/EasyLlama) Swift Package and Metal GPU acceleration, this app provides lightning-fast text generation without ever sending your private data to the cloud.

## ✨ Features
- **100% Offline & Private:** Runs entirely on-device using Apple Silicon. No internet connection required.
- **Modern UI:** A stunning, Apple-native chat interface with dynamic statuses, markdown support, and haptic feedback.
- **Document Chat:** Upload text documents and ask the AI questions about them! The app automatically injects document context into your prompts.
- **GPU Accelerated:** Optimized for Apple's Metal API, giving you incredibly fast token generation times on mobile.
- **Customizable Settings:** Tweak system prompts, temperature, top-P, and token counts right inside the app settings.

## 🚀 Getting Started

Since AI models are massive (often multiple gigabytes), the `.gguf` model files are **not** included in this repository. You must download one to run the app!

### 1. Clone the Repository
```bash
git clone https://github.com/omidshz100/LLMsApps.git
cd LLMsApps
```

### 2. Download a Model
Download a `.gguf` model from HuggingFace (for example, `gemma-3-4b-it.Q4_K_M.gguf` or any other Llama/Mistral variant).

### 3. Add Model to Xcode
1. Open `LLMsApps.xcodeproj` in Xcode.
2. Drag and drop your `.gguf` file into the Xcode sidebar (make sure "Copy items if needed" and "Add to target LLMsApps" are checked).
3. Open the app, go to Settings, and type in the exact name of your model file (without the `.gguf` extension).

### 4. Build and Run!
Press **Cmd + R** to run the app on your Simulator or physical iPhone!

## 🛠️ Tech Stack
- **UI:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **AI Backend:** [EasyLlama](https://github.com/omidshz100/EasyLlama) (which wraps [swift-llama-cpp](https://github.com/pgorzelany/swift-llama-cpp))

## 📄 License
This project is open-source and available for free. Feel free to fork it, modify it, and build your own offline AI tools!
