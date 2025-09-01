# WhatsApp Clone Blueprint

## Overview

This document outlines the blueprint for a WhatsApp clone application built with Flutter and Firebase. The app will feature real-time messaging, audio messages, and a clean user interface.

## Features

- **Chat List:** Displays a list of ongoing chats, with the most recent message and timestamp.
- **Chat Screen:** A real-time chat interface with message bubbles for sent and received messages.
- **Text Messaging:** Users can send and receive text messages.
- **Audio Messaging:** Users can record and send audio messages.
- **Read Receipts:** Messages will have read receipts to indicate when a message has been seen.
- **Contact List:** A list of contacts that the user can start a new chat with.
- **Theming:** The app will have a dark and light theme.

## Project Structure

```
lib/
├── data/
│   ├── models/
│   │   ├── chat.dart
│   │   └── message.dart
│   └── repositories/
│       └── chat_repository.dart
├── presentation/
│   ├── providers/
│   │   └── chat_provider.dart
│   ├── screens/
│   │   ├── chat_list_screen.dart
│   │   ├── chat_screen.dart
│   │   └── contact_list_screen.dart
│   └── widgets/
│       └── message_bubble.dart
├── router.dart
└── main.dart
```

## Current Task: Initial Setup

**Plan:**

1.  **Project Setup:**
    *   Initialize a new Flutter project.
    *   Set up Firebase and configure it for the app.
2.  **Data Layer:**
    *   Create `Message` and `Chat` models.
    *   Implement a `ChatRepository` to handle Firestore communication.
3.  **Presentation Layer:**
    *   Create a `ChatProvider` to manage the state of the chats and messages.
    *   Create the `ChatListScreen`, `ChatScreen`, and `ContactListScreen`.
    *   Create a `MessageBubble` widget to display messages.
4.  **Routing:**
    *   Set up routing using `go_router`.
5.  **Theming:**
    *   Implement a dark and light theme.

**Completed Steps:**

*   [x] Initialized Flutter project.
*   [x] Set up Firebase.
*   [x] Created `Message` and `Chat` models.
*   [x] Implemented `ChatRepository`.
*   [x] Created `ChatProvider`.
*   [x] Created `ChatListScreen`, `ChatScreen`, and `ContactListScreen`.
*   [x] Created `MessageBubble` widget.
*   [x] Set up routing with `go_router`.
*   [x] Implemented dark and light theme.

**Next Steps:**

*   Fix any remaining errors.
*   Implement user authentication.
*   Implement contact list functionality.
*   Add user names to chat list and chat screen.
