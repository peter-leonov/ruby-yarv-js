self = this

puts = print
Number.prototype.times = function (f) { for (var i = 0; i < this; i++) f(i) }
Number.prototype.to_s = Number.prototype.toString
Time = Date
Time.prototype.to_f = function () { return this/1000 }

function Class () {  }
Class.create = function (name, proto, parent)
{
	if (!parent)
		parent = self
	
	var f = function ()
	{
		this.initialize.apply(this, arguments)
		this.constructor = f
		this['class'] = function () { return this.constructor }
	}
	
	if (name)
		f.name = name
	
	if (proto)
		f.prototype = proto
	
	return f
}
