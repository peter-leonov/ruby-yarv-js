
a = true
b = ARGV[0]

# if b
#   a = b ? 1 : 0
#   
#   a = b ? 1 : 0
# end

if a == b then puts 1 else puts 2 end


# while a
#   break
#   redo
# end

# if a
#   puts "true"
# end
# 
# if a
#   puts "true"
# else
#   puts "false"
# end

__END__

[:branchunless, :label_28] UNKNOWN, [["$1_2"]]
[:jump, :label_14] UNKNOWN, [["$1_2"]]
[:label, :label_14], [["$1_2"]]

[:jump, :label_28] UNKNOWN, [[]]
[:label, :label_28], [[]]



[:branchunless, :label_49] UNKNOWN, [["$1_2"]]
[:jump, :label_36] UNKNOWN, [["$1_2"]]
[:label, :label_36], [["$1_2"]]

[:jump, :label_60] UNKNOWN, [[]]
[:label, :label_49], [[]]

[:label, :label_60], [["puts(\"false\")"]]


[:leave], [["puts(\"false\")"]]
