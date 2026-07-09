// string_sorter.js
const readline = require('readline');
const fs = require('fs');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function ask(question) {
    return new Promise(resolve => rl.question(question, resolve));
}

class StringSorter {
    constructor() {
        this.strings = [];
        this.ascending = true;
        this.ignoreSpaces = false;
        this.stats = {};
    }

    keyFunc(str) {
        if (this.ignoreSpaces) {
            return str.replace(/ /g, '').length;
        }
        return str.length;
    }

    addStrings(strs) {
        this.strings = this.strings.concat(strs);
    }

    sort() {
        this.strings.sort((a, b) => {
            const lenA = this.keyFunc(a);
            const lenB = this.keyFunc(b);
            if (this.ascending) {
                return lenA - lenB;
            } else {
                return lenB - lenA;
            }
        });
    }

    computeStats() {
        if (this.strings.length === 0) {
            this.stats = { min: 0, max: 0, avg: 0, count: 0 };
            return;
        }
        const lengths = this.strings.map(s => this.keyFunc(s));
        const min = Math.min(...lengths);
        const max = Math.max(...lengths);
        const sum = lengths.reduce((a, b) => a + b, 0);
        this.stats = {
            min: min,
            max: max,
            avg: sum / lengths.length,
            count: lengths.length
        };
    }

    display() {
        if (this.strings.length === 0) {
            console.log("No strings to display.");
            return;
        }
        this.strings.forEach((s, i) => {
            console.log(`${i+1}. ${s} (length: ${this.keyFunc(s)})`);
        });
        this.computeStats();
        const st = this.stats;
        console.log(`\nStatistics: count=${st.count}, min=${st.min}, max=${st.max}, avg=${st.avg.toFixed(2)}`);
    }
}

async function main() {
    const sorter = new StringSorter();
    console.log("=== String Sorter by Length ===");
    while (true) {
        console.log("\n1. Enter strings manually");
        console.log("2. Load from file");
        console.log(`3. Toggle sort order (currently: ${sorter.ascending ? 'ascending' : 'descending'})`);
        console.log(`4. Toggle ignore spaces (currently: ${sorter.ignoreSpaces ? 'on' : 'off'})`);
        console.log("5. Show statistics");
        console.log("6. Exit");
        const choice = await ask("Choose: ");
        switch (choice.trim()) {
            case '1': {
                console.log("Enter strings (empty line to finish):");
                const lines = [];
                while (true) {
                    const line = await ask("");
                    if (line === '') break;
                    lines.push(line);
                }
                if (lines.length > 0) {
                    sorter.addStrings(lines);
                    sorter.sort();
                    console.log("\nSorted strings:");
                    sorter.display();
                }
                break;
            }
            case '2': {
                const fname = await ask("Enter file path: ");
                try {
                    const data = fs.readFileSync(fname, 'utf8');
                    const lines = data.split('\n').map(line => line.replace(/\r$/, ''));
                    if (lines.length > 0) {
                        sorter.addStrings(lines);
                        sorter.sort();
                        console.log("\nSorted strings:");
                        sorter.display();
                    }
                } catch (e) {
                    console.log("File not found or error.");
                }
                break;
            }
            case '3': {
                sorter.ascending = !sorter.ascending;
                sorter.sort();
                console.log("Sort order toggled. Re-sorting current list.");
                sorter.display();
                break;
            }
            case '4': {
                sorter.ignoreSpaces = !sorter.ignoreSpaces;
                sorter.sort();
                console.log("Ignore spaces toggled. Re-sorting current list.");
                sorter.display();
                break;
            }
            case '5': {
                sorter.computeStats();
                const st = sorter.stats;
                if (st.count === 0) {
                    console.log("No strings loaded.");
                } else {
                    console.log(`\nStatistics: count=${st.count}, min=${st.min}, max=${st.max}, avg=${st.avg.toFixed(2)}`);
                }
                break;
            }
            case '6':
                console.log("Goodbye!");
                rl.close();
                return;
            default:
                console.log("Invalid choice.");
        }
    }
}

main().catch(console.error);
