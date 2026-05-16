# 📬 SMTP Parser

A lightweight SMTP protocol parser built with **Lex** and **Yacc** (Flex/Bison). This tool validates the structure of SMTP sessions — checking that commands appear in the correct order and format according to the SMTP protocol.

---

## 📖 Overview

This project implements a lexical analyzer and grammar-based parser for the SMTP protocol. It reads an SMTP session (from a file or stdin) and verifies whether the command sequence is syntactically valid.

The parser recognizes a complete SMTP conversation flow:

```
HELO → MAIL FROM → RCPT TO → DATA → Subject + Body → (.) → QUIT
```

---

## 📁 Project Structure

```
Smtp_parser/
├── lex_smtp.l    # Lexer: tokenizes SMTP commands and message content
├── parser.y      # Parser: validates grammar and command ordering
├── email.txt     # Sample valid SMTP session
└── gmail.txt     # Sample Gmail-style SMTP session
```

---

## ⚙️ How It Works

### Lexer (`lex_smtp.l`)
Identifies and returns tokens for each recognized SMTP command:

| Token             | Matches                    |
|-------------------|----------------------------|
| `TOKEN_HELO`      | `HELO <domain>`            |
| `TOKEN_MAIL_FROM` | `MAIL FROM:<address>`      |
| `TOKEN_RCPT_TO`   | `RCPT TO:<address>`        |
| `TOKEN_DATA`      | `DATA`                     |
| `TOKEN_SUBJECT`   | `Subject: <text>`          |
| `TOKEN_END_OF_DATA` | `.` (end of message body) |
| `TOKEN_QUIT`      | `QUIT`                     |
| `TOKEN_TEXT`      | Any other non-empty line   |

### Parser (`parser.y`)
Validates that the tokens appear in the correct order based on SMTP grammar rules. If any command is out of order or missing, the parser reports a descriptive syntax error and aborts.

**Grammar:**
```
smtp    → HELO MAIL_FROM RCPT_TO DATA message QUIT
message → SUBJECT body END_OF_DATA
body    → TEXT
        | body TEXT
```

---

## 🛠️ Requirements

- `flex` (Lex)
- `bison` (Yacc)
- `gcc`

Install on Ubuntu/Debian:
```bash
sudo apt install flex bison gcc
```

---

## 🚀 Build & Run

**Step 1 — Generate the parser and lexer:**
```bash
bison -d parser.y
flex lex_smtp.l
```

**Step 2 — Compile:**
```bash
gcc -o smtp_parser lex.yy.c parser.tab.c -lfl
```

**Step 3 — Run with a sample SMTP file:**
```bash
./smtp_parser < email.txt
```

**Expected output for a valid session:**
```
SMTP syntax is correct.
```

**Example output for an invalid session:**
```
Syntax Error: RCPT TO expected after MAIL FROM.
```

---

## 📄 Sample Input (`email.txt`)

```
HELO example.com
MAIL FROM:<sender@example.com>
RCPT TO:<receiver@example.com>
DATA
Subject: Hello World
This is the body of the email.
.
QUIT
```

---

## ❌ Error Handling

The parser provides meaningful error messages for common mistakes:

| Situation                              | Error Message                                      |
|----------------------------------------|----------------------------------------------------|
| Missing `MAIL FROM` after `HELO`       | `Syntax Error: MAIL FROM expected after HELO.`     |
| Missing `RCPT TO` after `MAIL FROM`    | `Syntax Error: RCPT TO expected after MAIL FROM.`  |
| Missing `DATA` after `RCPT TO`         | `Syntax Error: DATA expected after RCPT TO.`       |
| Missing subject/body after `DATA`      | `Syntax Error: Subject and body expected after DATA.` |
| Missing body after `Subject`           | `Syntax Error: Body expected after Subject.`       |
| Completely invalid structure           | `Syntax Error: Invalid SMTP command structure.`    |

---

## 📚 Technologies

- **Flex (Fast Lexical Analyzer)** — tokenizes the input stream
- **Bison (GNU Parser Generator)** — validates grammar rules
- **C** — underlying implementation language

---

## 📜 License

This project is open source. Feel free to use, modify, and distribute it.
