# General Info

CLI Notepad is a CLI application that allows each user to create their own login, create their own notes, read all previously written notes, update their notes, and also delete their notes.

# Technologies

- Active Record - Version 6.0
- Colorize - 0.8.1
- Rake - Version 13.0
- Ruby - Version 2.6.5
- Sinatra - Version 2.0
- Sqlite3 - Version 1.4
- TTY-Font - Version 0.5.0
- TTY-Prompt - Version 0.23.0

# Setup

To clone this GitHub repository (w/ SSH), in your terminal type:

```
git clone git@github.com:sgold57/CLI_Notepad.git
```

and then to run the program type:

```
bundle init
bundle install
ruby runner.rb
```

# Features

- Ability to create a unique user name
- Create notes associated with the unique user name
- Read all of user's notes
- Update any of user's notes
- Delete any of user's notes

# Code Sample
```
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
```

# Status
Project is functional with option for potential addition of features, as well as potential for cleaning up code.

# Foundational Repo Used 
https://github.com/DamonLC21/boiler_plate_ar_setup

# Challenges
We would have liked for the ability for the user to select their desired note to be updated, and that selected string be printed to the terminal with the ability for it to be edited (e.g. changing "Hello Wurld" to "Hello World") without having to retype the entire note. However, it does not appear that the CLI has this functionality. Our program still works with the ability for users to update their notes, but in order to do so, they must type out the whole note.

# Contact
Program made by [Obinna Nwabia](https://github.com/coremand) and [Sam Gold](https://github.com/sgold57). Please contact if you have any questions or concerns.




