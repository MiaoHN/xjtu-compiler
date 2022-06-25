class A {
};

Class BB__ inherits A {
};

class Main inherits IO {
  x1 : Int;
  x2 : Int <- 2;
  main() : SELF_TYPE {
	  {
	    func("\n");
      case x1 of
        a : A => x1 <- x1 + 1;
        b : B => x1 <- x1 + 1;
      esac;
      if x1 then x1 else x2 fi;
      while x1 loop x2 <- x1 + x2 pool;
      (let x: Int <- 1 in x2 <- x1 + x);
	  }
  };
};