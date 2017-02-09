# RubyChess
===========

# Description
-----------

Chess game written in Ruby

# Instalation
-----------

Just type the following comman in terminal or cmd:

'git clone https://github.com/assotirov/RubyChess.git'

After that you should have a folder in the currend directory  
which is shown in terminal or cmd.

# Playing the game
----------------
First change the directory to '../RubyChess/lib'.  
Then type the following command: 'ruby play.rb' , to play  
in the console.

If you want to play with Graphical user interface, type in  
the console: 'ruby gui_play.rb' (not implemented yet)


# Saving/loading the game
-----------------------
In console when its your tunr just type 'save' to go to the save
menu. Then you will get further instructions to save/load/delete your game


# Running the test
------------------
Change the directory to '../RubyChess/lib' then type the following
command in terminal or cmd to run the tests:  
'rspec spec.rb -r ./ChessGame.rb -c -f doc'

#TODO
-----
-Implement GUI chess  
-Try to implement the methods without repeating myself
