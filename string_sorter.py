# string_sorter.py
import sys
import os

class StringSorter:
    def __init__(self):
        self.strings = []
        self.ascending = True
        self.ignore_spaces = False
        self.stats = {}

    def set_order(self, ascending=True):
        self.ascending = ascending

    def set_ignore_spaces(self, ignore=True):
        self.ignore_spaces = ignore

    def _key_func(self, s):
        if self.ignore_spaces:
            return len(s.replace(' ', ''))
        return len(s)

    def add_strings(self, strings):
        self.strings.extend(strings)

    def sort(self):
        self.strings.sort(key=self._key_func, reverse=not self.ascending)

    def get_sorted(self):
        return self.strings

    def compute_stats(self):
        if not self.strings:
            self.stats = {'min': 0, 'max': 0, 'avg': 0, 'count': 0}
            return
        lengths = [self._key_func(s) for s in self.strings]
        self.stats = {
            'min': min(lengths),
            'max': max(lengths),
            'avg': sum(lengths) / len(lengths),
            'count': len(lengths)
        }
        return self.stats

    def display(self):
        if not self.strings:
            print("No strings to display.")
            return
        for idx, s in enumerate(self.strings, 1):
            print(f"{idx}. {s} (length: {self._key_func(s)})")
        self.compute_stats()
        st = self.stats
        print(f"\nStatistics: count={st['count']}, min={st['min']}, max={st['max']}, avg={st['avg']:.2f}")

def main():
    sorter = StringSorter()
    print("=== String Sorter by Length ===")
    while True:
        print("\n1. Enter strings manually")
        print("2. Load from file")
        print(f"3. Toggle sort order (currently: {'ascending' if sorter.ascending else 'descending'})")
        print(f"4. Toggle ignore spaces (currently: {'on' if sorter.ignore_spaces else 'off'})")
        print("5. Show statistics")
        print("6. Exit")
        choice = input("Choose: ").strip()
        if choice == '1':
            print("Enter strings (empty line to finish):")
            lines = []
            while True:
                line = input()
                if line == '':
                    break
                lines.append(line)
            if lines:
                sorter.add_strings(lines)
                sorter.sort()
                print("\nSorted strings:")
                sorter.display()
        elif choice == '2':
            fname = input("Enter file path: ").strip()
            try:
                with open(fname, 'r', encoding='utf-8') as f:
                    lines = [line.rstrip('\n') for line in f]
                if lines:
                    sorter.add_strings(lines)
                    sorter.sort()
                    print("\nSorted strings:")
                    sorter.display()
            except FileNotFoundError:
                print("File not found.")
            except Exception as e:
                print(f"Error: {e}")
        elif choice == '3':
            sorter.set_order(not sorter.ascending)
            sorter.sort()
            print("Sort order toggled. Re-sorting current list.")
            sorter.display()
        elif choice == '4':
            sorter.set_ignore_spaces(not sorter.ignore_spaces)
            sorter.sort()
            print("Ignore spaces toggled. Re-sorting current list.")
            sorter.display()
        elif choice == '5':
            sorter.compute_stats()
            st = sorter.stats
            if st['count'] == 0:
                print("No strings loaded.")
            else:
                print(f"\nStatistics: count={st['count']}, min={st['min']}, max={st['max']}, avg={st['avg']:.2f}")
        elif choice == '6':
            print("Goodbye!")
            break
        else:
            print("Invalid choice.")

if __name__ == "__main__":
    main()
