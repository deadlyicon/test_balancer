class TestBalancer::Tests < Array

  # Taken from ActiveSupport 3.1.1
  #
  # Splits or iterates over the array in +number+ of groups, padding any
  # remaining slots with +fill_with+ unless it is +false+.
  #
  #   %w(1 2 3 4 5 6 7 8 9 10).in_groups(3) {|group| p group}
  #   ["1", "2", "3", "4"]
  #   ["5", "6", "7", nil]
  #   ["8", "9", "10", nil]
  #
  #   %w(1 2 3 4 5 6 7).in_groups(3, '&nbsp;') {|group| p group}
  #   ["1", "2", "3"]
  #   ["4", "5", "&nbsp;"]
  #   ["6", "7", "&nbsp;"]
  #
  #   %w(1 2 3 4 5 6 7).in_groups(3, false) {|group| p group}
  #   ["1", "2", "3"]
  #   ["4", "5"]
  #   ["6", "7"]
  def in_groups(number, fill_with = nil)
    # size / number gives minor group size;
    # size % number gives how many objects need extra accommodation;
    # each group hold either division or division + 1 items.
    division = size / number
    modulo = size % number

    # create a new array avoiding dup
    groups = []
    start = 0

    number.times do |index|
      length = division + (modulo > 0 && modulo > index ? 1 : 0)
      padding = fill_with != false &&
        modulo > 0 && length == division ? 1 : 0
      groups << slice(start, length).concat([fill_with] * padding)
      start += length
    end

    if block_given?
      groups.each { |g| yield(g) }
    else
      groups
    end
  end

end
