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
    @prompt = TTY::Prompt.new
  end

  def adicionar_produto
    nome = @prompt.ask("\nDigite o nome do Produto:") do |q|
      q.required(true) # Torna o campo obrigatório
    end

    quantidade = @prompt.ask("Digite a quantidade:", convert: :int) do |q|
      q.validate(/\A[1-9]\d*\z/, "\e[31mQuantidade inválida. Digite novamente:\e[0m") # Validação usando regex
    end

    preco = @prompt.ask("Digite o preço:", convert: :float) do |q|
      q.validate(/\A[1-9]\d*(\.\d+)?\z/, "\e[31mPreço inválido. Digite novamente:\e[0m") # Validação usando regex
    end

    produto = Produto.new(nome, quantidade, preco)
    @estoque << produto

    puts "\n\e[42m\e[30mProduto adicionado ao estoque com sucesso!\e[0m"
  end

  def atualizar_produto
    nome = @prompt.ask("Digite o nome do produto a ser atualizado:")

    produto = procurar_produto(nome)

    if produto
      quantidade = @prompt.ask("Digite a nova quantidade:", convert: :int) do |q|
        q.validate(/\A-?\d+\z/, "\e[31mQuantidade inválida. Digite novamente:\e[0m") # Validação usando regex
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

terminal = TerminalDeGestaoDeEstoque.new
prompt = TTY::Prompt.new

loop do
  escolha = prompt.select("\e[47m\e[30m=== Terminal de Gestão de Estoque ===\e[0m") do |menu|
    menu.choice "Adicionar Produto", 1
    menu.choice "Atualizar Produto", 2
    menu.choice "Visualizar Estoque", 3
    menu.choice "Sair", 0
  end

  case escolha
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
