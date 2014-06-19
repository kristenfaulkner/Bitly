
def run_code
  get_user
  get_user_input
end

def get_user
  puts "Input your email:"
  email = gets.chomp
  puts email
  User.find_by(email: email)
end

def get_user_input
  puts "What do you want to do?"
  puts "0. Create shortened URL"
  puts "1. Visit shortened URL"
  selection = gets.chomp.to_i
  if selection == 0
    create
  else
    visit
  end  
end

def create
  puts "Type in your long URL"
  long_url = gets.chomp
  puts long_url
  short_url = ShortenedUrl.create_for_user_and_long_url!(get_user, long_url).short_url
  puts "Short url is #{short_url}"
end

def visit
  puts "Please type in your short url"
  short_url = gets.chomp
  puts short_url
  visit = Visit.new(get_user, short_url)
  visit.save!
  long_url = ShortenedUrl.find(:short_url => short_url).first.long_url
  Launchy.open(long_url)
end

run_code