def validar_login(username, password)
  login_info = read_login_info

  if login_info && login_info[username] == password
    return true
  else
    return false
  end
end

def read_login_info
  login_info = {}
  File.open("data/login_info.txt", "r") do |file|
    file.each_line do |line|
      username, password = line.strip.split(",")
      login_info[username] = password
    end
  end
  login_info
end
