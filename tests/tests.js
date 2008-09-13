function puts (str) { var d = document; d.documentElement.appendChild(d.createElement('div')).appendChild(d.createTextNode(str)) }

Number.prototype.times = function (f) { for (var i = 0; i < this; i++) f(i) }
Number.prototype.to_s = Number.prototype.toString
Time = Date
Time.prototype.to_f = function () { return this/1000 }

function Class () {  }
Class.create = function (name, proto)
{
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

self = this



new function () { self = self["A"] = Class.create("A"); 
	
	
	new function () { self = self["EventsProcessor"] = Class.create("EventsProcessor"); var $1, $2, $3, $4;
		
		
		$4 = (new Time()).to_f();
		$3 = "";
		(50000).times(function ($2, $1) {
			
			$3 = $3 + ($2).to_s();
});
		$2 = (new Time()).to_f();
		puts(($2 - $4).to_s() + " sec");
		
		;
 } ();	;
	
	;
 } ();;
