this.puts = function (str) { this.print(str + "\n") }
Number.prototype.times = function (f) { for (var i = 0; i < this; i++) f(i) }
Number.prototype.to_s = Number.prototype.toString
Time = Date
Time.prototype.to_f = function () { return this/1000 }
