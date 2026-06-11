%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int  yylex(void);
void yyerror(const char *msg);

#define MAX_TASKS 64

typedef struct {
    char name[128];
    char script[256];
    char schedule[256];
    char dependency[128];
    char condition[64];
} Task;

Task tasks[MAX_TASKS];
int  task_count = 0;
Task current;

static void reset_current(void) {
    memset(&current, 0, sizeof(current));
    strcpy(current.schedule,   "");
    strcpy(current.dependency, "");
    strcpy(current.condition,  "");
}

static void print_task(Task *t) {
    printf("Executing Task: %s\n", t->name);
    printf("  Script: %s\n",       t->script);
    printf("  Schedule: %s\n",     t->schedule);
    if (strlen(t->dependency) > 0)
        printf("  Depends on: %s\n", t->dependency);
    if (strlen(t->condition) > 0)
        printf("  Condition: %s\n",  t->condition);
    printf("\n");
}

static int find_task(const char *name) {
    for (int i = 0; i < task_count; i++)
        if (strcmp(tasks[i].name, name) == 0) return i;
    return -1;
}

static int visited[MAX_TASKS];

static int dfs(int i) {
    visited[i] = 1;
    const char *dep = tasks[i].dependency;
    if (strlen(dep) == 0) { visited[i] = 2; return 0; }

    const char *target = dep;
    if (strncmp(dep, "BEFORE ", 7) == 0) target = dep + 7;

    int j = find_task(target);
    if (j == -1) { visited[i] = 2; return 0; }
    if (visited[j] == 1) {
        fprintf(stderr,
            "[Semantic Error] Circular dependency detected involving: %s\n",
            tasks[j].name);
        return 1;
    }
    if (visited[j] == 0 && dfs(j)) return 1;

    visited[i] = 2;
    return 0;
}

static void check_circular(void) {
    memset(visited, 0, sizeof(visited));
    for (int i = 0; i < task_count; i++)
        if (visited[i] == 0) dfs(i);
}
%}

%union {
    char *str;
}

%token TASK RUN EVERY DAY WEEK ON AT AFTER BEFORE DEPENDS IF
%token SUCCESS FAILURE LBRACE RBRACE
%token SUNDAY MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY SATURDAY

%token <str> IDENTIFIER
%token <str> STRING_LITERAL
%token <str> TIME_VAL

%type <str> day_name

%%

program
    : task_list
        {
            printf("Parsing TaskLang++ input...\n\n");
            check_circular();
            printf("--- EXECUTION START ---\n\n");
            for (int i = 0; i < task_count; i++)
                print_task(&tasks[i]);
            printf("--- EXECUTION COMPLETE ---\n");
        }
    ;

task_list
    : task
    | task_list task
    ;

task
    : TASK IDENTIFIER LBRACE
        {
            reset_current();
            strncpy(current.name, $2, sizeof(current.name)-1);
            free($2);
        }
      body RBRACE
        {
            if (task_count < MAX_TASKS) {
                tasks[task_count++] = current;
            } else {
                fprintf(stderr, "[Error] Too many tasks (max %d)\n",
                        MAX_TASKS);
            }
        }
    ;

body
    : run_stmt
    | run_stmt schedule_stmt
    | run_stmt dependency_stmt
    | run_stmt condition_stmt
    | run_stmt schedule_stmt dependency_stmt
    | run_stmt schedule_stmt condition_stmt
    | run_stmt dependency_stmt condition_stmt
    | run_stmt schedule_stmt dependency_stmt condition_stmt
    ;

run_stmt
    : RUN STRING_LITERAL
        {
            strncpy(current.script, $2, sizeof(current.script)-1);
            free($2);
        }
    ;

schedule_stmt
    : EVERY DAY AT TIME_VAL
        {
            snprintf(current.schedule, sizeof(current.schedule),
                     "EVERY DAY AT %s", $4);
            free($4);
        }
    | EVERY WEEK ON day_name AT TIME_VAL
        {
            snprintf(current.schedule, sizeof(current.schedule),
                     "EVERY WEEK ON %s AT %s", $4, $6);
            free($4); free($6);
        }
    | AT TIME_VAL
        {
            snprintf(current.schedule, sizeof(current.schedule),
                     "AT %s", $2);
            free($2);
        }
    ;

day_name
    : SUNDAY    { $$ = strdup("SUNDAY");    }
    | MONDAY    { $$ = strdup("MONDAY");    }
    | TUESDAY   { $$ = strdup("TUESDAY");   }
    | WEDNESDAY { $$ = strdup("WEDNESDAY"); }
    | THURSDAY  { $$ = strdup("THURSDAY");  }
    | FRIDAY    { $$ = strdup("FRIDAY");    }
    | SATURDAY  { $$ = strdup("SATURDAY");  }
    ;

dependency_stmt
    : AFTER IDENTIFIER
        {
            strncpy(current.dependency, $2,
                    sizeof(current.dependency)-1);
            free($2);
        }
    | BEFORE IDENTIFIER
        {
            snprintf(current.dependency, sizeof(current.dependency),
                     "BEFORE %s", $2);
            free($2);
        }
    | DEPENDS IDENTIFIER
        {
            strncpy(current.dependency, $2,
                    sizeof(current.dependency)-1);
            free($2);
        }
    ;

condition_stmt
    : IF SUCCESS { strcpy(current.condition, "success"); }
    | IF FAILURE { strcpy(current.condition, "failure"); }
    ;

%%
void yyerror(const char *msg) {
    extern int yylineno;
    fprintf(stderr,
        "\n[Parser Error] Line %d: %s\n"
        "  Hint: Check for missing keywords, braces, or wrong order.\n",
        yylineno, msg);
}

int main(int argc, char *argv[]) {
    extern FILE *yyin;

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
    }

    int result = yyparse();

    if (argc > 1) fclose(yyin);

    return result;
}
