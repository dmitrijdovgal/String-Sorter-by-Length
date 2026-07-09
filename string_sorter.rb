# string_sorter.rb
class StringSorter
  attr_accessor :ascending, :ignore_spaces

  def initialize
    @strings = []
    @ascending = true
    @ignore_spaces = false
    @stats = {}
  end

  def key_func(s)
    @ignore_spaces ? s.gsub(' ', '').length : s.length
  end

  def add_strings(strs)
    @strings.concat(strs)
  end

  def sort
    @strings.sort_by! { |s| key_func(s) }
    @strings.reverse! unless @ascending
  end

  def compute_stats
    if @strings.empty?
      @stats = { min: 0, max: 0, avg: 0, count: 0 }
      return
    end
    lengths = @strings.map { |s| key_func(s) }
    @stats = {
      min: lengths.min,
      max: lengths.max,
      avg: lengths.sum.to_f / lengths.size,
      count: lengths.size
    }
  end

  def display
    if @strings.empty?
      puts "No strings to display."
      return
    end
    @strings.each_with_index do |s, i|
      puts "#{i+1}. #{s} (length: #{key_func(s)})"
    end
    compute_stats
    st = @stats
    puts "\nStatistics: count=#{st[:count]}, min=#{st[:min]}, max=#{st[:max]}, avg=#{'%.2f' % st[:avg]}"
  end
end

def main
  sorter = StringSorter.new
  puts "=== String Sorter by Length ==="
  loop do
    puts "\n1. Enter strings manually"
    puts "2. Load from file"
    puts "3. Toggle sort order (currently: #{sorter.ascending ? 'ascending' : 'descending'})"
    puts "4. Toggle ignore spaces (currently: #{sorter.ignore_spaces ? 'on' : 'off'})"
    puts "5. Show statistics"
    puts "6. Exit"
    print "Choose: "
    choice = gets.chomp.strip
    case choice
    when '1'
      puts "Enter strings (empty line to finish):"
      lines = []
      loop do
        line = gets.chomp
        break if line.empty?
        lines << line
      end
      unless lines.empty?
        sorter.add_strings(lines)
        sorter.sort
        puts "\nSorted strings:"
        sorter.display
      end
    when '2'
      print "Enter file path: "
      fname = gets.chomp.strip
      unless File.exist?(fname)
        puts "File not found."
        next
      end
      lines = File.readlines(fname, chomp: true)
      unless lines.empty?
        sorter.add_strings(lines)
        sorter.sort
        puts "\nSorted strings:"
        sorter.display
      end
    when '3'
      sorter.ascending = !sorter.ascending
      sorter.sort
      puts "Sort order toggled. Re-sorting current list."
      sorter.display
    when '4'
      sorter.ignore_spaces = !sorter.ignore_spaces
      sorter.sort
      puts "Ignore spaces toggled. Re-sorting current list."
      sorter.display
    when '5'
      sorter.compute_stats
      st = sorter.instance_variable_get(:@stats)
      if st[:count] == 0
        puts "No strings loaded."
      else
        puts "\nStatistics: count=#{st[:count]}, min=#{st[:min]}, max=#{st[:max]}, avg=#{'%.2f' % st[:avg]}"
      end
    when '6'
      puts "Goodbye!"
      break
    else
      puts "Invalid choice."
    end
  end
end

main if __FILE__ == $0
