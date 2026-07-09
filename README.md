📏 String Sorter by Length – Multi‑Language Edition

A versatile **string sorting tool** that arranges lines or words by their length (ascending or descending), with options to ignore spaces, handle empty strings, and process files.  
Built in **7 programming languages** – perfect for learning or integration.

## ✨ Features
- **Sort by length** – ascending (shortest first) or descending (longest first).
- **Ignore spaces** – count only non‑space characters for sorting (optional).
- **Stable sort** – preserves the original order of strings with equal length.
- **Interactive input** – type strings one by one, finish with an empty line.
- **File processing** – read lines from a text file and sort them.
- **Result display** – show sorted list with original indices.
- **Statistics** – shows min, max, average length after sorting.
- **Multi‑language** – Unicode‑aware (works with any characters).

## 🗂 Languages & Files
| Language          | File                          |
|-------------------|-------------------------------|
| Python            | `string_sorter.py`            |
| Go                | `string_sorter.go`            |
| JavaScript        | `string_sorter.js`            |
| C#                | `StringSorter.cs`             |
| Java              | `StringSorter.java`           |
| Ruby              | `string_sorter.rb`            |
| Swift             | `string_sorter.swift`         |

## 🚀 How to Run
Each file is standalone – run it with the appropriate interpreter/compiler:

| Language | Command |
|----------|---------|
| Python   | `python string_sorter.py` |
| Go       | `go run string_sorter.go` |
| JavaScript | `node string_sorter.js` |
| C#       | `dotnet run` (or `csc StringSorter.cs`) |
| Java     | `javac StringSorter.java && java StringSorter` |
| Ruby     | `ruby string_sorter.rb` |
| Swift    | `swift string_sorter.swift` |

## 📊 Example Session
=== String Sorter by Length ===

Enter strings manually

Load from file

Toggle sort order (currently: ascending)

Toggle ignore spaces (currently: off)

Show statistics

Exit
Choose: 1

Enter strings (empty line to finish):
apple
banana
pear
kiwi
[empty line]

Sorted (ascending):

pear (4)

kiwi (4)

apple (5)

banana (6)

text

## 📁 File Format
A plain text file with one string per line – all lines are sorted.

## 🔧 Technical Details
- **Length calculation** – uses `len()` or character count (Unicode-aware).
- **Ignore spaces** – when enabled, spaces are not counted for sorting.
- **Stable sort** – guaranteed by using Python's `sorted()` with key, Go's `sort.SliceStable`, etc.
- **Statistics** – computed after sorting.

## 🤝 Contributing
Add more sorting criteria (alphabetical, reverse, custom) or support for CSV input – PRs welcome!

## 📜 License
MIT – use freely.
