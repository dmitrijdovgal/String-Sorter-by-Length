// string_sorter.go
package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strings"
)

type StringSorter struct {
	strings      []string
	ascending    bool
	ignoreSpaces bool
	stats        struct {
		Min, Max, Count int
		Avg             float64
	}
}

func NewStringSorter() *StringSorter {
	return &StringSorter{ascending: true, ignoreSpaces: false}
}

func (s *StringSorter) keyFunc(str string) int {
	if s.ignoreSpaces {
		return len(strings.ReplaceAll(str, " ", ""))
	}
	return len(str)
}

func (s *StringSorter) AddStrings(strs []string) {
	s.strings = append(s.strings, strs...)
}

func (s *StringSorter) Sort() {
	sort.SliceStable(s.strings, func(i, j int) bool {
		lenI := s.keyFunc(s.strings[i])
		lenJ := s.keyFunc(s.strings[j])
		if s.ascending {
			return lenI < lenJ
		}
		return lenI > lenJ
	})
}

func (s *StringSorter) ComputeStats() {
	if len(s.strings) == 0 {
		s.stats = struct{ Min, Max, Count int; Avg float64 }{0, 0, 0, 0}
		return
	}
	min := int(^uint(0) >> 1)
	max := 0
	sum := 0
	for _, str := range s.strings {
		l := s.keyFunc(str)
		if l < min {
			min = l
		}
		if l > max {
			max = l
		}
		sum += l
	}
	s.stats.Min = min
	s.stats.Max = max
	s.stats.Count = len(s.strings)
	s.stats.Avg = float64(sum) / float64(len(s.strings))
}

func (s *StringSorter) Display() {
	if len(s.strings) == 0 {
		fmt.Println("No strings to display.")
		return
	}
	for i, str := range s.strings {
		fmt.Printf("%d. %s (length: %d)\n", i+1, str, s.keyFunc(str))
	}
	s.ComputeStats()
	fmt.Printf("\nStatistics: count=%d, min=%d, max=%d, avg=%.2f\n",
		s.stats.Count, s.stats.Min, s.stats.Max, s.stats.Avg)
}

func main() {
	sorter := NewStringSorter()
	scanner := bufio.NewScanner(os.Stdin)
	fmt.Println("=== String Sorter by Length ===")
	for {
		fmt.Println("\n1. Enter strings manually")
		fmt.Println("2. Load from file")
		fmt.Printf("3. Toggle sort order (currently: %s)\n", map[bool]string{true: "ascending", false: "descending"}[sorter.ascending])
		fmt.Printf("4. Toggle ignore spaces (currently: %s)\n", map[bool]string{true: "on", false: "off"}[sorter.ignoreSpaces])
		fmt.Println("5. Show statistics")
		fmt.Println("6. Exit")
		fmt.Print("Choose: ")
		scanner.Scan()
		choice := strings.TrimSpace(scanner.Text())
		switch choice {
		case "1":
			fmt.Println("Enter strings (empty line to finish):")
			var lines []string
			for {
				scanner.Scan()
				line := scanner.Text()
				if line == "" {
					break
				}
				lines = append(lines, line)
			}
			if len(lines) > 0 {
				sorter.AddStrings(lines)
				sorter.Sort()
				fmt.Println("\nSorted strings:")
				sorter.Display()
			}
		case "2":
			fmt.Print("Enter file path: ")
			scanner.Scan()
			fname := strings.TrimSpace(scanner.Text())
			file, err := os.Open(fname)
			if err != nil {
				fmt.Println("File not found.")
				break
			}
			defer file.Close()
			var lines []string
			fileScanner := bufio.NewScanner(file)
			for fileScanner.Scan() {
				lines = append(lines, fileScanner.Text())
			}
			if len(lines) > 0 {
				sorter.AddStrings(lines)
				sorter.Sort()
				fmt.Println("\nSorted strings:")
				sorter.Display()
			}
		case "3":
			sorter.ascending = !sorter.ascending
			sorter.Sort()
			fmt.Println("Sort order toggled. Re-sorting current list.")
			sorter.Display()
		case "4":
			sorter.ignoreSpaces = !sorter.ignoreSpaces
			sorter.Sort()
			fmt.Println("Ignore spaces toggled. Re-sorting current list.")
			sorter.Display()
		case "5":
			sorter.ComputeStats()
			if sorter.stats.Count == 0 {
				fmt.Println("No strings loaded.")
			} else {
				fmt.Printf("\nStatistics: count=%d, min=%d, max=%d, avg=%.2f\n",
					sorter.stats.Count, sorter.stats.Min, sorter.stats.Max, sorter.stats.Avg)
			}
		case "6":
			fmt.Println("Goodbye!")
			return
		default:
			fmt.Println("Invalid choice.")
		}
	}
}
