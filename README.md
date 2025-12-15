# Triton

A native macOS client for [omg.lol](https://omg.lol), built with SwiftUI. Triton is a highly modular, multilayered application that brings all your omg.lol services to your desktop with a clean, native macOS experience.

<p align="center">
  <img width="722" height="902" alt="Screenshot of Triton, a native macOS client for omg.lol." src="https://github.com/user-attachments/assets/693c0517-cfbd-470e-bbf5-c417c6b8ea63" />
</p>

## Table of Contents

- [Features](#features)
  - [Statuslog](#statuslog)
  - [PURLs](#purls)
  - [Web Page](#web-page)
  - [Now Page](#now-page)
  - [Weblog](#weblog)
  - [Pics](#pics)
  - [Pastebin](#pastebin)
  - [Multiple Addresses](#multiple-addresses)
- [Install Triton](#install-triton)
- [Thanks and Acknowledgments](#thanks-and-acknowledgments)
- [App Store Distribution](#app-store-distribution)
  - [Why?](#why)
  - [What you CAN do](#what-you-can-do)
  - [Attribution Requirements (MIT License)](#attribution-requirements-mit-license)
  - [What Counts as "Substantial Portions"?](#what-counts-as-substantial-portions)

## Features

### Statuslog

Browse your timeline and post new status updates. Keep your feed clean with muting capabilities:

- Mute specific addresses to hide their updates
- Mute keywords to avoid spoilers and filter unwanted content
- All muting happens locally, giving you full control over your timeline

### PURLs

Manage your permanent URLs with ease:

- Create new PURLs
- Delete existing PURLs
- Copy PURL or as Markdown link
- Share via native Share Sheet or directly to Statuslog

### Web Page

View, edit, and publish changes to your personal omg.lol page directly from the app.

### Now Page

Keep your "now" page up to date:

- View your current now page
- Edit and publish changes instantly

### Weblog

Full-featured blog post management:

- Write new blog posts
- Edit existing entries
- Delete posts
- Copy entry URL or as Markdown link
- Open in browser
- Share via native Share Sheet or directly to Statuslog

### Pics

Manage your pictures on some.pics:

- Upload new images
- Delete pictures
- Copy photo URL, Some Pics URL, or as Markdown (link or image)
- Open in browser
- Share via native Share Sheet or directly to Statuslog

### Pastebin

Code snippet and paste management:

- Write and publish new pastes
- Edit existing snippets
- Delete pastes
- Copy paste URL, as Markdown link, or as Markdown code block
- Open in browser (public pastes)
- Share via native Share Sheet or directly to Statuslog (public pastes only)

### Multiple Addresses

Switch seamlessly between multiple omg.lol addresses, all in one app.

## Install Triton

**Download directly from GitHub Releases**

You can download the latest pre-built version of Triton directly from the [GitHub Releases page](https://github.com/otaviocc/Triton/releases). Simply download the `.zip` file from the latest release, open it, and drag OMG.app to your Applications folder. This method is useful if you prefer manual installation or don't use Homebrew.

**Install via [Brew](https://brew.sh) 🤩**

```bash
brew tap otaviocc/apps
brew install --cask triton
```

## Thanks and Acknowledgments

This project wouldn't exist without the amazing work of several people in the omg.lol community:

- **[Adam](https://social.lol/@adam)** for creating and maintaining the incredible [omg.lol](https://omg.lol) service, its comprehensive API, and excellent documentation that made building this client possible
- **[Eric](https://social.lol/@ericmwalk)** and **[Joanna](https://social.lol/@jmj)** for documenting the new [some.pics](https://some.pics) API endpoints for photo uploading and description editing, making the Pics feature integration seamless

## App Store Distribution

This project is open source under the MIT License, which means you're free to use, modify, and learn from the code. However, I ask that you **please do not submit this app (or a trivially modified version) to the Apple App Store under a different name**.

### Why?

I've invested significant time and effort into building and maintaining this app. While I'm happy to share the code with the community, having multiple identical versions of it creates:

- Confusion for users trying to find the legitimate version
- Dilution of the project's identity and reputation
- Sustainability challenges for continued development

### What you CAN do

- **Fork and learn**: Study the code, use it for educational purposes
- **Use components**: Incorporate parts of the codebase into your own apps (with attribution - see below)
- **Contribute**: Submit PRs to improve the project

### Attribution Requirements (MIT License)

If you use substantial portions of this code in your own app, the MIT License **requires** that you:

1. **Include the LICENSE file** in your repository
2. **Add attribution** in your app's About/Settings screen or license acknowledgments

**Suggested attribution format:**

```
Portions of this app are based on Triton
Copyright (c) 2025 Otávio C.
Licensed under the MIT License
https://github.com/otaviocc/Triton
```

This can typically be added in Settings → About → Licenses or a similar section where you list third-party dependencies.

### What Counts as "Substantial Portions"?

**You MUST attribute if:**

- You copied entire files or major components (>50-100 lines)
- You forked and modified the app

**Attribution is appreciated but not strictly required if:**

- You only copied small utility functions (<20 lines)
- You used the code as a reference to write your own implementation

**When in doubt:** Just add the attribution. It takes 5 minutes and respects the work.

Thank you for respecting these requests. They help ensure the project remains sustainable and benefits the community. If you're building something cool with this code, I'd love to hear about it!
