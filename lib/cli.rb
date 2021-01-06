require 'tty-prompt'
require_relative '../config/environment.rb'


class Cli
  system("clear")
  ActiveRecord::Base.logger = nil

    def prompt
      TTY::Prompt.new
    end


    def greeting
      puts "Welcome to our notepad... patent pending"
      welcome_prompt
    end

    def welcome_prompt
      answer = prompt.yes?("Do you already have an account with us?") do |q|
        q.positive "Yes"
        q.negative "No"
      end
      if answer
        account_login
      else
        no_account
      end
    end

    def account_login
      puts "Please enter your username:"
      user_name = gets.chomp
      user_verification(user_name)
    end

    def no_account
      puts "good refactoring"
    end

    def user_verification(input)
      binding.pry
      if User.find_by(username: input)
        puts "Welcome back"
      else
        puts "That username does not compute"
      end
    end

end