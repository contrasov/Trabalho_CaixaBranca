require_relative "gestao_estoque"

gestao_estoque = GestaoEstoque.new

loop do
  puts "\n"
  puts "\e[1m===== Sistema de Gestão de Estoque =====\e[0m" # texto em negrito
  puts "\e[33m1. Adicionar item\e[0m"
  puts "\e[33m2. Remover item\e[0m"
  puts "\e[33m3. Verificar estoque de um item\e[0m"
  puts "\e[33m4. Exibir estoque\e[0m"
  puts "\e[31m0. Sair\e[0m"

  print "Escolha uma opção: "
  opcao = gets.chomp.to_i

  case opcao
  when 1
    puts "\n"
    print "Digite o nome do item a ser adicionado: "
    item = gets.chomp
    print "Digite a quantidade a ser adicionada: "
    quantidade = gets.chomp.to_i

    descricao = []
    tamanhos = []
    cores = []
    preco = []
    fornecedor = []

    loop do
      print "Digite a descrição do item (ou digite 'fim' para encerrar): "
      descricao_item = gets.chomp
      break if descricao_item.downcase == "fim"
      descricao << descricao_item

      print "Digite os tamanhos disponíveis do item: "
      tamanho_item = gets.chomp
      tamanhos << tamanho_item

      print "Digite as cores do item: "
      cor_item = gets.chomp
      cores << cor_item

      print "Digite o preço do item: "
      preco_item = gets.chomp.to_f
      preco << preco_item

      print "Digite o fornecedor do item: "
      fornecedor_item = gets.chomp
      fornecedor << fornecedor_item
    end

    gestao_estoque.adicionar_item(descricao, tamanhos, cores, preco, fornecedor, quantidade)
    puts "Item adicionado ao estoque."
    puts "\n"
  when 2
    puts "\n"
    puts "Selecione o item a ser removido: "

    gestao_estoque.exibir_estoque

    print "Digite o número do item a ser removido (ou '0' para cancelar)"
    item_selecionado = gets.chomp.to_i

    if item_selecionado == 0
      puts "Operação cancelada."
      puts "\n"
      next
    end

    item_remover = gestao_estoque.obter_item_por_indice(item_selecionado)
    print "Digite a quantidade a ser removida: "
    quantidade = gets.chomp.to_i

    gestao_estoque.remover_item(item_remover[:descricao], item_remover[:tamanho], item_remover[:cor], item_remover[:preco], item_remover[:fornecedor], quantidade)

    puts "Item removido do estoque."
    puts "\n"
  when 3
    print "Digite o nome do item a ser verificado: "
    item = gets.chomp

    descricao = []
    tamanhos = []
    cores = []
    preco = []
    fornecedor = []

    loop do
      print "Digite a descrição do item (ou 'fim' para encerrar): "
      descricao_item = gets.chomp
      break if descricao_item.downcase == "fim"

      descricao << descricao_item

      print "Digite os tamanhos disponíveis do item: "
      tamanho_item = gets.chomp
      tamanhos << tamanho_item

      print "Digite as cores do item: "
      cor_item = gets.chomp
      cores << cor_item

      print "Digite o preço do item: "
      preco_item = gets.chomp.to_f
      preco << preco_item

      print "Digite o fornecedor do item: "
      fornecedor_item = gets.chomp
      fornecedor << fornecedor_item
    end

    quantidade = gestao_estoque.verificar_estoque(descricao, tamanhos, cores, preco, fornecedor)
    puts "Quantidade em estoque: #{quantidade}"
  when 4
    puts "\n"
    puts "Estoque:"
    gestao_estoque.exibir_estoque
  when 0
    puts "Saindo do sistema..."
    break
  else
    puts "Opção inválida. Tente novamente."
  end

  puts "\n"
end
