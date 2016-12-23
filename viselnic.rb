#!/usr/bin/env ruby

class Game

	def initialize
		@word = File.readlines("5desk.txt").sample.strip.upcase
		@mistakes = []
#		@player_name = current_player.name
		@step = 0
#		$dev = 1								# Development mode
	end

	def mistake_count
		@word.length - 1
	end

	def step
		puts "Let's start the game!"
		output = output_init(@word)
		
		until @mistakes.length == @word.length - 1 || won?(output)
			@step += 1
			puts
#			puts "Последний шанс!" if @mistakes.length == @word.length - 2
			puts "Шаг #{@step.to_s}"
#			puts @word if $dev == 1				# Development mode
			puts output
			print "Ошибки(#{@mistakes.length}): "
			print @mistakes.join(", ")
			print "\n"
			puts "Введите одну букву!"
			current_letter = gets.chomp.upcase
			if current_letter.length == 1
				if @word.include?(current_letter)
					output = step_output(@word, current_letter, output)
					puts output
				else
					puts "Такой буквы нет!"
					@mistakes << current_letter unless @mistakes.include?(current_letter)
				end
			else
			puts "Введите только одну букву!"
			end
		end
		puts "Вы выиграли!" if (@mistakes.length < 6)
		puts "Игра закончена!"
	end

	def output_init(word)
			out = ""
			out << word[0,1]
			for i in 1...word.length - 1
				out << "_"
			end
			out << word[-1,1]
			out
	end

	def step_output(word, current_letter, out)

		if current_letter
			word.split("").each_with_index { |chr, i| out[i] = current_letter if chr == current_letter }
		else
			puts "Input error!"
		end
		out #.join
	end

	def won?(output)
		if output.include?("_")
			return false
		else
			return true
		end 
	end

end

class Player
	
	def initialize(name)
		@name = name
		@saved_games = []
	end

	attr_accessor :name

end


puts "Добро пожаловать в игру 'Висельник'"


new_game = Game.new

puts "Вы можете ошибиться #{new_game.mistake_count} раз#{"а" if (2..4).include?(new_game.mistake_count) }!"

new_game.step
