current_root = File.expand_path File.dirname __FILE__

puts require current_root + '/human_actions'
puts require current_root + '/human_actions'
puts require current_root + '/human_actions'

class Human
  include HumanActions
  include HumanActions
  include HumanActions
end

human = Human.new

puts human.thinking
puts human.sleeps