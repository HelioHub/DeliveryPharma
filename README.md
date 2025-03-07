# Projeto DeliveryPharma - Teste Técnico - Hélio Marques

Cadastro de Pedidos e Ordem de Entrega dos Produtos

## Agredecimento pela Oportunidade

![## Atenção](https://github.com/HelioHub/DeliveryPharma/blob/main/Imagens/Atencao3.png)
![## Atenção](https://github.com/HelioHub/DeliveryPharma/blob/main/Imagens/Atencao.png)

## Diagrama de Entidade e Relacionamento 

![## Diagrama de Entidade e Relacionamento CX](https://github.com/HelioHub/DeliveryPharma/blob/main/BD/EERDiagram.png)

## Arquitetura do Sistema 

	• Aplicação Client/Server;
	• Aplicação Clean Code;
	• Orientação a objetos;
	• Padrões de projeto;
	• Garantir integridade do dados;
	• Padrão MVC;
	• Camada de persistência Firedac.

## Tecnologia 

	Embarcadero® Delphi Community Edition Version 29.0.51961.7529 
	Copyright © 2024 Embarcadero Technologies, Inc. All Rights Reserved.

## PW DB FireBird e IBExpert

	Firebird-2.5.9.27139_0_Win32.exe
	https://www.firebirdsql.org/en/firebird-2-5/
	user: SYSDBA
	password: masterkey
	
	https://www.ibexpert.net/downloadcenter/
	
## GITHub

	git init
	git remote add origin git@github.com:HelioHub/DeliveryPharma.git
	git add .
	git commit -m "Firts commit"
	git push -u origin main
	
##  Aplicação do Clean Code

	https://balta.io/artigos/clean-code	

## Criação do Banco de Dados e Objetos do Banco

	-- ==== Projeto DBDeliveryPharma === --
	-- ====   Hélio  Marques  === --

	-- ==== Criação das tables e indexes === --

	CONNECT 'C:\DeliveryPharma\BD\dbDeliveryPharma.fdb' USER 'SYSDBA' PASSWORD 'masterkey';

	SET TRANSACTION;

	-- Drop das tabelas (se existirem)
	DROP TABLE ItensPedido;
	DROP GENERATOR GEN_ItensPedido_ID;
	DROP TABLE PedidosEntrega;
	DROP GENERATOR GEN_PedidosEntrega_ID;
	DROP TABLE OrdemEntrega;
	DROP GENERATOR GEN_OrdemEntrega_ID;
	DROP TABLE Produtos;
	DROP GENERATOR GEN_Produtos_ID;
	DROP TABLE Pedidos;
	DROP GENERATOR GEN_Pedidos_ID;
	DROP TABLE Clientes;
	DROP GENERATOR GEN_Clientes_ID;
	DROP TABLE TipoProduto;
	DROP GENERATOR GEN_TipoProduto_ID;
	DROP TABLE Entregador;
	DROP GENERATOR GEN_Entregador_ID;

	-- Criação da tabela Clientes
	CREATE TABLE Clientes (
	  CodigoClientes INTEGER NOT NULL PRIMARY KEY,
	  CNPJClientes VARCHAR(14),
	  NomeClientes VARCHAR(80),
	  CEPClientes VARCHAR(8),
	  RuaClientes VARCHAR(100),
	  BairroClientes VARCHAR(50),
	  CidadeClientes VARCHAR(50),
	  UFClientes VARCHAR(2),
	  LongitudeClientes DECIMAL(17,7),
	  LatitudeClientes DECIMAL(17,7),
	  CodIBGEClientes VARCHAR(10),
	  NomeFantasiaClientes VARCHAR(100),
	  SitCadastralClientes VARCHAR(30),
	  NumeroRuaClientes INTEGER
	);
	CREATE GENERATOR GEN_Clientes_ID;
	CREATE INDEX INDEX_NOME ON Clientes (NomeClientes);

	-- Criação da tabela TipoProduto
	CREATE TABLE TipoProduto (
	  idTipoProduto INTEGER NOT NULL PRIMARY KEY,
	  DescricaoTipoProduto VARCHAR(50),
	  PrioridadeTipoProduto SMALLINT DEFAULT 9 CHECK (PrioridadeTipoProduto IN (1,2,3,4,5,6,7,8,9)),   
	  PrescricaoTipoProduto SMALLINT DEFAULT 0 CHECK (PrescricaoTipoProduto IN (0, 1)),   
	  CuidadosTipoProduto SMALLINT DEFAULT 0 CHECK (CuidadosTipoProduto IN (0, 1)),   
	  DataValidadeTipoProduto SMALLINT DEFAULT 0 CHECK (DataValidadeTipoProduto IN (0, 1))   
	);
	CREATE GENERATOR GEN_TipoProduto_ID;
	/*
	  Prioridade na Entrega + Data da Ordem
	  ----------------------------------------------
	  PrioridadeTipoProduto - {1-Primeira, 2-Segunda, 3-Terceira, ..., 9-Normal};

	  Produto tem ou não a definição do Campo:
	  ----------------------------------------------
	  PrescricaoTipoProduto - {0-Não/1-Sim};
	  CuidadosTipoProduto   - {0-Não/1-Sim};
	  DataValidadeTipoProduto - {0-Não/1-Sim};
	*/

	-- Criação da tabela Produtos 
	CREATE TABLE Produtos (
	  idProdutos INTEGER NOT NULL PRIMARY KEY,
	  TipoProdutoProdutos INTEGER NOT NULL,
	  CodigoProdutos VARCHAR(10),
	  DescricaoProdutos VARCHAR(80),
	  QuantidadeProdutos DECIMAL(17,3),
	  UndProdutos VARCHAR(3),
	  PrecoVendaProdutos DECIMAL(17,3),
	  PrescricaoProdutos VARCHAR(400),
	  CuidadosArmProdutos VARCHAR(400),
	  DataValidadeProdutos DATE,
	  CONSTRAINT FK_TipoProduto FOREIGN KEY (TipoProdutoProdutos)
		REFERENCES TipoProduto (idTipoProduto)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
	);
	CREATE GENERATOR GEN_Produtos_ID;
	CREATE INDEX INDEX_DESCRICAO ON Produtos (DescricaoProdutos);
	CREATE INDEX FK_TIPOPRODUTO_idx ON Produtos (TipoProdutoProdutos);

	-- Criação da tabela Pedidos
	CREATE TABLE Pedidos (
	  NumeroPedidos INTEGER NOT NULL PRIMARY KEY,
	  DataEmissaoPedidos TIMESTAMP,
	  ClientePedidos INTEGER,
	  ValorTotalPedidos DECIMAL(17,3),
	  StatusPedidos SMALLINT DEFAULT 0 CHECK (StatusPedidos IN (0, 1)),
	  CONSTRAINT FK_CLIENTE FOREIGN KEY (ClientePedidos)
		REFERENCES Clientes (CodigoClientes)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
	);
	CREATE GENERATOR GEN_Pedidos_ID;
	CREATE INDEX FK_CLIENTE_idx ON Pedidos (ClientePedidos);
	CREATE INDEX INDEX_DATAEMISSAO ON Pedidos (DataEmissaoPedidos);
	/*
	  StatusPedidos:
	  --------------
	  0 - Em Aberto;
	  1 - Fechado;
	*/

	-- Criação da tabela ItensPedido
	CREATE TABLE ItensPedido (
	  idItensPedido INTEGER NOT NULL PRIMARY KEY,
	  PedidoItensPedido INTEGER,
	  ProdutoItensPedido INTEGER,
	  QuantidadeItensPedido DECIMAL(10,2),
	  VlrUnitarioItensPedido DECIMAL(17,3),
	  VlrTotalItensPedido DECIMAL(17,3),
	  CONSTRAINT FK_PEDIDO FOREIGN KEY (PedidoItensPedido)
		REFERENCES Pedidos (NumeroPedidos)
		ON DELETE CASCADE
		ON UPDATE NO ACTION,
	  CONSTRAINT FK_PRODUTO FOREIGN KEY (ProdutoItensPedido)
		REFERENCES Produtos (idProdutos)
		ON DELETE CASCADE
		ON UPDATE NO ACTION
	);
	CREATE GENERATOR GEN_ItensPedido_ID;
	CREATE INDEX FK_PEDIDO_idx ON ItensPedido (PedidoItensPedido);
	CREATE INDEX FK_PRODUTO_idx ON ItensPedido (ProdutoItensPedido);

	-- Criação da tabela Entregador
	CREATE TABLE Entregador (
	  idEntregador INTEGER NOT NULL PRIMARY KEY,
	  NomeEntregador VARCHAR(50),
	  SituacaoEntregador SMALLINT DEFAULT 0
	);
	CREATE GENERATOR GEN_Entregador_ID;
	/*
	  Situação:
	  ---------
	  0 - Disponível;
	  1 - Não Disponível;
	*/


	-- Criação da tabela OrdemEntrega
	CREATE TABLE OrdemEntrega (
	  idOrdemEntrega INTEGER NOT NULL PRIMARY KEY,
	  EntregadorOrdenEntrega INTEGER NOT NULL,
	  EmissaoOrdemEntrega TIMESTAMP,
	  SaidaOrdemEntrega TIMESTAMP,
	  ChegadaOrdemEntrega TIMESTAMP,
	  StatusOrdemEntrega SMALLINT DEFAULT 0 CHECK (StatusOrdemEntrega IN (0, 1, 2, 3)),
	  OBSOrdemEntrega VARCHAR(1000),
	  CONSTRAINT fk_OrdemEntrega_Entregador FOREIGN KEY (EntregadorOrdenEntrega)
		REFERENCES Entregador (idEntregador)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
	);
	CREATE GENERATOR GEN_OrdemEntrega_ID;
	CREATE INDEX FK_ENTREGADORORDEMENTREGA_idx ON OrdemEntrega (EntregadorOrdenEntrega);
	/*
	  Status:
	  -------
	  0 - Pendente;
	  1 - Em Andamento;
	  2 - Entregue Total;
	  3 - Entregue Parcial;
	*/


	-- Criação da tabela PedidosEntrega
	CREATE TABLE PedidosEntrega (
	  idPedidosEntrega INTEGER NOT NULL PRIMARY KEY,
	  PedidoPedidosEntrega INTEGER NOT NULL,
	  OrdemEntregaPedidosEntrega INTEGER NOT NULL,
	  StatusPedidosEntrega SMALLINT DEFAULT 0 CHECK (StatusPedidosEntrega IN (0, 1, 2, 3)),
	  OBSPedidosEntrega VARCHAR(1000),
	  CONSTRAINT fk_PedidosEntrega_Pedidos FOREIGN KEY (PedidoPedidosEntrega)
		REFERENCES Pedidos (NumeroPedidos)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	  CONSTRAINT fk_PedidosEntrega_OrdemEntrega FOREIGN KEY (OrdemEntregaPedidosEntrega)
		REFERENCES OrdemEntrega (idOrdemEntrega)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
	);
	CREATE GENERATOR GEN_PedidosEntrega_ID;
	CREATE INDEX FK_PEDIDOS_idx ON PedidosEntrega (PedidoPedidosEntrega);
	CREATE INDEX FK_ORDEMENTREGA_idx ON PedidosEntrega (OrdemEntregaPedidosEntrega);
	/*
	  Status:
	  -------
	  0 - Pendente;
	  1 - Em Andamento;
	  2 - Entregue;
	  3 - Não Entregue/Cancelado
	*/

	--DELETE FROM Clientes;
	--DELETE FROM TipoProduto;
	--DELETE FROM Produtos;
	--DELETE FROM Entregador;

	-- Clientes
	INSERT INTO CLIENTES (CODIGOCLIENTES, CNPJCLIENTES, NOMECLIENTES, CEPCLIENTES, RUACLIENTES, BAIRROCLIENTES, CIDADECLIENTES, UFCLIENTES, LONGITUDECLIENTES, LATITUDECLIENTES, CODIBGECLIENTES, NOMEFANTASIACLIENTES, SITCADASTRALCLIENTES, NUMERORUACLIENTES)
	VALUES (GEN_ID(GEN_Clientes_ID, 1), '14796606000190', 'ADYEN DO BRASIL INSTITUICAO DE PAGAMENTO LTDA.', '60744325', 'Rua Shirley Girao', 'Passare', 'Fortaleza', 'CE', 0, 0, '2304400', 'ADYEN LATIN AMERICA', 'ATIVA', 571);
	INSERT INTO CLIENTES (CODIGOCLIENTES, CNPJCLIENTES, NOMECLIENTES, CEPCLIENTES, RUACLIENTES, BAIRROCLIENTES, CIDADECLIENTES, UFCLIENTES, LONGITUDECLIENTES, LATITUDECLIENTES, CODIBGECLIENTES, NOMEFANTASIACLIENTES, SITCADASTRALCLIENTES, NUMERORUACLIENTES)
	VALUES (GEN_ID(GEN_Clientes_ID, 1), '12345678000195', 'ROBERIO JOSE DOS SANTOS 16952477870', '60744320', 'Rua 4', 'Passare', 'Fortaleza', 'CE', 0, 0, '2304400', '', 'BAIXADA', 20);
	INSERT INTO CLIENTES (CODIGOCLIENTES, CNPJCLIENTES, NOMECLIENTES, CEPCLIENTES, RUACLIENTES, BAIRROCLIENTES, CIDADECLIENTES, UFCLIENTES, LONGITUDECLIENTES, LATITUDECLIENTES, CODIBGECLIENTES, NOMEFANTASIACLIENTES, SITCADASTRALCLIENTES, NUMERORUACLIENTES)
	VALUES (GEN_ID(GEN_Clientes_ID, 1), '09346601000125', 'B3 S.A. - BRASIL, BOLSA, BALCAO', '60744330', 'Rua 5', 'Passare', 'Fortaleza', 'CE', 0, 0, '2304400', 'B3 S.A. BRASIL, BOLSA, BALCAO', 'ATIVA', 2);

	-- Tipo de Produto
	INSERT INTO TIPOPRODUTO (IDTIPOPRODUTO, DESCRICAOTIPOPRODUTO, PRIORIDADETIPOPRODUTO, PRESCRICAOTIPOPRODUTO, CUIDADOSTIPOPRODUTO, DATAVALIDADETIPOPRODUTO)
	VALUES (GEN_ID(GEN_TipoProduto_ID, 1), 'MEDICAMENTOS SENSIVEIS', 1, 1, 1, 1);
	INSERT INTO TIPOPRODUTO (IDTIPOPRODUTO, DESCRICAOTIPOPRODUTO, PRIORIDADETIPOPRODUTO, PRESCRICAOTIPOPRODUTO, CUIDADOSTIPOPRODUTO, DATAVALIDADETIPOPRODUTO)
	VALUES (GEN_ID(GEN_TipoProduto_ID, 1), 'MEDICAMENTOS CONTROLADOS', 2, 1, 1, 1);
	INSERT INTO TIPOPRODUTO (IDTIPOPRODUTO, DESCRICAOTIPOPRODUTO, PRIORIDADETIPOPRODUTO, PRESCRICAOTIPOPRODUTO, CUIDADOSTIPOPRODUTO, DATAVALIDADETIPOPRODUTO)
	VALUES (GEN_ID(GEN_TipoProduto_ID, 1), 'MEDICAMENTOS COMUNS', 9, 0, 0, 1);
	INSERT INTO TIPOPRODUTO (IDTIPOPRODUTO, DESCRICAOTIPOPRODUTO, PRIORIDADETIPOPRODUTO, PRESCRICAOTIPOPRODUTO, CUIDADOSTIPOPRODUTO, DATAVALIDADETIPOPRODUTO)
	VALUES (GEN_ID(GEN_TipoProduto_ID, 1), 'COSMETICOS', 9, 0, 0, 1);
	INSERT INTO TIPOPRODUTO (IDTIPOPRODUTO, DESCRICAOTIPOPRODUTO, PRIORIDADETIPOPRODUTO, PRESCRICAOTIPOPRODUTO, CUIDADOSTIPOPRODUTO, DATAVALIDADETIPOPRODUTO)
	VALUES (GEN_ID(GEN_TipoProduto_ID, 1), 'PRODUTOS GERAIS', 9, 0, 0, 0);
	INSERT INTO TIPOPRODUTO (IDTIPOPRODUTO, DESCRICAOTIPOPRODUTO, PRIORIDADETIPOPRODUTO, PRESCRICAOTIPOPRODUTO, CUIDADOSTIPOPRODUTO, DATAVALIDADETIPOPRODUTO)
	VALUES (GEN_ID(GEN_TipoProduto_ID, 1), 'PRODUTOS GERAIS PERECIVEIS', 9, 0, 0, 1);

	-- Produtos
	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS)
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'MEDICAMENTOS COMUNS'), 'MED001', 'Paracetamol', 50, 'Und', 10, '', '', '2024-06-30');
	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS)
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'MEDICAMENTOS COMUNS'), 'MED002', 'Dipirona', 30, 'Und', 11, '', '', '2023-12-15');

	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS) 
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'MEDICAMENTOS CONTROLADOS'), 'MED003', 'Rivotril', 10, 'Und', 20, '', '', '2023-09-20');
	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS) 
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'MEDICAMENTOS CONTROLADOS'), 'MED003', 'Ritalina', 20, 'Und', 21, '', '', '2024-03-31');

	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS) 
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'MEDICAMENTOS SENSIVEIS'), 'MED005', 'Insulina', 5, 'Fra', 30, '', 'Refrigerado entre 2°C e 8°C', '2023-10-31');
	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS) 
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'MEDICAMENTOS SENSIVEIS'), 'MED006', 'Vacina da COVID-19', 50, 'Dos', 31, '', 'Congelado a -20°C', '2023-11-30');

	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS) 
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'COSMETICOS'), 'COS001', 'Creme Hidratante', 20, 'Und', 40, '', '', '2024-02-28');
	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS) 
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'COSMETICOS'), 'COS002', 'Perfume Feminino', 15, 'Und', 41, '', '', '2025-06-30');

	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS) 
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'PRODUTOS GERAIS PERECIVEIS'), 'PER001', 'Suplemento de Colageno', 30, 'Und', 50, '', '', '2023-08-31');
	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS) 
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'PRODUTOS GERAIS PERECIVEIS'), 'PER002', 'Leite Infantil', 25, 'Und', 51, '', '', '2023-10-15');

	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS) 
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'PRODUTOS GERAIS'), 'NPER001', 'Pasta de Dente', 50, 'Und', 60, '', '', NULL);
	INSERT INTO PRODUTOS (IDPRODUTOS, TIPOPRODUTOPRODUTOS, CODIGOPRODUTOS, DESCRICAOPRODUTOS, QUANTIDADEPRODUTOS, UNDPRODUTOS, PRECOVENDAPRODUTOS, PRESCRICAOPRODUTOS, CUIDADOSARMPRODUTOS, DATAVALIDADEPRODUTOS) 
	VALUES (GEN_ID(GEN_Produtos_ID, 1), (select a.idtipoproduto from TipoProduto a where a.descricaotipoproduto = 'PRODUTOS GERAIS'), 'NPER002', 'Shampoo', 40, 'Und', 61, '', '', NULL);

	-- Entregadores
	INSERT INTO ENTREGADOR (IDENTREGADOR, NOMEENTREGADOR, SITUACAOENTREGADOR) VALUES (GEN_ID(GEN_Entregador_ID, 1), 'Paulo Cesar', 0);
	INSERT INTO ENTREGADOR (IDENTREGADOR, NOMEENTREGADOR, SITUACAOENTREGADOR) VALUES (GEN_ID(GEN_Entregador_ID, 1), 'Henrique Jose', 0);
	INSERT INTO ENTREGADOR (IDENTREGADOR, NOMEENTREGADOR, SITUACAOENTREGADOR) VALUES (GEN_ID(GEN_Entregador_ID, 1), 'João Pharma', 0);

	-- Confirma as alterações
	COMMIT;

## DUMP do Banco de Dados FireBird 2.5

   Encontra-se na pasta C:\<PROJETO>\DUMP

## Feito gráficos na Aplicação em HTML/CSS/JS do Pedido

    De Barra
![## Gráficos CX](https://github.com/HelioHub/DeliveryPharma/blob/main/Imagens/Grafico1.png)
![## Gráficos CX](https://github.com/HelioHub/DeliveryPharma/blob/main/Imagens/Grafico2.png)

	De Pizza
![## Gráficos CX](https://github.com/HelioHub/DeliveryPharma/blob/main/Imagens/GraficoPizza1.png)
![## Gráficos CX](https://github.com/HelioHub/DeliveryPharma/blob/main/Imagens/GraficoPizza2.png)



