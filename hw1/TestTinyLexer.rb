load "./TinyToken.rb"
load "./TinyScanner.rb"
# if the file(s) are in the same directory, you can simply precede
# the file name(s) with ./

# filename.txt below is simply the "source code"
# that you write that adheres to your grammar rules
# if it is in the same directory as this file, you can
# simply include the file name, otherwise, you will need
# to specify the entire path to the file as we did above
# to load the other ruby modules

if File.file?('input.txt')
	scan = Scanner.new("input.txt")
	out = File.open("output.txt", "w")
	tok = scan.nextToken()

# somewhere in here, you need logic to write your tokens to a file
# we'll use this file later in our parser
# it is enough to just list one token/lexeme pair per line in our token file
# Example: 
# id y 
# = =
# ...

# keep "fetching" one token at a time, using your scanner
# until there are no tokens left to scan 
while (tok.get_type() != Token::EOF)

   # display the first "Token" that you scanned in the Console
   puts "Token: #{tok.get_type()} Lexeme: #{tok.get_text()}"
   
   # You will also need to write the token to a file. 

   out.write("Token: #{tok.get_type()} Lexeme: #{tok.get_text()} \n")
   
   # get the next token available (if there is one)

   tok = scan.nextToken()
end 

# There should be one token left (see the boolean condition above)
# Go ahead and display (I did this) and print it (you do this)
puts "Lexeme: #{tok} Token type: #{tok.get_type()}"

out.write("Lexeme: #{tok} Token type: #{tok.get_type()} \n")
out.close

else

	puts 'File Not Found.'

end



