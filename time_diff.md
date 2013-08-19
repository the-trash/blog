Есть у меня 2 даты.

```ruby
start_time = Time.new(2013, 1, 22, 13)
end_time   = Time.new(2013, 1, 22, 15, 45)
```

Хотелось бы получить между ними разницу в часах и минутах:

```ruby
t_diff = end_time - start_time
h = (t_diff / 1.hour).floor
m = ((t_diff - h * 1.hour) / 1.minute).round
```

Итого:

```ruby
"#{h}:#{m}" # => 2:45
```

