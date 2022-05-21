class Main inherits IO {

  stack        : Stack <- new Stack;
  integertrans : IntegerTrans <- new IntegerTrans;

  prompt() : String {
    {
      out_string("[int, +, s], [e]xecute, [d]isplay, e[x]it> ");
      in_string();
    }
  };

  manipulate() : Object {
    if stack.size() < 3 then out_string("Invalid Operation!!!\n")
    else (let top : String <- stack.top() in {
      if top = "+" then {
        stack.pop();
        if integertrans.is_integer(stack.top()) then {
          (let num1 : Int <- integertrans.string_to_int(stack.top()) in {
            stack.pop();
            if integertrans.is_integer(stack.top()) then {
              (let num2 : Int <- integertrans.string_to_int(stack.top()) in {
                stack.pop();
                (let sum : Int <- num1 + num2 in {
                  stack <- stack.push(integertrans.int_to_string(sum));
                  out_string("Add done\n");
                });
              });
            } else {
              stack <- stack.push(integertrans.int_to_string(num1));
              stack <- stack.push("+");
              out_string("Invalid Operation!!!\n");
            } fi;
          });
        } else {
          stack <- stack.push("+");
          out_string("Invalid Operation!!!\n");
        } fi;
      }
      else if top = "s" then {
        stack.pop();
        (let item1 : String <- stack.top() in {
          stack.pop();
          (let item2 : String <- stack.top() in {
            stack.pop();
            stack <- stack.push(item1);
            stack <- stack.push(item2);
            out_string("Swap done\n");
          });
        });
      }
      else out_string("Invalid Operation!\n")
      fi fi;
    }) fi
  };

  main() : Object {{
    out_string("\n");
    while true loop
      (let input : String <- prompt() in
        if input = "x" then abort()
        else if input = "" then ""
        else if input = "d" then {
          if stack.size() = 0 then out_string("Stack is empty\n")
          else stack.printStack()
          fi;
        } else if input = "+" then stack <- stack.push(input)
        else if input = "s" then stack <- stack.push(input)
        else if input = "e" then manipulate()
        else if integertrans.is_integer(input) then stack <- stack.push(input)
        else out_string("Invalid input!!!\n")
        fi fi fi fi fi fi fi
      )
    pool;
  }};
};