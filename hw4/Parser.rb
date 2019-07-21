# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID
# EPSILON    -->   ""
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Parser Class
#
load "Lexer.rb"
class Parser < Scanner

    def initialize(filename)
        super(filename)
        consume()
    end

    def consume()
        @lookahead = nextToken()
        while(@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end

    def match(dtype)
        if (@lookahead.type != dtype)
            puts "Expected #{dtype} found #{@lookahead.type}"
			consume()
			@errors_found+=1
        end
        consume()
    end

    def program()
    	@errors_found = 0
		p = AST.new(Token.new("program","program"))
	    while( @lookahead.type != Token::EOF)
            p.addChild(statement())
        end
        
		if (@errors_found == 0)
            puts "Program parsed with no errors."
        else
            puts "There were #{@errors_found} parse errors found."
        end
		return p
    end

    def statement()
		stmt = AST.new(Token.new("statement","statement"))
        if (@lookahead.type == Token::PRINT)
			stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
		return stmt
    end

    def exp()
        exp = AST.new(Token.new("exp", "exp"))
        term = term()
        etail = etail()
        if (etail != nil)
            exp = etail
            exp.addAsFirstChild(term)
        else        
            exp = term
        end
        return exp
    end

    def term()
        term = AST.new(Token.new("term","term"))
        factor = factor()
        ttail = ttail()
        if (ttail != nil)
            term = ttail
            term.addAsFirstChild(factor)
        else
            term = factor   
        end
        return term
    end

    def factor()
        fct = AST.new(Token.new("factor","factor"))
        if (@lookahead.type == Token::LPAREN)
            match(Token::LPAREN)
            fct = exp()
            if (@lookahead.type == Token::RPAREN)
                match(Token::RPAREN)
            else
				match(Token::RPAREN)
            end
        elsif (@lookahead.type == Token::INT)
            fct = AST.new(@lookahead)
            match(Token::INT)
        elsif (@lookahead.type == Token::ID)
            fct = AST.new(@lookahead)
            match(Token::ID)
        else
            puts "Expected to see ( or INT Token or ID Token. Instead found #{@lookahead.text}"
            @errors_found+=1
            consume()
        end
		return fct
    end

    def ttail()
        ttail = AST.new(Token.new("ttail","ttail"))
        if (@lookahead.type == Token::MULTOP)
            ttail = AST.new(@lookahead)
            match(Token::MULTOP)
            ttail.addChild(factor())
            ttail.addAsFirstChild(ttail())
            return ttail
        elsif (@lookahead.type == Token::DIVOP)
            ttail = AST.new(@lookahead)
            match(Token::DIVOP)
            ttail.addChild(factor())
            ttail.addAsFirstChild(ttail())
            return ttail
		else
			return nil
        end
    end

    def etail()
        etail = AST.new(Token.new("etail", "etail"))
        if (@lookahead.type == Token::ADDOP)
            etail = AST.new(@lookahead)
            match(Token::ADDOP)
            etail.addChild(term())
            etail.addAsFirstChild(etail())
            return etail
        elsif (@lookahead.type == Token::SUBOP)
            etail = AST.new(@lookahead)
            match(Token::SUBOP)
            etail.addChild(term())
            etail.addAsFirstChild(etail())
            return etail
		else
			return nil
        end
    end

    def assign()
        assgn = AST.new(Token.new("assignment","assignment"))
		if (@lookahead.type == Token::ID)
			idtok = AST.new(@lookahead)
			match(Token::ID)
			if (@lookahead.type == Token::ASSGN)
				assgn = AST.new(@lookahead)
				assgn.addChild(idtok)
            	match(Token::ASSGN)
				assgn.addChild(exp())
        	else
				match(Token::ASSGN)
			end
		else
			match(Token::ID)
        end
		return assgn
	end
end
