require "securerandom"
require_relative "../lib/Produto"
require_relative "../lib/TerminalDeGestãodeEstoque"

RSpec.describe TerminalDeGestaoDeEstoque do
  let(:prompt) { TTY::Prompt.new }
  let(:terminal) { TerminalDeGestaoDeEstoque.new }

  describe "#adicionar_produto" do
    it "adiciona um novo produto ao estoque" do
      allow(prompt).to receive(:ask).and_return("Produto A", "Descrição do Produto A", 10, 9.99)

      terminal.adicionar_produto(prompt)

      expect(terminal.quantidade_baixas).to eq(0)
      expect(terminal.calcular_porcentagem_lucro).to eq(0.0)
      expect(terminal.instance_variable_get(:@estoque).size).to eq(1)

      produto = terminal.instance_variable_get(:@estoque).first
      expect(produto.nome).to eq("Produto A")
      expect(produto.descricao).to eq("Descrição do Produto A")
      expect(produto.quantidade).to eq(10)
      expect(produto.preco).to eq(9.99)
    end

    it "exibe mensagem de erro para quantidade ou preço inválidos" do
      allow(prompt).to receive(:ask).and_return("Produto B", "Descrição do Produto B", -5, 0)

      expect { terminal.adicionar_produto(prompt) }.to output(/\e\[31mQuantidade e preço devem ser valores maiores que zero.\e\[0m/).to_stdout
      expect(terminal.instance_variable_get(:@estoque).size).to eq(0)
    end
  end

  describe "#atualizar_produto" do
    before do
      terminal.instance_variable_set(:@estoque, [
        Produto.new("ABC123", "Produto A", 10, 9.99, "Descrição do Produto A"),
        Produto.new("DEF456", "Produto B", 5, 14.99, "Descrição do Produto B"),
      ])
    end

    it "atualiza a quantidade de um produto" do
      allow(prompt).to receive(:select).and_return("ABC123")
      allow(prompt).to receive(:ask).and_return("1")

      terminal.atualizar_produto(prompt)

      produto = terminal.instance_variable_get(:@estoque).first
      expect(produto.quantidade).to eq(11)
    end

    it "atualiza o preço de um produto" do
      allow(prompt).to receive(:select).and_return("DEF456")
      allow(prompt).to receive(:ask).and_return("15.99")

      terminal.atualizar_produto(prompt)

      produto = terminal.instance_variable_get(:@estoque).last
      expect(produto.preco).to eq(15.99)
    end

    it "exibe mensagem de erro para código de produto inválido" do
      allow(prompt).to receive(:select).and_return("XYZ789")

      expect { terminal.atualizar_produto(prompt) }.to output(/\e\[31mProduto não encontrado no estoque.\e\[0m/).to_stdout
    end

    it "exibe mensagem de erro para quantidade inválida" do
      allow(prompt).to receive(:select).and_return("ABC123")
      allow(prompt).to receive(:ask).and_return("-10")

      expect { terminal.atualizar_produto(prompt) }.to output(/\e\[31mQuantidade inválida. Digite novamente.\e\[0m/).to_stdout
    end
  end

  describe "#dar_baixa" do
    before do
      terminal.instance_variable_set(:@estoque, [
        Produto.new("ABC123", "Produto A", 10, 9.99, "Descrição do Produto A"),
        Produto.new("DEF456", "Produto B", 5, 14.99, "Descrição do Produto B"),
      ])
    end

    it "realiza a baixa de um produto" do
      allow(prompt).to receive(:select).and_return("ABC123")
      allow(prompt).to receive(:ask).and_return("5")

      terminal.dar_baixa(prompt)

      produto = terminal.instance_variable_get(:@estoque).first
      expect(produto.quantidade).to eq(5)
      expect(terminal.quantidade_baixas).to eq(1)
      expect(terminal.calcular_porcentagem_lucro).to eq(439.9)
    end

    it "exibe mensagem de erro para código de produto inválido" do
      allow(prompt).to receive(:select).and_return("XYZ789")

      expect { terminal.dar_baixa(prompt) }.to output(/\e\[31mProduto não encontrado no estoque.\e\[0m/).to_stdout
    end

    it "exibe mensagem de erro para quantidade de baixa inválida" do
      allow(prompt).to receive(:select).and_return("ABC123")
      allow(prompt).to receive(:ask).and_return("15")

      expect { terminal.dar_baixa(prompt) }.to output(/\e\[31mA quantidade a ser despachada excede a quantidade atual no estoque.\e\[0m/).to_stdout
    end
  end

  describe "#visualizar_estoque" do
    before do
      terminal.instance_variable_set(:@estoque, [
        Produto.new("ABC123", "Produto A", 10, 9.99, "Descrição do Produto A"),
        Produto.new("DEF456", "Produto B", 5, 14.99, "Descrição do Produto B"),
      ])
    end

    it "exibe as informações de um produto" do
      allow(prompt).to receive(:select).and_return("DEF456")

      expect { terminal.visualizar_estoque(prompt) }.to output(/Nome: Produto B\nQuantidade: 5\nPreço: R\$14.99\nDescrição: Descrição do Produto B/).to_stdout
    end

    it "exibe mensagem de erro para código de produto inválido" do
      allow(prompt).to receive(:select).and_return("XYZ789")

      expect { terminal.visualizar_estoque(prompt) }.to output(/\e\[31mProduto não encontrado no estoque.\e\[0m/).to_stdout
    end
  end

  describe "#gerar_relatorio" do
    context "quando o estoque está vazio" do
      it "exibe mensagem de erro" do
        expect { terminal.gerar_relatorio }.to output(/\e\[31mNão existem produtos no estoque para gerar relatório.\e\[0m/).to_stdout
      end
    end

    context "quando o estoque possui produtos" do
      before do
        terminal.instance_variable_set(:@estoque, [
          Produto.new("ABC123", "Produto A", 10, 9.99, "Descrição do Produto A"),
          Produto.new("DEF456", "Produto B", 5, 14.99, "Descrição do Produto B"),
        ])
        terminal.instance_variable_set(:@quantidade_baixas, 2)
        terminal.instance_variable_set(:@total_lucro, 100.0)
      end

      it "gera o relatório corretamente" do
        expect(File).to receive(:open).with("relatorio.txt", "w").and_yield(spy)

        expect { terminal.gerar_relatorio }.to output(/\n\e\[42m\e\[30mRelatório gerado com sucesso! Confira o arquivo relatorio.txt\e\[0m/).to_stdout
      end
    end
  end
end
