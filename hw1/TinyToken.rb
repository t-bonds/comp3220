#
#  Class Token - Encapsulates the tokens in TINY
#
#   @type - the type of token (Category)
#   @text - the text the token represents (Lexeme)
#
class Token
	attr_accessor :type
	attr_accessor :text

# This is the only part of this class that you need to 
# modify.
EOF = "eof"
LPAREN = "("
RPAREN = ")"
ADDOP  = "+"
SUBOP = "-"
MULOP = "*"
DIVOP = "/"
ASSGN = "="
ID = "id"
NUMERIC = "numeric"
EPSILON = "epsilon"
WS = "whitespace"
PRINT = "PRINT"
# add the rest of the tokens needed based on the grammar
# specified in the Scanner class "TinyScanner.rb"

#constructor
	def initialize(type,text)
		@type = type
		@text = text
	end
	
	def get_type
		return @type
	end
	
	def get_text
		return @text
	end
	
# to string method
	def to_s
		return "#{@type} #{@text}"
	end
end
