require_relative '../config/environment'
require_relative '../app/models/appointment.rb'
require_relative '../app/models/doctor.rb'
require_relative '../app/models/patient.rb'

prompt = TTY::Prompt.new

def welcome
  puts "Hello welcome to the App"
  #puts "Please enter your full name"
end

def help
  puts "help - will give you choices of available commands"
  puts "view - will see all of the current patient appointments"
  puts "create - will create a new patient"
  puts "update - will update an existing patient's appointment"
  puts "remove - will remove the existing patient's appointment"
  puts "exit - exit this program"
  puts "--------------------------------------------------------"
end

old_logger = ActiveRecord::Base.logger
#turn off debug
ActiveRecord::Base.logger = nil
#turn on debug
#ActiveRecord::Base.logger = old_logger
# user_input = gets.chomp
# patient = Patient.find_patient(user_input)
# puts patient.full_name

# felix = Patient.create(first_name:"felix",last_name:"chan",gender:"f")
# otash = Patient.create(first_name:"otash",last_name:"kamalov",gender:"m")
# sher = Doctor.create(first_name:"sherzod",last_name:"karimov",gender:"m", specialties:"urologist")
# appt = Appointment.create(doctor_id:sher.id,patient_id:felix.id,date: "01/02/2018 03:00",duration: 1,note:"")
# appt1 = Appointment.create(doctor_id:sher.id,patient_id:felix.id,date: "01/03/2018 05:00",duration: 1,note:"")

# puts enter a date
# user_input = gets.chomp
# date = Time.parse(user_input)
def view
  puts "Please enter your full name:"
  user_input1 = gets.chomp
  f_patient = Patient.find_patient(user_input1)
  f_patient.view

end

def create
  puts "Please enter your full name:"
  p_full_name = gets.chomp
  f_patient = Patient.find_patient(p_full_name)
  puts "Please enter doctor's full name:"
  d_full_name = gets.chomp
  f_doctor = Doctor.find_doctor(d_full_name)
  puts "Please enter appointment date:"
  puts "dates are MM/DD/YYYY HH:MM example 01/01/1901 00:00"
  date = Time.parse(gets.chomp)
  f_patient.add_appointment(f_doctor,date)
end


def run
  welcome
  help
  loop do
    user_input = gets.chomp
    case user_input
    when "help"
      help
    when "view"
      view
    when "create"
      create
    when "update"
      update
    when "exit"
      exit
    else
      "wrong input"
    end
  end
end

run
binding.pry
0
