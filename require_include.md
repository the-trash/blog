require -- выполняет файл, и контролирует, что бы подключение не прошло дважды. Это файловый уровень.

include -- берет все методы из одного модуля и вносит их в указанный модуль. Является основным методом расширения классов. Это программный уровень.

require 'HumanActions'

human_actions.rb

```ruby
module HumanActions
 def thinking
   puts "Human thinking"
 end

 def sleeps
   puts "Human sleeps"
 end
end
```
