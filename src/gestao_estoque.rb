class GestaoEstoque
  def initialize
    @estoque = {}
  end

  def adicionar_item(descricao, tamanho, cor, preco, fornecedor, quantidade)
    item = { descricao: descricao, tamanho: tamanho, cor: cor, preco: preco, fornecedor: fornecedor }
    @estoque[item] ||= 0
    @estoque[item] += quantidade
  end

  def remover_item(descricao, tamanho, cor, preco, fornecedor, quantidade)
    item = { descricao: descricao, tamanho: tamanho, cor: cor, preco: preco, fornecedor: fornecedor }
    return if @estoque[item].nil? || @estoque[item] < quantidade

    @estoque[item] -= quantidade
  end

  def verificar_estoque(descricao, tamanho, cor, preco, fornecedor)
    item = { descricao: descricao, tamanho: tamanho, cor: cor, preco: preco, fornecedor: fornecedor }
    @estoque[item] ||= 0
    @estoque[item]
  end

  def exibir_estoque
    @estoque.each_with_index do |(item, quantidade), index|
      puts "\n"
      puts "--------------------------------"
      puts "Item #{index + 1}"
      puts "Descrição: #{item[:descricao]}"
      puts "Tamanho: #{item[:tamanho]}"
      puts "Cor: #{item[:cor]}"
      puts "Preço: #{item[:preco]}"
      puts "Fornecedor: #{item[:fornecedor]}"
      puts "Quantidade: #{quantidade}"
      puts "\n"
      puts "--------------------------------"
    end
  end

  def obter_item_por_indice(indice)
    @estoque.keys[indice - 1]
  end
end
