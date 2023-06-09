require "securerandom"

class TerminalDeGestaoDeEstoque
  def initialize
    @estoque = []
    @quantidade_baixas = 0
    @total_lucro = 0.0
  end

  def adicionar_produto(prompt)
    nome = prompt.ask("\nDigite o nome do Produto:") do |q|
      q.modify :strip
      q.validate(/^.*(?!\d+$)\S+$/, "O nome do produto deve conter pelo menos uma letra. Por favor, digite um valor válido.")
    end

    descricao = prompt.ask("Digite a descrição do Produto:") do |q|
      q.modify :strip
      q.validate(/^\S+(?:\s+\S+){4,}$/, "A descrição do produto deve conter no mínimo 5 palavras. Por favor, digite um valor válido.")
    end

    quantidade = prompt.ask("Digite a quantidade:", convert: :int) do |q|
      q.validate(/^\d+$/, "Quantidade inválida. Digite novamente.")
    end

    preco = prompt.ask("Digite o preço:", convert: :float) do |q|
      q.validate(/^\d+(\.\d+)?$/, "Preço inválido. Digite novamente.")
    end

    if quantidade <= 0 || preco <= 0
      puts "\n\e[31mQuantidade e preço devem ser valores maiores que zero.\e[0m"
    else
      codigo = generate_random_code
      produto = Produto.new(codigo, nome, quantidade, preco, descricao)
      @estoque << produto

      puts "\n\e[42m\e[30mProduto adicionado ao estoque com sucesso!\e[0m"
      puts "\n\e[33mCódigo do Produto: #{codigo}\e[0m"
    end
  end

  def atualizar_produto(prompt)
    codigo = prompt.ask("Digite o código do produto a ser atualizado:")

    produto = procurar_produto(codigo)

    if produto
      choices = [
        { name: "Atualizar quantidade", value: :atualizar_quantidade },
        { name: "Atualizar preço", value: :atualizar_preco },
        { name: "Cancelar", value: :cancelar },
      ]

      action = prompt.select("Selecione o que deseja atualizar:", choices)

      case action
      when :atualizar_quantidade
        quantidade = prompt.ask("Digite a quantidade:", convert: :int) do |q|
          q.validate(/\A-?\d+\z/, "Quantidade inválida. Digite novamente.")
        end

        nova_quantidade = produto.quantidade + quantidade

        if nova_quantidade < 0
          puts "\n\e[31mQuantidade inválida. A subtração excede a quantidade atual.\e[0m"
        else
          produto.quantidade = nova_quantidade
          puts "\n\e[42m\e[30mQuantidade do produto atualizada com sucesso!\e[0m"
        end
      when :atualizar_preco
        preco = prompt.ask("Digite o novo preço:", convert: :float) do |q|
          q.validate(/\A\d+(\.\d+)?\z/, "Preço inválido. Digite novamente.")
        end

        produto.preco = preco
        puts "\n\e[42m\e[30mPreço do produto atualizado com sucesso!\e[0m"
      when :cancelar
        puts "\nCancelando atualização do produto."
      end
    else
      puts "\n\e[31mProduto não encontrado no estoque.\e[0m"
    end
  end

  def dar_baixa(prompt)
    codigo = prompt.ask("Digite o código do produto para dar baixa:")

    produto = procurar_produto(codigo)

    if produto
      quantidade_despacho = prompt.ask("Digite a quantidade a ser despachada:", convert: :int) do |q|
        q.validate(/^\d+$/, "Quantidade inválida. Digite novamente.")
      end

      if quantidade_despacho <= produto.quantidade
        produto.quantidade -= quantidade_despacho
        @quantidade_baixas += 1
        @total_lucro += quantidade_despacho * produto.preco
        puts "\n\e[42m\e[30mDespache realizado!\e[0m"
      else
        puts "\n\e[31mA quantidade a ser despachada excede a quantidade atual no estoque.\e[0m"
      end
    else
      puts "\n\e[31mProduto não encontrado no estoque.\e[0m"
    end
  end

  def visualizar_estoque(prompt)
    codigo_produto = prompt.ask("Digite o código do produto para visualizar suas informações:")

    produto = procurar_produto(codigo_produto)

    if produto
      puts "\nInformações do Produto '#{produto.nome}':"
      puts "Código: #{produto.codigo}"
      puts "Quantidade: #{produto.quantidade}"
      puts "Preço: R$#{produto.preco}"
      puts "Descrição: #{produto.descricao}"
    else
      puts "\n\e[31mProduto não encontrado no estoque.\e[0m"
    end
  end

  def quantidade_baixas
    @quantidade_baixas
  end

  def calcular_porcentagem_lucro
    return 0.0 if @quantidade_baixas == 0

    lucro = (@total_lucro - (@quantidade_baixas * 10)) * 100.0 / (@quantidade_baixas * 10)
    lucro.round(2)
  end

  def gerar_relatorio
    return puts "\n\e[31mNão existem produtos no estoque para gerar relatório.\e[0m" if @estoque.empty?

    File.open("relatorio.txt", "w") do |file|
      file.puts "Relatório de Estoque\n\n"

      file.puts "Produtos em Estoque:"
      file.puts "====================="
      @estoque.each do |produto|
        file.puts "Código: #{produto.codigo}"
        file.puts "Nome: #{produto.nome}"
        file.puts "Quantidade: #{produto.quantidade}"
        file.puts "Preço: R$#{produto.preco}"
        file.puts "Descrição: #{produto.descricao}"
        file.puts "---------------------"
      end

      file.puts "\nQuantidade de Baixas Realizadas: #{quantidade_baixas}"
      file.puts "Porcentagem de Lucro: #{calcular_porcentagem_lucro}%"
    end

    puts "\n\e[42m\e[30mRelatório gerado com sucesso! Confira o arquivo relatorio.txt\e[0m"
  end

  private

  def procurar_produto(codigo)
    @estoque.find { |produto| produto.codigo == codigo }
  end

  def generate_random_code
    SecureRandom.alphanumeric(6).upcase
  end
end
