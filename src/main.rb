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
    print "\nDigite o nome do produto: "
    nome = gets.chomp

    print "Digite a quantidade: "
    quantidade = gets.chomp.to_i

    while quantidade <= 0
      print "Quantidade inválida. Digite novamente: "
      quantidade = gets.chomp.to_i
    end

    print "Digite o preço: "
    preco = gets.chomp.to_f

    while preco <= 0
      print "Quantidade inválida. Digite novamente: "
      preco = gets.chomp.to_i
    end

    produto = Produto.new(nome, quantidade, preco)
    @estoque << produto

    puts "\nProduto adicionado ao estoque com sucesso!"
  end

  def atualizar_produto
    print "Digite o nome do produto a ser atualizado: "
    nome = gets.chomp

    produto = procurar_produto(nome)

    if produto
      print "Digite a nova quantidade: "
      quantidade = gets.chomp.to_i

      produto.quantidade = quantidade

      puts "\nProduto atualizado com sucesso!"
    else
      puts "\nProduto não encontrado no estoque."
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

# Criação do objeto TerminalDeGestaoDeEstoque
terminal = TerminalDeGestaoDeEstoque.new

# Loop principal do programa
loop do
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
    puts "\n\e[31mEncerrando sistema...\e[0m"
    break
  else
    puts "Opção inválida. Digite novamente."
  end

  puts "\n"
end
