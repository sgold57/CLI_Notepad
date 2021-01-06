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
      new_account = prompt.yes?("Would you like to create an account?")
      if new_account
        system("clear")
        create_new_account
      else
        puts "Kick rocks"
      end
    end

    def create_new_account
      puts "Please input your desired username: "
      desired_username = gets.chomp
      verify = prompt.yes?("Are you sure you want #{desired_username} to be your username?")
      if verify
        User.create(username: desired_username)
        binding.pry
      end
    end

    def user_verification(input)
      if User.find_by(username: input)
        current_user = User.find_by(username: input)
        puts "Welcome back #{current_user.username}."
        main_menu(current_user)
      else
        puts "That username does not compute."
        account_login
      end
    end

    def main_menu(current_user)
      binding.pry
      options = ["Create new note", "Read all previous notes", "Update an existing note", "Delete note"]
      choice = prompt.select("What you you like to do today?", options)
      if choice == "Create new note"
        create_note(current_user)
      end
    end

    def create_note(current_user)
      system("clear")
      puts("Write your note, hit enter when finished")
      new_note = gets.chomp
      verify = prompt.yes?("Would you like to save this note?")
        if verify
          Note.create(description: new_note, user: current_user)
          anything_else = prompt.yes?("Would you like to do anything else?")
          if anything_else
            system("clear")
            main_menu(current_user)
          else
            system("clear")
            exit
          end
        else
          system("clear")
          create_note(current_user)
        end
    end

end