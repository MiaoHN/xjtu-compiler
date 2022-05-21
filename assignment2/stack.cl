class Stack {

  top  : String;
  rest : Stack;
  size : Int <- 0;

  init(item : String, stack : Stack) : Stack {
    {
      top  <- item;
      rest <- stack;
      size <- stack.size() + 1;
      self;
    }
  };

  push(item : String) : Stack {
    (new Stack).init(item, self)
  };

  top() : String {
    if self.size() = 0 then ""
    else top
    fi
  };

  printStack() : Object {
    if 0 < size then {
      (new IO).out_string("layer ").out_int(size - 1).out_string(": ");
      (new IO).out_string(top).out_string("\n");
      rest.printStack();
    } else {
      "";
    }
    fi
  };

  remain() : Stack {
    if self.size() = 0 then self
    else rest
    fi
  };

  pop() : Stack {
    if self.size() = 0 then self
    else {
      top  <- rest.top();
      rest <- rest.remain();
      size <- size - 1;
      self;
    } fi
  };

  size() : Int { size };

};