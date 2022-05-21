class IntegerTrans
{
  int_to_char(number : Int) : String 
  {
    if number = 0 then "0" 
    else if number = 1 then "1"
    else if number = 2 then "2"
    else if number = 3 then "3"
    else if number = 4 then "4"
    else if number = 5 then "5"
    else if number = 6 then "6"
    else if number = 7 then "7"
    else if number = 8 then "8"
    else if number = 9 then "9"
    else { abort(); ""; }
    fi fi fi fi fi fi fi fi fi fi
  };

  is_integer(str : String) : Bool {
    if str.length() = 1 then char_is_integer(str)
    else if str.substr(0, 1) = "-" then is_integer_aux(str.substr(1, str.length() - 1))
    else if str.substr(0, 1) = "+" then is_integer_aux(str.substr(1, str.length() - 1))
    else is_integer_aux(str)
    fi fi fi
  };

  is_integer_aux(str : String) : Bool {
    if str.length() = 1 then char_is_integer(str)
    else if char_is_integer(str.substr(0, 1)) then is_integer_aux(str.substr(1, str.length() - 1))
    else false
    fi fi
  };

  char_is_integer(ch : String) : Bool {
    if ch = "0" then true
    else if ch = "1" then true
    else if ch = "2" then true
    else if ch = "3" then true
    else if ch = "4" then true
    else if ch = "5" then true
    else if ch = "6" then true
    else if ch = "7" then true
    else if ch = "8" then true
    else if ch = "9" then true
    else false
    fi fi fi fi fi fi fi fi fi fi 
  };

  int_to_string(number : Int) : String {
    if number = 0 then "0"
    else if 0 < number then int_to_string_aux(number)
    else "-".concat(int_to_string_aux(number * ~1))
    fi fi
  };

  int_to_string_aux(number : Int) : String {
    if number = 0 then ""
    else (
      let next : Int <- number / 10 in
        int_to_string_aux(next).concat(int_to_char(number - next * 10))
    )
    fi
  };

  char_to_int(ch : String) : Int {
    if ch = "0" then 0
    else if ch = "1" then 1
    else if ch = "2" then 2
    else if ch = "3" then 3
    else if ch = "4" then 4
    else if ch = "5" then 5
    else if ch = "6" then 6
    else if ch = "7" then 7
    else if ch = "8" then 8
    else if ch = "9" then 9
    else { abort(); 0; }
    fi fi fi fi fi fi fi fi fi fi
  };

  string_to_int(str : String) : Int {
    if str.length() = 0 then 0
    else if str.substr(0, 1) = "-" then ~string_to_int_aux(str.substr(1, str.length() - 1))
    else if str.substr(0, 1) = "+" then string_to_int_aux(str.substr(1, str.length() - 1))
    else string_to_int_aux(str)
    fi fi fi
  };

  string_to_int_aux(str : String) : Int {
    (
      let number : Int <- 0 in {
        (
          let j : Int <- str.length() in
          (
            let i : Int <- 0 in
            while i < j loop {
              number <- number * 10 + char_to_int(str.substr(i, 1));
              i <- i + 1;
            }
            pool
          )
        );
        number;
      }
    )
  };
};