#### require

require -- Это файловый уровень подключения. require выполняет подключение файла к текущему скрипту. require исполняет содержимое файла и контролирует, что бы подключение не прошло дважды.

**human_actions.rb**

```ruby
p "HumanActions module"

module HumanActions
 def thinking
   puts "Human thinking"
 end

 def sleeps
   puts "Human sleeps"
 end
end
```

**human_actions_exe.rb**

```ruby
puts require './human_actions'
puts require './human_actions'
puts require './human_actions'
```

Имеем слудующий результат:

```ruby
"HumanActions module"
true
false
false
```

Т.е. при первом подключении файл исполняется и require возвращает true.

Далее require возвращает false и не допускает повторного исполнения файла.

#### include

include -- берет все методы из одного модуля и вносит их в указанный модуль. Является основным методом расширения классов. Это программный уровень.