#!/opt/ruby-1.9/bin/ruby

require 'yaml'

class Block
  
  @@indent = 2
  @@space = "  "
  
  @@out_space = '	'
  @@out_indent = -1
  
  def initialize
    @code = ""
    @s = []
    @locals = nil
  end
  
  def warn_op op, str = ""
    warn "#{@@space * @@indent}#{op.first(5).select{|v|v.class!=Array}}#{str}, [#{@s}]"
  end
  
  def warn_str str
    warn "#{@@space * @@indent}#{str}"
  end
  
  def out_space
    @@out_space * @@out_indent
  end
  
  def to_local num
    "$#{num}"
  end
  
  def op_trace op
  end
  
  def op_putspecialobject op
  end
  
  def op_putnil op
    @s << nil
  end
  
  def op_putstring op
    @s << "#{op[1].inspect}"
  end
  
  def op_putobject op
    @s << op[1]
  end
  
  def op_setlocal op
    unless @locals
      @locals = "var " + (1..op[1]).map { |v| to_local v }.join(', ') + ";"
    end
    last = @s.pop
    @s << "#{to_local op[1]} = #{last}"
  end
  
  def op_setdynamic op
    last = @s.pop
    @s << "#{to_local op[1]} = #{last}"
  end
  
  def op_getlocal op
    @s << "#{to_local op[1]}"
  end
  
  def op_getdynamic op
    @s << "#{to_local op[1]}" # dynamic
  end
  
  def op_getconstant op
    @s << "#{op[1]}"
  end
  
  def op_dup op
  end
  
  def op_opt_plus op
    last = @s.pop
    prev = @s.pop
    # (...) may be needed
    @s << "#{prev} + #{last}"
  end
  
  def op_opt_minus op
    last = @s.pop
    prev = @s.pop
    # (...) may be needed
    @s << "#{prev} - #{last}"
  end
  
  def op_opt_mult op
    last = @s.pop
    prev = @s.pop
    # (...) may be needed
    @s << "#{prev} * #{last}"
  end
  
  def op_send op
    name = op[1]
    args = @s.last(op[2])
    op[2].times { @s.pop }
    last = @s.pop
    
    block = op[3]
    if block
      code = bakeclosure op
      args.unshift code
    end
    
    if last
      unless last =~ /^[a-zA-Z]\w*$/
        last = "(#{last})"
      end
      call = name == :new ? "new #{last}" : "#{last}.#{name}"
    else
      call = "#{name}"
    end
    
    @s << "#{call}(#{args.join(", ")})"
  end
  
  def op_defineclass op
    # SimpleDataFormat
    sdf = op[2]
    block = sdf[11]
    # puts code.to_yaml
    code = Block.new.walk block
    @code << out_space + "new function () { self = self[#{op[1].to_s.inspect}] = Class.create(#{op[1].to_s.inspect}); #{code} } ();"
  end
  
  def bakeclosure op
    # SimpleDataFormat
    warn_str op.inspect
    sdf = op[3]
    args = sdf[4]
    block = sdf[11]
    warn_op block
    code = Block.new.walk block
    return "function (#{(args[:arg_size]..args[:local_size]).to_a.reverse.map{|v| to_local v}.join(', ')}) {#{code}}"
  end
  
  def op_leave op
    @code << out_space + @s.join(', ') + ";"
  end
  
  def op_newline op
    @code << out_space + (@s.empty? ? "\n" : @s.join(', ') + ";\n")
    @s = []
  end
  
  
  
  def walk ops
    warn_str "block"
    @@indent += 1
    @@out_indent += 1
    ops.each do |op|
      if op.class == Fixnum
        warn_str 'newline'
        op_newline op
      elsif op.class == Symbol
        # warn "label: #{op}"
      else
        optype = ("op_" + op[0].to_s).to_sym
        
        # p op
        if respond_to? optype
          warn_op op
          send optype, op
        else
          warn_op op, " UNKNOWN"
          # warn "unknow optype #{optype}"
        end
      end
      
    end
    warn_str "#{@code}"
    @@indent -= 1
    @@out_indent -= 1
    return "#{@locals}\n" + @code.to_s + "\n"
  end
end

class Generator
  def start iseq
    # return "(function (self) { self.prototype = {};\n" + Block.new.walk(iseq.to_a.last) + " return self }) (this) ;"
    return Block.new.walk(iseq.to_a.last).to_s
  end
end

OutputCompileOption =
{
  :peephole_optimization    =>true,
  :inline_const_cache       =>false,
  :specialized_instruction  =>false,
  :operands_unification     =>false,
  :instructions_unification =>false,
  :stack_caching            =>false,
}

# class Block; def warn_str; end; def warn_op; end ;end
warn "\n\n\n"
puts Generator.new.start RubyVM::InstructionSequence.compile(IO.read(ARGV[0]), "src", 1) #, OutputCompileOption

# p iseq.to_a.last.to_yaml