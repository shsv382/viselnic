#!/usr/bin/env ruby

class Game

	def initialize
		@word = File.readlines("5desk.txt").sample.strip.upcase
		@mistakes = []
#		@player_name = current_player.name
		@step = 0
	end

	def step
		puts "Let's start the game!"
		puts step_output(@word, nil)
		while @mistakes.length < 6 || won?
			puts "Input letter, please!"
			current_letter = gets.chomp.upcase
		if current_letter.length == 1
			if @word.include?(current_letter)
				puts step_output(@word, current_letter)
			else
				puts "Такой буквы нет!"
				@mistakes << current_letter
				print "Ошибки:"
				@mistakes.each { |letter| print letter }
			end
		else
			puts "Введите одну букву!"
		end
	end

	def step_output(word, current_letter)
#		output = ""
		if @step == 0
			word << @word[0,1]
			for i in 1...@word.length - 1
				word << "_"
			end
			word << @word[-1,1]
		elsif current_letter
			@word.split("").each_with_index { |chr, i| word[i] = current_letter if chr == current_letter }
		else
			puts "Input error!"
		end
		word.join
	end

	def won?(output)
		true unless output.include?("_") 
	end

end

class Player
	
	def initialize(name)
		@name = name
		@saved_games = []
	end

	attr_accessor :name

end



