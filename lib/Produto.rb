class Produto
  attr_accessor :codigo, :nome, :quantidade, :preco, :descricao

  def initialize(codigo, nome, quantidade, preco, descricao)
    @codigo = codigo
    @nome = nome
    @quantidade = quantidade
    @preco = preco
    @descricao = descricao
  end
end
