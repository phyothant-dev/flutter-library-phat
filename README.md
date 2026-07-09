<div align="center">
  <img src="assets/logo.png" width="120" height="120" alt="ဖတ် Logo"/>
  <h1 align="center">ဖတ် (Phat)</h1>
  <p align="center">
    <strong>A modern ebook reader for Myanmar tech enthusiasts</strong>
  </p>
  <p align="center">
    Read. Learn. Grow.
  </p>
</div>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#build">Build</a> •
  <a href="#credits">Credits</a>
</p>

---

## About

**ဖတ်** (pronounced "Phat", meaning "read" in Burmese) is a mobile book reader built for the Myanmar developer community. It provides a curated collection of tech books — from programming and system design to AI/ML and fiction — all freely accessible in one place.

Whether you're a beginner learning HTML & CSS or an experienced developer diving into system architecture, ဖတ် has something for you.

## Features

- **📚 Curated Book Library** — Browse a growing collection of tech and fiction books tailored for Myanmar readers
- **🔍 Search & Filter** — Find books by title or author, filter by genre (Programming, System Design, AI/ML, Linux, Fiction, and more)
- **📖 Built-in PDF Reader** — Read books directly in the app with a smooth, native PDF viewer (Android Pdfium-based)
- **📑 Page Persistence** — Automatically saves your last read page — pick up where you left off
- **🔄 Pull to Refresh** — Always get the latest books from the server
- **🎨 Beautiful UI** — Clean, modern Material 3 design with Google Fonts typography
- **📱 Responsive Grid** — Adaptive card layout that looks great on any screen size
- **🌐 Offline Cache** — Book metadata is cached locally for fast loading even without internet
- **🏷️ Genre Chips** — Quickly filter books with horizontal scrollable genre chips
- **📝 Author Credits** — Learn about the authors who made these books possible

## Screenshots

| Home | Book Detail | Reader | Credits |
|------|------------|--------|---------|
| Browse books with search & genre filters | View book details & read online | Native PDF reader with page tracking | Meet the authors |

## Tech Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter** | Cross-platform mobile framework |
| **Supabase** | Backend (PostgreSQL database + Storage for PDFs & covers) |
| **Riverpod** | State management |
| **go_router** | Declarative routing |
| **flutter_pdfview** | Native Android PDF rendering (Pdfium) |
| **CachedNetworkImage** | Image caching & loading |
| **Dio** | HTTP client for PDF downloads |
| **SQLite (sqflite)** | Local metadata cache |
| **flutter_dotenv** | Environment variable management |
| **Google Fonts** | Typography (EB Garamond + Hanken Grotesk) |

## Books Available

- Programming & Web Development
- System Design & Architecture
- Linux & DevOps
- AI / Machine Learning
- Blockchain
- Fiction
- Algorithm

## Getting Started

### Prerequisites

- Flutter SDK (3.12+)
- A Supabase project with a `books` table and `covers`/`books` storage buckets

### Setup

1. Clone the repo:
   ```sh
   git clone https://github.com/phyothant-dev/flutter-library-phat.git
   cd flutter-library-phat
   ```

2. Create a `.env` file in the project root:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   ```

3. Install dependencies:
   ```sh
   flutter pub get
   ```

4. Run the app:
   ```sh
   flutter run
   ```

### Supabase Setup

Create the `books` table in your Supabase project:

```sql
create table books (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  author text not null,
  cover_url text default '',
  file_url text default '',
  description text default '',
  category text default '',
  created_at timestamptz default now()
);
```

Upload PDFs to the `books` storage bucket and cover images to the `covers` bucket, then insert book records via the Table Editor.

## Build

### Debug APK
```sh
flutter build apk --debug
```

### Release APK (with ProGuard shrinking)
```sh
flutter build apk --release
```

The release APK is built with R8/ProGuard enabled for size optimization (~76MB universal, ~30-40MB per ABI).

## Project Structure

```
lib/
├── config/          # Theme, Supabase config
├── models/          # Data models (Book, Credit)
├── pages/           # UI screens
├── providers/       # Riverpod state providers
├── services/        # API services (Supabase, local DB)
└── widgets/         # Reusable UI components
```

## Credits

This app exists thanks to the amazing authors and their contributions to the Myanmar developer community:

| Author | Role |
|--------|------|
| [Ei Maung](https://eimaung.com) | Web Developer & Author |
| [Lwin Moe Paing](https://lwinmoepaing.com) | Frontend Developer & Author |
| [Saturngod](https://github.com/saturngod) | Developer & Open Source Creator |
| [Thet Khine](https://thetkhine.medium.com) | Developer & Technical Writer |
| [Min Pyae Kyaw](https://github.com/MinPyaeKyaw) | Developer & Writer |

## License

This project is built for educational and community purposes. Book content is owned by their respective authors.

---

<div align="center">
  <p>Made with ❤️ for the Myanmar developer community</p>
  <p>
    <a href="https://github.com/phyothant-dev/flutter-library-phat">GitHub</a> •
    <a href="https://github.com/phyothant-dev/flutter-library-phat/issues">Report Issue</a>
  </p>
</div>
