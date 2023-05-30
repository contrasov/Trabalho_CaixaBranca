require "tty-prompt"
require_relative "lib/Produto"
require_relative "lib/TerminalDeGestãodeEstoque"
require_relative "utils/login_manager"

def exibir_menu(prompt)
  prompt.select("\e[47m\e[30m=== Terminal de Gestão de Estoque ===\e[0m") do |menu|
    menu.choice "Adicionar Produto", 1
    menu.choice "Atualizar Produto", 2
    menu.choice "Dar Baixa no Estoque", 3
    menu.choice "Visualizar Estoque", 4
    menu.choice "Gerar Relatório", 5
    menu.choice "Sair", 0
  end
end

def exibir_tela_login(prompt)
  puts "\n\e[47m\e[30m=== Tela de Login ===\e[0m"

  login_attempts = 0

  loop do
    choices = [
      { name: "Entrar", value: :entrar },
      { name: "Sair", value: :sair },
    ]

    action = prompt.select("Selecione uma opção:", choices)

    case action
    when :entrar
      username = prompt.ask("Digite seu nome de usuário:") do |q|
        q.validate(/^\S+$/, "Nome de usuário não pode estar em branco. Digite novamente.")
      end

      password = prompt.mask("Digite sua senha:") do |q|
        q.validate(/^\S+$/, "Senha não pode estar em branco. Digite novamente.")
      end

      if validar_login(username, password)
        puts "\n\e[42m\e[30mLogin bem-sucedido!\e[0m"
        return true
      else
        puts "\n\e[31mNome de usuário ou senha inválidos.\e[0m"
        login_attempts += 1
        if login_attempts == 3
          puts "\n\e[31mNúmero máximo de tentativas de login excedido. Encerrando o programa...\e[0m"
          return false
        end
      end
    when :sair
      puts "\n\e[40mEncerrando sistema...\e[0m"
      return false
    end
  end
end

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

terminal = TerminalDeGestaoDeEstoque.new
prompt = TTY::Prompt.new

logged_in = false

logged_in = exibir_tela_login(prompt)

while logged_in
  opcao = exibir_menu(prompt)

  case opcao
  when 1
    terminal.adicionar_produto(prompt)
  when 2
    terminal.atualizar_produto(prompt)
  when 3
    terminal.dar_baixa(prompt)
  when 4
    terminal.visualizar_estoque(prompt)
  when 5
    terminal.gerar_relatorio
  when 0
    puts "\nEncerrando sistema..."
    break
  else
    puts "Opção inválida. Digite novamente."
  end

  puts "\n"
end
