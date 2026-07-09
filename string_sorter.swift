// string_sorter.swift
import Foundation

class StringSorter {
    var strings: [String] = []
    var ascending = true
    var ignoreSpaces = false
    var stats = (min: 0, max: 0, count: 0, avg: 0.0)

    func keyFunc(_ s: String) -> Int {
        return ignoreSpaces ? s.replacingOccurrences(of: " ", with: "").count : s.count
    }

    func addStrings(_ strs: [String]) {
        strings.append(contentsOf: strs)
    }

    func sort() {
        strings.sort { (a, b) -> Bool in
            let lenA = keyFunc(a)
            let lenB = keyFunc(b)
            if ascending {
                return lenA < lenB
            } else {
                return lenA > lenB
            }
        }
    }

    func computeStats() {
        if strings.isEmpty {
            stats = (0, 0, 0, 0.0)
            return
        }
        let lengths = strings.map { keyFunc($0) }
        let sum = lengths.reduce(0, +)
        stats = (
            min: lengths.min() ?? 0,
            max: lengths.max() ?? 0,
            count: lengths.count,
            avg: Double(sum) / Double(lengths.count)
        )
    }

    func display() {
        if strings.isEmpty {
            print("No strings to display.")
            return
        }
        for (i, s) in strings.enumerated() {
            print("\(i+1). \(s) (length: \(keyFunc(s)))")
        }
        computeStats()
        print("\nStatistics: count=\(stats.count), min=\(stats.min), max=\(stats.max), avg=\(String(format: "%.2f", stats.avg))")
    }
}

func main() {
    let sorter = StringSorter()
    print("=== String Sorter by Length ===")
    while true {
        print("\n1. Enter strings manually")
        print("2. Load from file")
        print("3. Toggle sort order (currently: \(sorter.ascending ? "ascending" : "descending"))")
        print("4. Toggle ignore spaces (currently: \(sorter.ignoreSpaces ? "on" : "off"))")
        print("5. Show statistics")
        print("6. Exit")
        print("Choose: ", terminator: "")
        guard let choice = readLine()?.trimmingCharacters(in: .whitespaces) else { continue }
        switch choice {
        case "1":
            print("Enter strings (empty line to finish):")
            var lines: [String] = []
            while true {
                guard let line = readLine() else { break }
                if line.isEmpty { break }
                lines.append(line)
            }
            if !lines.isEmpty {
                sorter.addStrings(lines)
                sorter.sort()
                print("\nSorted strings:")
                sorter.display()
            }
        case "2":
            print("Enter file path: ", terminator: "")
            guard let fname = readLine()?.trimmingCharacters(in: .whitespaces) else { break }
            let fileURL = URL(fileURLWithPath: fname)
            guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
                print("File not found or unreadable.")
                break
            }
            let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
            if !lines.isEmpty {
                sorter.addStrings(lines)
                sorter.sort()
                print("\nSorted strings:")
                sorter.display()
            }
        case "3":
            sorter.ascending.toggle()
            sorter.sort()
            print("Sort order toggled. Re-sorting current list.")
            sorter.display()
        case "4":
            sorter.ignoreSpaces.toggle()
            sorter.sort()
            print("Ignore spaces toggled. Re-sorting current list.")
            sorter.display()
        case "5":
            sorter.computeStats()
            if sorter.stats.count == 0 {
                print("No strings loaded.")
            } else {
                print("\nStatistics: count=\(sorter.stats.count), min=\(sorter.stats.min), max=\(sorter.stats.max), avg=\(String(format: "%.2f", sorter.stats.avg))")
            }
        case "6":
            print("Goodbye!")
            return
        default:
            print("Invalid choice.")
        }
    }
}

main()
