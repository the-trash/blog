def args_testing_method a
  puts a
end

def block_testing_method
  if block_given?
    yield
  else
    puts "block not given"
  end
end

def block_arg_testing_method &block
  if block
    block.call
  else
    puts "block not given"
  end
end

def sym_proc_test arg
  if block_given?
    puts yield(arg)
  else
    puts "block not given"
  end
end

# args_testing_method "Hello world!"
# ERRORS
# args_testing_method { puts "Hello world!" }  # => wrong number of arguments (0 for 1)

# block_testing_method
# block_testing_method { puts "Hello world!" }
# block_testing_method do puts "Hello world!" end
# block_testing_method &(Proc.new { puts "Hello world!" })
# block_testing_method &lambda { puts "Hello world!" }
# block_testing_method &-> { puts "Hello world!" }

# ERRORS
# block_testing_method &:to_s                                # no receiver given
# block_testing_method :to_s                                 # => wrong number of arguments (1 for 0)
# block_args_testing_method Proc.new { puts "Hello world!" } # => wrong number of arguments (1 for 0)
# block_args_testing_method -> { puts "Hello world!" }       # => wrong number of arguments (1 for 0)

# block_arg_testing_method
# block_arg_testing_method { puts "Hello world!" }
# block_arg_testing_method do puts "Hello world!" end
# block_arg_testing_method &Proc.new { puts "Hello world!" }
# block_arg_testing_method &lambda { puts "Hello world!" }
# block_arg_testing_method &-> { puts "Hello world!" }

# ERRORS
# block_arg_testing_method "Hello world!" # => wrong number of arguments (1 for 0)

sym_proc_test :hello_world, &(Proc.new{ |a| a.to_s + a.to_s })

# http://mudge.name/2011/01/26/passing-blocks-in-ruby-without-block.html