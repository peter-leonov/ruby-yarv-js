#!/opt/ruby-1.9/bin/ruby

require 'yaml'

class Generator
  def trace
    
  end
end

$g = Generator.new

def process op
  p op
  name = p[0]
  p name.class
  $g.send(op[0])
end

iseq = RubyVM::InstructionSequence.compile(IO.read(ARGV[0]))
iseq.to_a.last.each do |inst|
  process(inst)
end


# p iseq.to_a.last.to_yaml