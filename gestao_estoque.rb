class GestaoEstoque
    #construtor
    def initialize
        @estoque = {}
    end
    #metodo
    def adicionar_item(item, quantidade)
        @estoque[item] ||= 0
        @estoque[item] += quantidade
    end
    #metodo
    def remover_item(item, quantidade)
        return if @estoque[item].nil? || @estoque[item] < quantidade
        
        @estoque[item] -= quantidade
    end
    #metodo
    def verificar_estoque(item)
        @estoque[item] || 0
        @estoque[item]
    end
    #metodo
    def exibir_estoque
        @estoque.each do |item, quantidade|
            puts "#{item}: #{quantidade}"
        end
    end
end

#criando objeto de estoque
gestao_estoque = GestaoEstoque.new

#loop menu
loop do
    puts "===== Sistema de Gestão de Estoque ====="
    puts "1. Adicionar item"
    puts "2. Remover item"
    puts "3. Verificar estoque de um item"
    puts "4. Exibir estoque"
    puts "0. Sair"

    print "Escolha uma opção: "
    opcao = gets.chomp.to_i

    case opcao
    when 1 
        print "Digite o nome do item a ser adicionado: "
        item = gets.chomp
        print "Digite a quantidade a ser adicionada: "
        quantidade = gets.chomp.to_i
        gestao_estoque.adicionar_item(item, quantidade)
        puts "Item adicionado ao estoque"
    when 2
        print "Digite o nome do item a ser removido: "
        item = gets.chomp
        print "Digite a quantidade a ser removida: "
        quantidade = gets.chomp.to_i
        gestao_estoque.remover_item(item, quantidade)
        puts "Item removido do estoque."
    when 3
        print "Digite o nome do item a ser verificado: "
        item = gets.chomp
        quantidade = gestao_estoque.verificar_estoque(item)
        puts "Quantidade em estoque: #{quantidade}"
    when 4
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