class C {
	a : Int;
	b : Bool;
	init(x : Int, y : Bool) : C {
           {
		a <- x;
		b <- y;
		(let m: Int <- 1 in a = m);
		self;
           }
	};
};

Class Main {
	main():C {
	  (new C).init(1,true)
	};
};
