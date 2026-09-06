# Budget App README

## Overview

Budget App is a personal finance tracker built with Swift, SwiftUI, and MVVM. It's a rebuild of an earlier version I made a couple of years ago that I wasn't fully satisfied with and never put in a repository — this version reimplements the same core idea with a cleaner architecture, tests, and proper version control from the start.

It lets you log income and expenses by category, set monthly budgets per category with progress tracking, view your current balance at a glance, and export your data as a CSV file.

**Features:**
- Add, edit, and delete transaction logs with category, amount, date, and notes.
- Track income vs. expenses independently of category.
- Set per-category monthly budgets with visual progress tracking.
- Light/dark/system appearance modes.
- CSV export via the system share sheet.
- Starting balance support for pre-existing funds.

## Architecture

The app follows MVVM: 
- Views are SwiftUI-only and contain no business logic;
- ViewModels hold state and expose actions;
- Models are plain data types.

Persistence (UserDefaults-based) is abstracted behind protocols (`LogStoring`, `BudgetStoring`, `SettingsStoring`), so ViewModels depend on an interface rather than a concrete store. This keeps the app testable and makes it easy to swap the storage mechanism later.


## Requirements

- Xcode 26 or later
- iOS 18+ deployment target
- No external dependencies — built entirely with SwiftUI and Foundation

## TODO

1. Add budgets to export
2. Add charts