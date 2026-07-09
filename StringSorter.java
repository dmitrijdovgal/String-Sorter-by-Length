// StringSorter.java
import java.io.*;
import java.util.*;

public class StringSorter {
    private List<String> strings = new ArrayList<>();
    private boolean ascending = true;
    private boolean ignoreSpaces = false;
    private int min, max, count;
    private double avg;

    private int keyFunc(String s) {
        return ignoreSpaces ? s.replace(" ", "").length() : s.length();
    }

    public void addStrings(Iterable<String> strs) {
        for (String s : strs) strings.add(s);
    }

    public void sort() {
        strings.sort((a, b) -> {
            int lenA = keyFunc(a);
            int lenB = keyFunc(b);
            return ascending ? Integer.compare(lenA, lenB) : Integer.compare(lenB, lenA);
        });
    }

    public void computeStats() {
        if (strings.isEmpty()) {
            min = max = count = 0;
            avg = 0;
            return;
        }
        int sum = 0;
        min = Integer.MAX_VALUE;
        max = Integer.MIN_VALUE;
        for (String s : strings) {
            int len = keyFunc(s);
            if (len < min) min = len;
            if (len > max) max = len;
            sum += len;
        }
        count = strings.size();
        avg = (double) sum / count;
    }

    public void display() {
        if (strings.isEmpty()) {
            System.out.println("No strings to display.");
            return;
        }
        for (int i = 0; i < strings.size(); i++) {
            System.out.printf("%d. %s (length: %d)\n", i+1, strings.get(i), keyFunc(strings.get(i)));
        }
        computeStats();
        System.out.printf("\nStatistics: count=%d, min=%d, max=%d, avg=%.2f\n", count, min, max, avg);
    }

    public static void main(String[] args) throws IOException {
        StringSorter sorter = new StringSorter();
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("=== String Sorter by Length ===");
        while (true) {
            System.out.println("\n1. Enter strings manually");
            System.out.println("2. Load from file");
            System.out.printf("3. Toggle sort order (currently: %s)\n", sorter.ascending ? "ascending" : "descending");
            System.out.printf("4. Toggle ignore spaces (currently: %s)\n", sorter.ignoreSpaces ? "on" : "off");
            System.out.println("5. Show statistics");
            System.out.println("6. Exit");
            System.out.print("Choose: ");
            String choice = reader.readLine().trim();
            switch (choice) {
                case "1":
                    System.out.println("Enter strings (empty line to finish):");
                    List<String> lines = new ArrayList<>();
                    while (true) {
                        String line = reader.readLine();
                        if (line.isEmpty()) break;
                        lines.add(line);
                    }
                    if (!lines.isEmpty()) {
                        sorter.addStrings(lines);
                        sorter.sort();
                        System.out.println("\nSorted strings:");
                        sorter.display();
                    }
                    break;
                case "2":
                    System.out.print("Enter file path: ");
                    String fname = reader.readLine().trim();
                    File file = new File(fname);
                    if (!file.exists()) {
                        System.out.println("File not found.");
                        break;
                    }
                    List<String> fileLines = new ArrayList<>();
                    try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                        String line;
                        while ((line = br.readLine()) != null) {
                            fileLines.add(line);
                        }
                    }
                    if (!fileLines.isEmpty()) {
                        sorter.addStrings(fileLines);
                        sorter.sort();
                        System.out.println("\nSorted strings:");
                        sorter.display();
                    }
                    break;
                case "3":
                    sorter.ascending = !sorter.ascending;
                    sorter.sort();
                    System.out.println("Sort order toggled. Re-sorting current list.");
                    sorter.display();
                    break;
                case "4":
                    sorter.ignoreSpaces = !sorter.ignoreSpaces;
                    sorter.sort();
                    System.out.println("Ignore spaces toggled. Re-sorting current list.");
                    sorter.display();
                    break;
                case "5":
                    sorter.computeStats();
                    if (sorter.count == 0)
                        System.out.println("No strings loaded.");
                    else
                        System.out.printf("\nStatistics: count=%d, min=%d, max=%d, avg=%.2f\n",
                                sorter.count, sorter.min, sorter.max, sorter.avg);
                    break;
                case "6":
                    System.out.println("Goodbye!");
                    return;
                default:
                    System.out.println("Invalid choice.");
            }
        }
    }
}
