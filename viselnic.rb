#!/usr/bin/env ruby

#require 'pstore'
#$store = PStore.new("saved")
require 'yaml'

class Game

	def initialize
		@word = File.readlines("5desk.txt").sample.strip.upcase
		@mistakes = []
#		@player_name = current_player.name
		@step = 0
		@output = ""
#		$dev = 1								# Development mode
	end

	attr_accessor :word, :mistakes, :step

	def step
#		$store.transaction do
#			$store[:games] ||= Array.new
#			$store[:games] << self
#		end

		@output = output_init(@word) if @step == 0

		
		until @mistakes.length == @word.length - 1 || won?(@output)
		puts "Let's start the game!"
			@step += 1
			puts
#			puts "Последний шанс!" if @mistakes.length == @word.length - 2
			puts "Шаг #{@step.to_s}"
#			puts @word if $dev == 1				# Development mode
			puts @output
			print "Ошибки(#{@mistakes.length}): "
			print @mistakes.join(", ")
			print "\n"
			puts "Введите одну букву! (Delete для выхода)"
			current_letter = gets.chomp
			redo if current_letter.empty?
			if current_letter.ord == 27
				exit
			end
			current_letter.upcase!
			if current_letter.length == 1
				if @word.include?(current_letter)
					@output = step_output(@word, current_letter, @output)
					puts @output
				else
					puts "Такой буквы нет!"
					@mistakes << current_letter unless @mistakes.include?(current_letter)
				end
			else
			puts "Введите только одну букву!"
			end
			save	
		end
		puts "Вы выиграли!" if won?(@output)
		puts "Игра закончена!"
		File.delete('saved')
	end

	def mistake_count
		@word.length - 1
	end

	private

	def save
		save = File.open('saved', 'w') do |f|
			f.puts YAML::dump(self)
		end
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
puts %q{Выберите пункт меню:
1. Новая Игра
}
puts "2. Сохраненная Игра" if File.exists?('saved')
puts
case gets.chomp
when "1"
game = Game.new
puts "Вы можете ошибиться #{game.mistake_count} раз#{"а" if (2..4).include?(game.mistake_count) }!"
when "2"
	save = File.open('saved', 'r') do |save|
		game = YAML::load(save)
	end	
#	$store.transaction do
#		game = $store[:games][0]
#	end
end
game.step
