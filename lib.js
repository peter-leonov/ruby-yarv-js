global = self = this

puts = print
Number.prototype.times = function (f) { for (var i = 0; i < this; i++) f(i) }
Number.prototype.to_s = Number.prototype.toString
Time = Date
Time.prototype.to_f = function () { return this/1000 }

function Class () {  }
Class.create = function (name, protoClass, parent)
{
	if (!parent)
		parent = Class
	
	var f = function ()
	{
		if (this.initialize)
			this.initialize.apply(this, arguments)
		this.constructor = f
		this['class'] = function () { return this.constructor }
	}
	
	if (name)
		f.name = name
	
	f.prototype = protoClass ? new protoClass() : new Class()
	
	return f
}

Class['core#define_method'] = function (klass, name, f)
{
	f.name = name
	klass.prototype[name] = f
}

Class['core#define_singleton_method'] = function (klass, name, f)
{
	f.name = name
	klass[name] = f
}

Class.prototype.super = function (f, args)
{
	var super = this.constructor.prototype[f.name]
	puts(super)
	return super.apply(this, args)
}
