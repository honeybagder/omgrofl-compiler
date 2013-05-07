%{
    #include <cstdio>
    #include <iostream>
    #include <map>
    #include "omgrofl.tab.h"

    extern "C" int yylex();
    extern "C" FILE *yyin;

    void yyerror(const char *s);

    static bool interactive = false;
    static std::map<std::string, char> vars;
%}

%token IZ
%token LMAO
%token ROFL
%token ROFLMAO
%token STFU

%union {
    std::string *var;
    char val;
}

%token <val> VALUE
%token <var> VARIABLE

%%

omgrofl:
    | omgrofl command
    ;

command:
    STFU { return 0; }
    | VARIABLE IZ VALUE { vars[*$1] = $3; }
    | LMAO VARIABLE { vars[*$2]++; }
    | ROFL VARIABLE { std::cout << (interactive ? "> " : "") << vars[*$2] << (interactive ? std::endl : ""); }
    | ROFLMAO VARIABLE { vars[*$2]--; }
    ;

%%

main(int argc, char **argv) {
    ++argv, --argc;  /* skip over program name */

    if (0 < argc) {
        yyin = fopen(argv[0], "r");
    } else {
        interactive = true;
        yyin = stdin;
    }

    yyparse();
}

void yyerror(const char *s) {
    std::cout << "Parse error! Message: " << s << std::endl;
    exit(-1);
}
