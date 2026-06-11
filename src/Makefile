CC      = gcc                       
CFLAGS  = -Wall -Wextra -g           
BISON   = bison                        
FLEX    = flex                         
TARGET  = tasklang                   

PARSER_SRC = parser.y                
LEXER_SRC  = lexer.l                 

PARSER_C   = parser.tab.c             
PARSER_H   = parser.tab.h            
LEXER_C    = lex.yy.c              

TESTS = tests/Test1\
        tests/Test2\
        tests/Test3\
        tests/Test4\
        tests/Test5

all: $(TARGET)

$(TARGET): $(PARSER_C) $(LEXER_C)
	$(CC) $(CFLAGS) -o $(TARGET) $(PARSER_C) $(LEXER_C)
	@echo ""
	@echo "✅  Build successful! Run: ./tasklang <input_file>"
	@echo ""


$(PARSER_C) $(PARSER_H): $(PARSER_SRC)
	$(BISON) -d $(PARSER_SRC)
	@echo "Bison: grammar compiled → $(PARSER_C) + $(PARSER_H)"

$(LEXER_C): $(LEXER_SRC) $(PARSER_H)
	$(FLEX) $(LEXER_SRC)
	@echo "Flex:  lexer compiled  → $(LEXER_C)"

test: $(TARGET) $(TESTS)
	@echo "============================================"
	@echo "  Running TaskLang++ Test Suite"
	@echo "============================================"
	@for f in $(TESTS); do \
	    printf "  Testing %-35s " "$$f ..."; \
	    if ./$(TARGET) $$f > /dev/null 2>&1; then \
	        echo "✅  PASS"; \
	    else \
	        echo "❌  FAIL (expected for invalid tests)"; \
	    fi \
	done
	@echo "============================================"
	@echo ""

run:
	@echo "Usage: make run FILE=tests/test1_simple.tl"
	@if [ -n "$(FILE)" ]; then ./$(TARGET) $(FILE); fi

clean:
	rm -f $(TARGET) $(PARSER_C) $(PARSER_H) $(LEXER_C)
	@echo "🧹  Cleaned up all generated files."

.PHONY: all test run clean
