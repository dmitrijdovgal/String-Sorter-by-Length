// StringSorter.cs
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class StringSorter
{
    private List<string> strings = new List<string>();
    private bool ascending = true;
    private bool ignoreSpaces = false;
    private (int min, int max, int count, double avg) stats;

    private int KeyFunc(string s)
    {
        return ignoreSpaces ? s.Replace(" ", "").Length : s.Length;
    }

    public void AddStrings(IEnumerable<string> strs)
    {
        strings.AddRange(strs);
    }

    public void Sort()
    {
        var comparer = Comparer<string>.Create((a, b) =>
        {
            int lenA = KeyFunc(a);
            int lenB = KeyFunc(b);
            if (ascending)
                return lenA.CompareTo(lenB);
            else
                return lenB.CompareTo(lenA);
        });
        strings.Sort(comparer);
    }

    public void ComputeStats()
    {
        if (strings.Count == 0)
        {
            stats = (0, 0, 0, 0);
            return;
        }
        var lengths = strings.Select(s => KeyFunc(s)).ToList();
        stats.min = lengths.Min();
        stats.max = lengths.Max();
        stats.count = lengths.Count;
        stats.avg = lengths.Average();
    }

    public void Display()
    {
        if (strings.Count == 0)
        {
            Console.WriteLine("No strings to display.");
            return;
        }
        for (int i = 0; i < strings.Count; i++)
        {
            Console.WriteLine($"{i+1}. {strings[i]} (length: {KeyFunc(strings[i])})");
        }
        ComputeStats();
        Console.WriteLine($"\nStatistics: count={stats.count}, min={stats.min}, max={stats.max}, avg={stats.avg:F2}");
    }

    static void Main()
    {
        var sorter = new StringSorter();
        Console.WriteLine("=== String Sorter by Length ===");
        while (true)
        {
            Console.WriteLine("\n1. Enter strings manually");
            Console.WriteLine("2. Load from file");
            Console.WriteLine($"3. Toggle sort order (currently: {(sorter.ascending ? "ascending" : "descending")})");
            Console.WriteLine($"4. Toggle ignore spaces (currently: {(sorter.ignoreSpaces ? "on" : "off")})");
            Console.WriteLine("5. Show statistics");
            Console.WriteLine("6. Exit");
            Console.Write("Choose: ");
            string choice = Console.ReadLine()?.Trim() ?? "";
            switch (choice)
            {
                case "1":
                    Console.WriteLine("Enter strings (empty line to finish):");
                    var lines = new List<string>();
                    while (true)
                    {
                        string line = Console.ReadLine() ?? "";
                        if (line == "") break;
                        lines.Add(line);
                    }
                    if (lines.Count > 0)
                    {
                        sorter.AddStrings(lines);
                        sorter.Sort();
                        Console.WriteLine("\nSorted strings:");
                        sorter.Display();
                    }
                    break;
                case "2":
                    Console.Write("Enter file path: ");
                    string fname = Console.ReadLine()?.Trim() ?? "";
                    if (!File.Exists(fname))
                    {
                        Console.WriteLine("File not found.");
                        break;
                    }
                    var fileLines = File.ReadAllLines(fname);
                    if (fileLines.Length > 0)
                    {
                        sorter.AddStrings(fileLines);
                        sorter.Sort();
                        Console.WriteLine("\nSorted strings:");
                        sorter.Display();
                    }
                    break;
                case "3":
                    sorter.ascending = !sorter.ascending;
                    sorter.Sort();
                    Console.WriteLine("Sort order toggled. Re-sorting current list.");
                    sorter.Display();
                    break;
                case "4":
                    sorter.ignoreSpaces = !sorter.ignoreSpaces;
                    sorter.Sort();
                    Console.WriteLine("Ignore spaces toggled. Re-sorting current list.");
                    sorter.Display();
                    break;
                case "5":
                    sorter.ComputeStats();
                    if (sorter.stats.count == 0)
                        Console.WriteLine("No strings loaded.");
                    else
                        Console.WriteLine($"\nStatistics: count={sorter.stats.count}, min={sorter.stats.min}, max={sorter.stats.max}, avg={sorter.stats.avg:F2}");
                    break;
                case "6":
                    Console.WriteLine("Goodbye!");
                    return;
                default:
                    Console.WriteLine("Invalid choice.");
                    break;
            }
        }
    }
}
