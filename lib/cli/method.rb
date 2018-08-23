require_relative '../../config/environment'
require 'colorize'
def welcome
  puts "Hello, welcome to the"
  puts"  .-.
 (   )  ___
 -| |-'`   '-._,
 -| |-.      .'
  |.') `~~~~`
 (_.|  _____             _     _                 _
  |._)|  _  |___ ___ ___|_|___| |_ _____ ___ ___| |_ ___
  |.')|     | . | . | . | |   |  _|     | -_|   |  _|_ -|
 (_.| |__|__|  _|  _|___|_|_|_|_| |_|_|_|___|_|_|_| |___|
  |._)      |_| |_|
 ('.|
  |._)
  '-'"
end

def help
  system 'clear'
  welcome
  puts "Please see the commands below:"
  puts "--------------------------------------------------------"
  puts "HELP   - will give you choices of available commands"
  puts "VIEW   - will see all of the current patient appointments"
  puts "CREATE - will create an appointment"
  puts "UPDATE - will update an existing patient's appointment"
  puts "REMOVE - will remove the existing patient's appointment"
  puts "EXIT   - exit this program"
  puts "--------------------------------------------------------"
end

old_logger = ActiveRecord::Base.logger
#turn off debug
ActiveRecord::Base.logger = nil
#turn on debug
#ActiveRecord::Base.logger = old_logger

def view(name)
  prompt = TTY::Prompt.new
  begin
    f_patient = Patient.find_patient(name)
    system "clear"
    welcome
    f_patient.view
  rescue
    system "clear"
    welcome
    print "ERROR:".colorize(:color => :white,:background => :red)
    puts " Username have been taken".colorize(:color => :red)
    return
  end
end

def create(name)
  prompt = TTY::Prompt.new
  loop do
    begin
      f_patient = Patient.find_patient(name)
      doctor = prompt.select("Choose your doctor", map_of_doctors)
      if doctor == "EXIT"
        system "clear"
        welcome
        return
      end
      puts "dates are DD/MM/YYYY HH:MM example 01/01/1901 00:00"
      begin
        date = Time.parse(prompt.ask("Please enter appointment date:"))
        a = f_patient.add_appointment(doctor, date)
        if a != nil
          break
        end
      rescue
        system "clear"
        welcome
        print "ERROR:".colorize(:color => :white,:background => :red)
        puts " Time have been taken".colorize(:color => :red)
        return
      end
    rescue
      puts "Yep something went wrong in create dunno where..."
      binding.pry
    end
  end
  system "clear"
  welcome
  puts "Appointment created"
end

def update(name)
  prompt = TTY::Prompt.new
  begin
    pname = Patient.find_patient(name)
    pdoctor = prompt.select("Choose your doctor", map_of_doctors)
    if pdoctor == "EXIT"
      system "clear"
      welcome
      return
    end
    begin
      old_time = prompt.select('What appointment do you like to update?', map_of_times(pname, pdoctor))
      if old_time == "EXIT"
        system "clear"
        welcome
        return
      end
    rescue
      system "clear"
      welcome
      print "ERROR:".colorize(:color => :white,:background => :red)
      puts " You have no appointment(s) with #{pdoctor.full_name}".colorize(:color => :red)
      return
    end
    puts "dates are DD/MM/YYYY HH:MM example 01/01/0001 00:00"
    begin
      new_time = Time.parse(prompt.ask('Please enter a new date/time:'))
    rescue
      system "clear"
      welcome
      print "ERROR:".colorize(:color => :white,:background => :red)
      puts " The input you have entered does not complie with the date format".colorize(:color => :red)
      return
    end

    pname.update_appointment(pdoctor, old_time, new_time)
    system "clear"
    welcome
    puts "The appointment has been updated!"
  rescue
    puts "Yep something went wrong in update dunno where..."
    binding.pry
  end
end

def remove(name)
  prompt = TTY::Prompt.new
  begin
    patient = Patient.find_patient(name)
    doctor = nil
    time = nil
    loop do
      doctor = prompt.select("Choose your doctor", map_of_doctors)
      if doctor == "EXIT"
        system "clear"
        welcome
        return
      end
      begin
        time = prompt.select('What appointment do you like to update?', map_of_times(patient, doctor))
        if time == "EXIT"
          system "clear"
          welcome
          return
        end
        break
      rescue
        system "clear"
        welcome
        print "ERROR:".colorize(:color => :white,:background => :red)
        puts " No appointments with #{doctor.full_name}".colorize(:color => :red)
      end
    end
    patient.remove_appointment(doctor, time)
    system "clear"
    welcome
    puts "The appointment has been removed!"
  rescue
    puts "Yep something went wrong in remove, dunno where..."
    binding.pry
  end
end

def login
  prompt = TTY::Prompt.new

  user_name = prompt.ask('Please enter username:')
  user_password = prompt.mask('Please enter password:')

  begin
    cred1 = Credential.find_by(username:user_name,password:user_password)
    Patient.find_by(id:cred1.other_id)
  rescue
    system "clear"
    welcome
    print "ERROR:".colorize(:color => :white,:background => :red)
    puts " Incorrect username or password".colorize(:color => :red)
    return
  end
end