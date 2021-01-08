require 'tty-prompt'
require "colorize"
require_relative '../config/environment.rb'


class Cli
  system("clear")
  ActiveRecord::Base.logger = nil

  def prompt
    TTY::Prompt.new
  end

  def font
    TTY::Font.new(:doom)
  end

  def pastel
    Pastel.new
  end

  def clear
    system"clear"
    greeting
  end

  def start
    greeting
    welcome_prompt
  end

  def greeting
    puts"            .--.          .---.        .-.
        .---|--|   .-.    | A |  .---. |~|    .--.
    .--|===|Ch|---|_|--.__| S |--|:::| |~|-==-|==|---.
    |%%|NT2|oc|===| |~~|%%| C |--|   |_|~|CATS|  |___|-.
    |  |   |ah|===| |==|  | I |  |:::|=| |    |GB|---|=|
    |  |   |ol|   |_|__|  | I |__|   | | |    |  |___| |
    |~~|===|--|===|~|~~|%%|~~~|--|:::|=|~|----|==|---|=|
    ^--^---'--^---^-^--^--^---'--^---^-^-^-==-^--^---^-'
      ".colorize(:yellow)
      puts pastel.yellow(font.write ("WELCOME TO CLI NOTEPAD"))
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
        clear
        create_new_account
      else
        puts "Kick rocks"
      end
    end

    def create_new_account
      puts "Please input your desired username: "
      desired_username = gets.chomp
      if User.find_by(username:desired_username)
        puts "That username is already taken. Please select another username"
        create_new_account
      else
        verify = prompt.yes?("Are you sure you want #{desired_username} to be your username?")
      end
      if verify
        new_user = User.create(username: desired_username)
      else
        create_new_account
      end
      main_menu(new_user)
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
      options = ["Create new note", "Read all notes", "Update existing note", "Delete note"]
      choice = prompt.select("What you you like to do today?", options)
      if choice == "Create new note"
        create_note(current_user)
      elsif choice == "Read all notes"
        read_note(current_user)
      elsif choice == "Update existing note"
        update_note(current_user)
      elsif choice == "Delete note"
        delete_note(current_user)
      end
    end

    def create_note(current_user)
      clear
      puts("Write your note, hit enter when finished")
      new_note = gets.chomp
      verify = prompt.yes?("Would you like to save this note?")
        if verify
          Note.create(description: new_note, user: current_user)
          anything_else(current_user)
        else
          clear
          create_note(current_user)
        end
    end

    def get_all_notes(current_user)
      current_user.note.map{|key| key[:description]}
    end

    def get_note_id(current_user)
      current_user.note.map{|key| key[:id]}
    end

    def read_note(current_user)
      clear
      if current_user.note != []
        puts get_all_notes(current_user)
      else 
        puts "You must write a note first to read it!"
      end   
      anything_else(current_user)
    end

    def update_note(current_user)
      clear
      if current_user.note != []
        selected_note = prompt.select("which note do you want to update today",get_all_notes(current_user))
        update_note = Note.find_by(description:selected_note)
        update_note.description = gets.chomp
        verify = prompt.yes?("Are you sure you want to update note to '#{update_note.description}'?")
        if verify
          update_note.save
          puts "Note has been successfully updated"
          anything_else(current_user)
        else
          update_note(current_user)
        end
      else
        puts "You must write a note first to update it!"
        anything_else(current_user)
      end
    end

    def delete_note(current_user)
      clear
      if current_user.note != []
        selected_note = prompt.select("Which note do you want to delete", get_all_notes(current_user))
        delete_note = Note.find_by(description:selected_note)
        verify = prompt.yes?("Are you sure you want to delete #{delete_note.description}?")
        if verify
          delete_note.destroy
        end
      else
        puts "You must write a note first to delete it!"
      end
      anything_else(current_user)
    end

    def anything_else(current_user)
      current_user.reload
      if prompt.yes?("Would you like to do anything else?")
        clear
        main_menu(current_user)
      else
        current_user = nil
        clear
        exit
      end
    end
end

