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

  def adicionar_produto
    nome = ""
    while nome.empty?
      print "\nDigite o nome do Produto: "
      nome = gets.chomp
      if nome.empty?
        print "\e[31mProduto inválido. Digite Novamente: \e[0m"
      end
    end
    print "Digite a quantidade: "
    quantidade = gets.chomp.to_i

    while quantidade <= 0
      print "\e[31mQuantidade inválida. Digite novamente: \e[0m"
      quantidade = gets.chomp.to_i
    end

    print "Digite o preço: "
    preco = gets.chomp.to_f

    while preco <= 0
      print "\e[31mPreço inválido. Digite novamente: \e[0m"
      preco = gets.chomp.to_f
    end

    produto = Produto.new(nome, quantidade, preco)
    @estoque << produto

    puts "\n\e[42m\e[30mProduto adicionado ao estoque com sucesso!\e[0m"
  end

  def atualizar_produto
    print "Digite o nome do produto a ser atualizado: "
    nome = gets.chomp

    produto = procurar_produto(nome)

    if produto
      print "Digite a quantidade: "
      quantidade = gets.chomp.to_i

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

# Função para exibir o menu
def exibir_menu
  puts "\e[47m\e[30m=== Terminal de Gestão de Estoque ===\e[0m"
  puts "1. Adicionar Produto"
  puts "2. Atualizar Produto"
  puts "3. Visualizar Estoque"
  puts "\e[31m0. Sair\e[0m"
  print "Digite a opção desejada: "
end

# Função para exibir a tela de login
def exibir_tela_login
  puts "\n\e[47m\e[30m=== Tela de Login ===\e[0m"
  print "Digite seu nome de usuário: "
  username = gets.chomp
  print "Digite sua senha: "
  password = gets.chomp

  if validar_login(username, password)
    puts "\n\e[42m\e[30mLogin bem-sucedido!\e[0m"
    return true
  else
    puts "\n\e[31mNome de usuário ou senha inválidos.\e[0m"
    return false
  end
end

# Função para validar o login
def validar_login(username, password)
  login_info = read_login_info

  if login_info && login_info[username] == password
    return true
  else
    return false
  end
end

# Função para ler as informações de login do arquivo
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

# Criação do objeto TerminalDeGestaoDeEstoque
terminal = TerminalDeGestaoDeEstoque.new

# Loop principal do programa
loop do
  logged_in = exibir_tela_login

  if !logged_in
    puts "\nEncerrando sistema..."
    break
  end

  exibir_menu
  opcao = gets.chomp.to_i

  case opcao
  when 1
    terminal.adicionar_produto
  when 2
    terminal.atualizar_produto
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
