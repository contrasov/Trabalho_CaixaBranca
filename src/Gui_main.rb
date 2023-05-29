require "tty-prompt"

class Produto
  attr_accessor :nome, :quantidade, :preco

  def initialize(nome, quantidade, preco)
    @nome = nome
    @quantidade = quantidade
    @preco = preco
  end
end

class TerminalDeGestaoDeEstoque
  def initialize
    @estoque = []
  end

  def adicionar_produto(prompt)
    nome = prompt.ask("\nDigite o nome do Produto:")
    quantidade = prompt.ask("Digite a quantidade:", convert: :int) do |q|
      q.validate(/\A\d+\z/, "Quantidade inválida. Digite novamente.")
    end
    preco = prompt.ask("Digite o preço:", convert: :float) do |q|
      q.validate(/\A\d+(\.\d+)?\z/, "Preço inválido. Digite novamente.")
    end

    produto = Produto.new(nome, quantidade, preco)
    @estoque << produto

    puts "\n\e[42m\e[30mProduto adicionado ao estoque com sucesso!\e[0m"
  end

  def atualizar_produto(prompt)
    nome = prompt.ask("Digite o nome do produto a ser atualizado:")

    produto = procurar_produto(nome)

    if produto
      quantidade = prompt.ask("Digite a quantidade:", convert: :int) do |q|
        q.validate(/\A-?\d+\z/, "Quantidade inválida. Digite novamente.")
      end

      nova_quantidade = produto.quantidade + quantidade

      if nova_quantidade < 0
        puts "\n\e[31mQuantidade inválida. A subtração excede a quantidade atual.\e[0m"
      else
        produto.quantidade = nova_quantidade
        puts "\n\e[42m\e[30mProduto atualizado com sucesso!\e[0m"
      end
    else
      puts "\n\e[31mProduto não encontrado no estoque.\e[0m"
    end
  end

  def visualizar_estoque
    puts "\nEstoque:"
    @estoque.each do |produto|
      puts "\nProduto: #{produto.nome}, Quantidade: #{produto.quantidade}, Preço: R$#{produto.preco}"
    end
  end

  private

  def procurar_produto(nome)
    @estoque.find { |produto| produto.nome == nome }
  end
end

def exibir_menu(prompt)
  prompt.select("\e[47m\e[30m=== Terminal de Gestão de Estoque ===\e[0m") do |menu|
    menu.choice "Adicionar Produto", 1
    menu.choice "Atualizar Produto", 2
    menu.choice "Visualizar Estoque", 3
    menu.choice "Sair", 0
  end
end

def exibir_tela_login(prompt)
  puts "\n\e[47m\e[30m=== Tela de Login ===\e[0m"
  username = prompt.ask("Digite seu nome de usuário:")
  password = prompt.mask("Digite sua senha:")

  if validar_login(username, password)
    puts "\n\e[42m\e[30mLogin bem-sucedido!\e[0m"
    return true
  else
    puts "\n\e[31mNome de usuário ou senha inválidos.\e[0m"
    return false
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
  File.open("login_info.txt", "r") do |file|
    file.each_line do |line|
      username, password = line.strip.split(",")
      login_info[username] = password
    end
  end
  login_info
end

terminal = TerminalDeGestaoDeEstoque.new
prompt = TTY::Prompt.new

loop do
  logged_in = exibir_tela_login(prompt)

  if !logged_in
    puts "\nEncerrando sistema..."
    break
  end

  opcao = exibir_menu(prompt)

  case opcao
  when 1
    terminal.adicionar_produto(prompt)
  when 2
    terminal.atualizar_produto(prompt)
  when 3
    terminal.visualizar_estoque
  when 0
    puts "\nEncerrando sistema..."
    break
  else
    puts "Opção inválida. Digite novamente."
  end

  puts "\n"
end
