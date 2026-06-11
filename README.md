# \# TaskLang++ 🗂️

# 

# A Domain-Specific Language (DSL) for task scheduling and automation, built as part of the \*\*SE2052 Programming Paradigms\*\* module at \*\*SLIIT\*\*.

# 

# TaskLang++ lets you define tasks with schedules, dependencies, and conditions in a simple, human-readable syntax — and comes with a \*\*visual UI builder\*\* and \*\*real-time email notifications\*\*.

# 

# \---

# 

# \## Features

# 

# \- \*\*Custom DSL\*\* — write task programs in a clean, readable syntax

# \- \*\*Lexer\*\* built with Flex

# \- \*\*Parser\*\* built with Bison (LALR grammar)

# \- \*\*Scheduling\*\* — daily, weekly, or one-time execution

# \- \*\*Task dependencies\*\* — `AFTER` and `BEFORE` ordering

# \- \*\*Conditional execution\*\* — `IF success` / `IF failure`

# \- \*\*Circular dependency detection\*\* — DFS-based semantic analysis

# \- \*\*Visual UI Builder\*\* — build TaskLang++ programs without typing code

# \- \*\*Run Parser from UI\*\* — connects the browser to the WSL parser via Node.js

# \- \*\*Email Notifications\*\* — real emails fire automatically at each task's scheduled time (via EmailJS)

# 

# \---

# 

# \## Language Syntax

# 

# ```

# TASK <name> {

# &#x20;   RUN "<script>"

# &#x20;   EVERY DAY AT <HH:MM>

# &#x20;   AFTER <task>

# &#x20;   IF success | failure

# }

# ```

# 

# \### Examples

# 

# \*\*Daily task:\*\*

# ```

# TASK backupDB {

# &#x20;   RUN "backup.sh"

# &#x20;   EVERY DAY AT 02:00

# }

# ```

# 

# \*\*Weekly task:\*\*

# ```

# TASK weeklyArchive {

# &#x20;   RUN "archive.sh"

# &#x20;   EVERY WEEK ON FRIDAY AT 23:00

# }

# ```

# 

# \*\*Task with dependency and condition:\*\*

# ```

# TASK sendReport {

# &#x20;   RUN "report.py"

# &#x20;   AFTER backupDB

# &#x20;   IF success

# }

# ```

# 

# \*\*One-time task:\*\*

# ```

# TASK deployApp {

# &#x20;   RUN "deploy.sh"

# &#x20;   AT 09:00

# }

# ```

# 

# \---

# 

# \## Project Structure

# 

# ```

# PP\_TaskLanguage/

# ├── src/

# │   ├── lexer.l          # Flex lexer

# │   ├── parser.y         # Bison parser + semantic analysis

# │   ├── server.js        # Node.js server (connects UI to parser)

# │   └── Makefile

# ├── tests/

# │   ├── Test1            # Basic scheduling

# │   ├── Test2            # Dependencies

# │   ├── Test3            # Weekly tasks

# │   ├── Test4            # Conditions

# │   └── Test5            # Error cases

# └── ui/

# &#x20;   └── index.html       # Visual UI builder

# ```

# 

# \---

# 

# \## Getting Started

# 

# \### Prerequisites

# 

# \- GCC

# \- Flex

# \- Bison

# \- Node.js (for the UI-parser connection)

# \- WSL (Windows Subsystem for Linux) if on Windows

# 

# \### Build

# 

# ```bash

# cd src

# make

# ```

# 

# \### Run a .tl file

# 

# ```bash

# ./tasklang ../tests/Test1

# ```

# 

# \### Run all tests

# 

# ```bash

# make test

# ```

# 

# \---

# 

# \## Visual UI Builder

# 

# Open `ui/index.html` in your browser.

# 

# \- Build tasks using the form on the left

# \- Generated TaskLang++ code appears instantly on the right

# \- Save your program as a `.tl` file

# \- Click \*\*▶ Run Parser\*\* to run your code through the parser directly from the browser

# 

# \### Connecting UI to Parser

# 

# Start the Node.js server in WSL:

# 

# ```bash

# cd src

# node server.js

# ```

# 

# Then use the \*\*▶ Run Parser\*\* button in the UI. The server listens at `http://localhost:3000`.

# 

# \---

# 

# \## Email Notifications

# 

# The UI supports automatic email notifications using \[EmailJS](https://www.emailjs.com) (free, no backend needed).

# 

# 1\. Create a free account at emailjs.com

# 2\. Set up a Gmail service and email template

# 3\. Click \*\*✉ Email Notify\*\* in the UI

# 4\. Enter your Service ID, Template ID, and Public Key

# 5\. Click \*\*Save \& Arm Notifications\*\*

# 

# Emails fire automatically when a task's scheduled time arrives while the browser tab is open.

# 

# \---

# 

# \## Sample Output

# 

# ```

# Parsing TaskLang++ input...

# 

# \--- EXECUTION START ---

# 

# Executing Task: backupDB

# &#x20; Script: backup.sh

# &#x20; Schedule: EVERY DAY AT 02:00

# 

# Executing Task: sendReport

# &#x20; Script: report.py

# &#x20; Depends on: backupDB

# &#x20; Condition: success

# 

# \--- EXECUTION COMPLETE ---

# ```

# 

# \---

# 

# \## Built With

# 

# \- \[Flex](https://github.com/westes/flex) — Lexical analysis

# \- \[Bison](https://www.gnu.org/software/bison/) — Parser generation

# \- \[EmailJS](https://www.emailjs.com) — Browser-based email sending

# \- Node.js — UI to parser bridge

# \- Vanilla HTML/CSS/JS — UI builder

# 

# \---

# 

# \## Author

# 

# \*\*Diloosha Rajapaksha\*\*  

# undergraduate at SLIIT  

# SE2052 — Programming Paradigms

# 

# \---



