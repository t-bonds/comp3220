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
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Parser Class
#
load "Token.rb"
load "Lexer.rb"
$numErrors = 0
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
      puts "Expected to find #{dtype} Token here. Instead found #{@lookahead.text}"
      $numErrors += 1
      end
    consume()
  end
   	
	# "Might" need to modify this. Errors?
	def program()
    while( @lookahead.type != Token::EOF)
      puts "Entering STMT Rule"
			statement()  
    end
    if ($numErrors == 0)
      puts "Program parsed with no errors."
    else  
      puts "There were #{$numErrors} parse errors found."
    end
  end
       
  def exp()
    puts "Entering TERM Rule"
    term()
    puts "Entering ETAIL Rule"
    etail()
    puts "Exiting EXP Rule"
    rparen() 
  end   

  def rparen()
    if (@lookahead.type == Token::RPAREN) 
      puts "Found RPAREN Token: #{@lookahead.text}"
      match(Token::RPAREN)
    end
  end

  def assign()
    puts "Entering ID Rule"
    id()
    if ( @lookahead.type == Token::ASSGN)
      puts "Found ASSGN Token: = "
    end
    match(Token::ASSGN)
    puts "Entering EXP Rule"
    exp()   
    puts "Exiting ASSGN Rule"
  end

  def id()
    if (@lookahead.type == Token::ID)
      puts "Found ID Token: #{@lookahead.text}"
    end
    match(Token::ID)
    puts "Exiting ID Rule"
  end    

  def term()
    puts "Entering FACTOR Rule"
    factor()
    puts "Entering TTAIL Rule"
    ttail()
    puts "Exiting TERM Rule"
  end      

  def factor()
    if (@lookahead.type == Token::LPAREN)
      puts "Found LPAREN Token: #{@lookahead.text}"
      match(Token::LPAREN)
      puts "Entering EXP Rule"
      exp()  
    elsif (@lookahead.type == Token::INT) 
      #puts "Entering INT Rule" 
      int()
    else (@lookahead.type == Token::ID)
      puts "Entering ID Rule"
      id()
    end
    puts "Exiting FACTOR Rule"  
  end

  def int()
    if (@lookahead.type == Token::INT)
      puts "Found INT Token: #{@lookahead.text}"
      match(Token::INT)
    end
    #puts "Exiting INT Rule"    
  end

  def etail()
    if (@lookahead.type == Token::ADDOP)
      puts "Found ADDOP Token: #{@lookahead.text}"
      consume()
      puts "Entering TERM Rule"
      term()
      puts "Entering ETAIL Rule"
      etail()
    elsif (@lookahead.type == Token::SUBOP)
      puts "Found SUBOP Token: #{@lookahead.text}"
      consume()
      puts "Entering TERM Rule"
      term()
      puts "Entering ETAIL Rule"
      etail()
    elsif (@lookahead.type != Token::ADDOP or @lookahead.type != Token::SUBOP)
      puts "Did not find ADDOP or SUBOP Token. Choosing EPSILON production"
    end
    puts "Exiting ETAIL Rule"    
  end

  def ttail()
    if (@lookahead.type == Token::MULTOP)
      puts "Found MULTOP Token: #{@lookahead.text}"
      consume()
      puts "Entering TERM Rule"
      term()
      #puts "Entering TTAIL Rule"
      #ttail()
    elsif (@lookahead.type == Token::DIVOP)
      puts "Found DIVOP Token: #{@lookahead.text}"
      consume()
      puts "Entering TERM Rule"
      term()
      #puts "Entering TTAIL Rule"
      #ttail()
    elsif (@lookahead.type != Token::MULTOP or @lookahead.type != Token::DIVOP)
      puts "Did not find MULTOP or DIVOP Token. Choosing EPSILON production"
    end
    puts "Exiting TTAIL Rule" 
  end

	def statement()
		if (@lookahead.type == Token::PRINT)
			puts "Found PRINT Token: #{@lookahead.text}"
			match(Token::PRINT)
			puts "Entering EXP Rule"
			exp()
		else
			puts "Entering ASSGN Rule"
			assign()
		end
		
		puts "Exiting STMT Rule"
	end
end

