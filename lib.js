this.puts = function (str) { this.print(str + "\n") }
Number.prototype.times = function (f) { for (var i = 0; i < this; i++) f(i) }
