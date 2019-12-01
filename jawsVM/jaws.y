%{
  #include <cstdio>
  #include <iostream>
  using namespace std;

  // Declare stuff from Flex that Bison needs to know about:
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;

  void yyerror(const char *s);
%}

// Declare token types 
%token SPACE
%token TAB
%token LF

%%

// Grammmar 
jaws:
//  header body_section footer {
  body_section {  // alternate line w/o header & footer
    cout << "done with a jaws file!" << endl;
  };
//header:
//  SPACE TAB TAB SPACE LF {
//    cout << "started parsing jaws code!" << endl;
//  };
//footer:
//  LF LF LF {  // need to change this so it is not ambiguous
//    cout << "stopped parsing jaws code!" << endl;
//  };
body_section:
  body_instructions
  ;
body_instructions:
  body_instructions body_instruction
  | body_instruction
  ;
body_instruction:
  stack_manipulation
  | arithmetic
  | heap_access
  | flow_control
  | io_action
  | io_control
  ;

// ---- IMP Defs ----
stack_manipulation:
  SPACE SPACE stack_command
  ;
arithmetic:
  SPACE TAB arith_command
  ;
heap_access:
  TAB TAB heap_command
  ;
flow_control:
  LF flow_command
  ;
io_action:
  TAB LF io_action_command
  ;
io_control:
  TAB SPACE io_control_command
  ;

// --- IMP Commands ---
stack_command:
  stack_push
  | stack_duplicate
  | stack_swap
  | stack_discard
  ;
arith_command:
  addition
  | subtraction
  | multiplication
  | integer_division
  | modulo
  ;
heap_command:
  heap_store
  | heap_retrieve
  ;
flow_command:
  new_label
  | call_subroutine
  | uncond_jump
  | jump_if_zero
  | jump_if_neg
  | end_subroutine
  | end_program
  ;
io_action_command:
  output_char
  | output_int
  | read_char
  | read_int
  ;
io_control_command:
  stream_file
  | stream_net
  | stream_stdio
  ;

// -- Command Defs --
// stack
stack_push:
  SPACE number {
    cout << "push data on top of the stack" << endl;
  };
stack_duplicate:
  LF SPACE {
    cout << "duplicate item on top of the stack" << endl;
  };
stack_swap:
  LF TAB {
    cout << "swap items on top of the stack" << endl;
  };
stack_discard:
  LF LF {
    cout << "discard item on top of the stack" << endl;
  };
// arithmetic
addition:
  SPACE SPACE {
    cout << "addition" << endl;
  };
subtraction:
  SPACE TAB {
    cout << "subtraction" << endl;
  };
multiplication:
  SPACE LF {
    cout << "multiplication" << endl;
  };
integer_division:
  TAB SPACE {
    cout << "division" << endl;
  };
modulo:
  TAB TAB {
    cout << "modulo" << endl;
  };
// heap
heap_store:
  SPACE {
    cout << "heap store" << endl;
  };
heap_retrieve:
  TAB {
    cout << "heap retrieve" << endl;
  };
// flow control
new_label:
  SPACE SPACE label {
    cout << "new label" << endl;
  };
call_subroutine:
  SPACE TAB label {
    cout << "call subroutine" << endl;
  };
uncond_jump:
  SPACE LF label {
    cout << "jump unconditionally" << endl;
  };
jump_if_zero:
  TAB SPACE label {
    cout << "jump if top of stack is zero" << endl;
  };
jump_if_neg:
  TAB TAB label {
    cout << "jump if top of stack is negative" << endl;
  };
end_subroutine:
  TAB LF {
    cout << "end subroutine" << endl;
  };
end_program:
  LF LF {
    cout << "end of program" << endl;
  };
// io action
output_char:
  SPACE SPACE {
    cout << "outputting a character to IO" << endl;
  };
output_int:
  SPACE TAB {
    cout << "outputting an integer to IO" << endl;
  };
read_char:
  TAB SPACE {
    cout << "reading a character from IO" << endl;
  };
read_int:
  TAB TAB {
    cout << "reading an integer from IO" << endl;
  };
  ;
// io control
stream_file:
  SPACE SPACE {
    cout << "streaming from a file" << endl;
  };
stream_net:
  SPACE TAB ip port {
    cout << "streaming from network connection: " << endl;
  };
stream_stdio:
  TAB SPACE
  ;

// --- Parameters ---
number:
  bits LF {
    cout << "<arbitrary data>" << endl;
  };
label:
  bits LF {
    cout << "<label>" << endl;
  };
bits:
  bits bit
  | bit
  ;
bit:
  SPACE
  | TAB
  ;
ip:
  octet octet octet octet {
    cout << "<ip>" << endl;
  };
octet:
  bit bit bit bit bit bit bit bit
  ;
port:
  octet octet {
    cout << "<port>" << endl;
  };

%%

int main(int, char**) {
  // Open a file handle to a particular file:
  FILE *myfile = fopen("test.jaws", "r");
  // Make sure it is valid:
  if (!myfile) {
    cout << "I can't open test.jaws!" << endl;
    return -1;
  }
  // Set Flex to read from it instead of defaulting to STDIN:
  yyin = myfile;

  // Parse through the input:
  yyparse();

}

void yyerror(const char *s) {
  cout << "Whoopsie daisies, parse error!  Message: " << s << endl;
  // might as well halt now:
  exit(-1);
}