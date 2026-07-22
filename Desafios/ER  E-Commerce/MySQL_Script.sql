-- create database ecommerce;
use ecommerce;

create table if not exists cliente(
	idCliente int primary key auto_increment,
    C_nome varchar(50) not null,
    sobrenome varchar(50) not null,
    doc_type enum("CPF", "CNPJ") not null,
    doc_num varchar(15) not null,
    endereco varchar(100) not null, -- xxxxxxxx, nnnn, bbbb
    cidade varchar(30) not null,
    UF char(2) not null,
    constraint unique_client unique(doc_num)
    );

create table if not exists entrega(
	idEntrega int primary key auto_increment,
    dataEntrega date,
    track_cod varchar(45),
    status_entrega varchar(50),
    constraint unique_entrega unique(track_cod)
);

create table if not exists fornecedor(
	idFornecedor int primary key auto_increment,
    F_nomefantasia varchar(255),
    F_nomesocial varchar(255) not null,
    CNPJ varchar(15) not null,
    localidade varchar(255) not null,
    contato varchar(11) not null,
    constraint unique_forn unique(CNPJ)
);

create table if not exists ex_vendedor(
	idVendedor int primary key auto_increment,
    V_nomefantasia varchar(255),
    V_nomesocial varchar(255),
    CNPJ varchar(15),
    CPF varchar(11),
    localidade varchar(255) not null,
    contato varchar(11) not null,
    constraint unique_vend_PJ unique(CNPJ),
    constraint unique_vend_PF unique(CPF)
);

create table if not exists produto(
	idProduto int primary key auto_increment,
    P_nome varchar(30) not null,
    descricao varchar(255),
    categoria varchar(30) not null,
    valor decimal(10,2) not null,
    avaliacao float default 0
);

create table if not exists estoque(
	idEstoque int primary key auto_increment,
    localidade varchar(255) not null
);

create table if not exists pagform(
	idPagamento int primary key auto_increment,
	pg_idClient int,
    modal_pag enum("Crédito","Débito") not null,
    card_num char(16),
    card_titular varchar(30),
    card_validade varchar(7),
    constraint fk_fpg_client foreign key (pg_idClient) references cliente(idCliente)
);

create table if not exists pedido(
	idPedido int primary key auto_increment,
    P_idCliente int,
    data_pedido datetime not null,
    status_pedido enum("Confirmado","Cancelado","Em Processamento") default "Em Processamento",
    frete decimal(10,2) not null,
	P_idEntrega int,
    constraint fk_pedido_cliente foreign key (P_idCliente) references cliente(idCliente),
    constraint fk_pedido_entrega foreign key (P_idEntrega) references entrega(idEntrega)
);

create table if not exists item_pedido(
	IP_idPedido int,
    IP_idProduto int,
    quantidade int default 1,
    preco_unitario decimal(10,2),
    primary key(IP_idPedido, IP_idProduto),
    constraint fk_IP_pedido foreign key (IP_idPedido) references pedido(idPedido),
    constraint fk_IP_produto foreign key (IP_idProduto) references produto(idProduto)
);

create table if not exists produto_estoque(
	PE_idEstoque int,
    PE_idProduto int,
    quantidade int default 1,
    primary key(PE_idEstoque, PE_idProduto),
    constraint fk_PE_estoque foreign key (PE_idEstoque) references estoque(idEstoque),
    constraint fk_PE_produto foreign key (PE_idProduto) references produto(idProduto)
);

create table if not exists produto_ex(
	PX_idVendedor int,
    PX_idProduto int,
    quantidade int not null,
    primary key(PX_idVendedor, PX_idProduto),
    constraint fk_PX_vendedorex foreign key (PX_idVendedor) references ex_vendedor(idVendedor),
    constraint fk_PX_produto foreign key (PX_idProduto) references produto(idProduto)
);

create table if not exists fornecedor_prod(
	FP_idFornecedor int,
    FP_idProduto int,
    primary key(FP_idFornecedor, FP_idProduto),
    constraint fk_FP_fornecedor foreign key (FP_idFornecedor) references fornecedor(idFornecedor),
    constraint fk_FP_produto foreign key (FP_idProduto) references produto(idProduto)
); -- a quantidade dos produtos de quem fornece está em estoque

-- Adicionando Dados
-- 1. CLIENTES (Focando em SP, RJ, MG e ES)
INSERT INTO cliente (idCliente, C_nome, sobrenome, doc_type, doc_num, endereco, cidade, UF) VALUES
(1, 'Carlos', 'Silva', 'CPF', '11122233344', 'Av Paulista, 1000', 'São Paulo', 'SP'),
(2, 'Ana', 'Souza', 'CPF', '22233344455', 'Rua Augusta, 250', 'São Paulo', 'SP'),
(3, 'Techcorp', 'LTDA', 'CNPJ', '12345678000190', 'Av Faria Lima, 3000', 'São Paulo', 'SP'),
(4, 'Bruno', 'Costa', 'CPF', '33344455566', 'Av Rio Branco, 100', 'Rio de Janeiro', 'RJ'),
(5, 'Carla', 'Dias', 'CPF', '44455566677', 'Rua do Catete, 15', 'Rio de Janeiro', 'RJ'),
(6, 'Daniel', 'Gomes', 'CPF', '55566677788', 'Av Afonso Pena, 500', 'Belo Horizonte', 'MG'),
(7, 'Elisa', 'Martins', 'CPF', '66677788899', 'Rua da Bahia, 120', 'Belo Horizonte', 'MG'),
(8, 'Inovacao', 'SA', 'CNPJ', '98765432000110', 'Av Nossa Sra do Carmo, 90', 'Belo Horizonte', 'MG'),
(9, 'Fernando', 'Alves', 'CPF', '77788899900', 'Av Vitoria, 300', 'Vitória', 'ES'),
(10, 'Gabriela', 'Lima', 'CPF', '88899900011', 'Praça do Papa, 10', 'Vitória', 'ES'),
(11, 'Hugo', 'Ribeiro', 'CPF', '99900011122', 'Rua Ipiranga, 45', 'São Paulo', 'SP'),
(12, 'Igor', 'Mendes', 'CPF', '00011122233', 'Av Brasil, 5000', 'Rio de Janeiro', 'RJ'),
(13, 'Juliana', 'Castro', 'CPF', '11133355577', 'Av Amazonas, 80', 'Belo Horizonte', 'MG'),
(14, 'Kauan', 'Pinto', 'CPF', '22244466688', 'Rua da Praia, 20', 'Vitória', 'ES'),
(15, 'Leticia', 'Freitas', 'CPF', '33355577799', 'Av Brigadeiro, 600', 'São Paulo', 'SP'),
(16, 'Marcio', 'Araujo', 'CPF', '44466688800', 'Rua Lapa, 33', 'Rio de Janeiro', 'RJ'),
(17, 'LogisticaBR', 'ME', 'CNPJ', '11222333000144', 'Anel Rodoviario, 50', 'Belo Horizonte', 'MG'),
(18, 'Natalia', 'Melo', 'CPF', '55577799911', 'Av Dante Michelini, 900', 'Vitória', 'ES'),
(19, 'Otavio', 'Nunes', 'CPF', '66688800022', 'Rua Consolacao, 120', 'São Paulo', 'SP'),
(20, 'Patricia', 'Borges', 'CPF', '77799911133', 'Rua Leblon, 77', 'Rio de Janeiro', 'RJ');

-- 2. ENTREGAS
INSERT INTO entrega (idEntrega, dataEntrega, track_cod, status_entrega) VALUES
(1, '2026-07-25', 'TRK10001', 'Em Trânsito'),
(2, '2026-07-26', 'TRK10002', 'Em Separação'),
(3, '2026-07-20', 'TRK10003', 'Entregue'),
(4, '2026-07-22', 'TRK10004', 'Entregue'),
(5, '2026-07-27', 'TRK10005', 'Em Rota de Entrega'),
(6, '2026-07-28', 'TRK10006', 'Aguardando Coleta'),
(7, '2026-07-15', 'TRK10007', 'Entregue'),
(8, '2026-07-26', 'TRK10008', 'Em Trânsito'),
(9, '2026-07-25', 'TRK10009', 'Em Separação'),
(10, '2026-07-18', 'TRK10010', 'Devolvido'),
(11, '2026-07-27', 'TRK10011', 'Em Rota de Entrega'),
(12, '2026-07-29', 'TRK10012', 'Aguardando Coleta'),
(13, '2026-07-19', 'TRK10013', 'Entregue'),
(14, '2026-07-24', 'TRK10014', 'Em Trânsito'),
(15, '2026-07-21', 'TRK10015', 'Entregue'),
(16, '2026-07-25', 'TRK10016', 'Em Separação'),
(17, '2026-07-28', 'TRK10017', 'Aguardando Coleta'),
(18, '2026-07-22', 'TRK10018', 'Entregue'),
(19, '2026-07-27', 'TRK10019', 'Em Rota de Entrega'),
(20, '2026-07-30', 'TRK10020', 'Aguardando Pagamento');

-- 3. FORNECEDORES
INSERT INTO fornecedor (idFornecedor, F_nomefantasia, F_nomesocial, CNPJ, localidade, contato) VALUES
(1, 'Dell', 'Dell Computadores', '11111111000111', 'São Paulo', '11988887777'),
(2, 'Apple BR', 'Apple Computer BR', '22222222000122', 'São Paulo', '11977776666'),
(3, 'Samsung', 'Samsung Eletronica', '33333333000133', 'Rio de Janeiro', '21966665555'),
(4, 'Logitech', 'Logitech do Brasil', '44444444000144', 'Belo Horizonte', '31955554444'),
(5, 'Microsoft', 'Microsoft BR', '55555555000155', 'São Paulo', '11944443333'),
(6, 'Saraiva', 'Livraria Saraiva', '66666666000166', 'Rio de Janeiro', '21933332222'),
(7, 'Intrinseca', 'Editora Intrinseca', '77777777000177', 'Rio de Janeiro', '21922221111'),
(8, 'Bic', 'Bic Brasil', '88888888000188', 'Vitória', '27911110000'),
(9, 'Faber Castell', 'Faber Castell SA', '99999999000199', 'São Paulo', '11900009999'),
(10, 'Kalunga', 'Kalunga Comércio', '10101010000101', 'São Paulo', '11988889999'),
(11, 'Intel', 'Intel Semicondutores', '20202020000102', 'Belo Horizonte', '31977778888'),
(12, 'AMD', 'AMD South America', '30303030000103', 'São Paulo', '11966667777'),
(13, 'Asus', 'Asus Brasil', '40404040000104', 'Rio de Janeiro', '21955556666'),
(14, 'Acer', 'Acer BR', '50505050000105', 'Vitória', '27944445555'),
(15, 'Lenovo', 'Lenovo Tecnologia', '60606060000106', 'São Paulo', '11933334444'),
(16, 'Multilaser', 'Multilaser BR', '70707070000107', 'Belo Horizonte', '31922223333'),
(17, 'Positivo', 'Positivo Informatica', '80808080000108', 'Vitória', '27911112222'),
(18, 'Sony', 'Sony Brasil', '90909090000109', 'São Paulo', '11900001111'),
(19, 'LG', 'LG Electronics', '12121212000112', 'Rio de Janeiro', '21988882222'),
(20, 'Nvidia', 'Nvidia BR', '13131313000113', 'São Paulo', '11977773333');

-- 4. VENDEDORES TERCEIROS (Ex_Vendedor)
INSERT INTO ex_vendedor (idVendedor, V_nomefantasia, V_nomesocial, CNPJ, CPF, localidade, contato) VALUES
(1, 'Joao Store', 'Joao Vendas', NULL, '11100011100', 'São Paulo', '11999998888'),
(2, 'Maria Shop', 'Maria Comercio', NULL, '22200022200', 'Rio de Janeiro', '21988887777'),
(3, 'Tech Varejo', 'Tech Comercio LTDA', '14141414000114', NULL, 'Belo Horizonte', '31977776666'),
(4, 'Pedro Imports', 'Pedro Silva', NULL, '33300033300', 'Vitória', '27966665555'),
(5, 'Mega Eletronicos', 'Mega LTDA', '15151515000115', NULL, 'São Paulo', '11955554444'),
(6, 'Lucas Games', 'Lucas Costa', NULL, '44400044400', 'Rio de Janeiro', '21944443333'),
(7, 'Casa dos Livros', 'Livros ME', '16161616000116', NULL, 'Belo Horizonte', '31933332222'),
(8, 'Ana Acessorios', 'Ana Maria', NULL, '55500055500', 'Vitória', '27922221111'),
(9, 'Tudo Celular', 'Celulares SA', '17171717000117', NULL, 'São Paulo', '11911110000'),
(10, 'Beto Info', 'Roberto Alves', NULL, '66600066600', 'Rio de Janeiro', '21900009999'),
(11, 'Smart Vendas', 'Smart ME', '18181818000118', NULL, 'Belo Horizonte', '31999990000'),
(12, 'Julia Variedades', 'Julia Mendes', NULL, '77700077700', 'Vitória', '27988881111'),
(13, 'Info Prime', 'Prime Eletronicos', '19191919000119', NULL, 'São Paulo', '11977772222'),
(14, 'Carlos Hardware', 'Carlos Silva', NULL, '88800088800', 'Rio de Janeiro', '21966663333'),
(15, 'O Rei do Office', 'Office LTDA', '21212121000121', NULL, 'Belo Horizonte', '31955554444'),
(16, 'Fernanda Papel', 'Fernanda Lima', NULL, '99900099900', 'Vitória', '27944445555'),
(17, 'Gamer Zone', 'Gamer SA', '23232323000123', NULL, 'São Paulo', '11933336666'),
(18, 'Paulo Perifericos', 'Paulo Gomes', NULL, '00011100011', 'Rio de Janeiro', '21922227777'),
(19, 'Eletro Tudo', 'Eletro ME', '24242424000124', NULL, 'Belo Horizonte', '31911118888'),
(20, 'Marcos Suprimentos', 'Marcos Dias', NULL, '11122211122', 'Vitória', '27900009999');

-- 5. PRODUTOS
INSERT INTO produto (idProduto, P_nome, descricao, categoria, valor, avaliacao) VALUES
(1, 'Notebook Dell XPS', 'Notebook Core i7 16GB', 'Informática', 8500.00, 4.8),
(2, 'iPhone 15', 'Smartphone Apple 256GB', 'Smartphones', 7200.00, 4.9),
(3, 'Monitor LG UltraWide', 'Monitor 29 polegadas', 'Monitores', 1200.00, 4.5),
(4, 'Mouse MX Master 3', 'Mouse ergonômico', 'Acessórios', 650.00, 4.7),
(5, 'Teclado Mecânico', 'Teclado Switch Red', 'Acessórios', 450.00, 4.4),
(6, 'Livro: Data Smart', 'Data Science e Excel', 'Livros', 120.00, 4.8),
(7, 'Livro: Storytelling com Dados', 'Visualização de Dados', 'Livros', 95.00, 4.9),
(8, 'Calculadora HP 12C', 'Calculadora Financeira', 'Escritório', 350.00, 4.6),
(9, 'Caderno Inteligente', 'Caderno A4', 'Papelaria', 90.00, 4.3),
(10, 'Caneta Bic 50un', 'Caixa de canetas azuis', 'Papelaria', 45.00, 4.2),
(11, 'Tablet Galaxy Tab S9', 'Tablet Samsung', 'Informática', 5000.00, 4.7),
(12, 'Headset Sony', 'Fones com Noise Cancelling', 'Acessórios', 1800.00, 4.8),
(13, 'SSD 1TB Kingston', 'Armazenamento rápido', 'Hardware', 450.00, 4.6),
(14, 'Placa de Vídeo RTX 4060', 'GPU Nvidia', 'Hardware', 2200.00, 4.9),
(15, 'Processador Ryzen 5', 'CPU AMD', 'Hardware', 1100.00, 4.7),
(16, 'Memória RAM 16GB', 'DDR4 Corsair', 'Hardware', 300.00, 4.5),
(17, 'Cadeira Office', 'Cadeira ergonômica', 'Móveis', 1500.00, 4.4),
(18, 'Mesa em L', 'Mesa de escritório', 'Móveis', 800.00, 4.3),
(19, 'Hub USB-C', 'Adaptador 7 em 1', 'Acessórios', 150.00, 4.2),
(20, 'Webcam Full HD', 'Câmera para reuniões', 'Acessórios', 300.00, 4.5);

-- 6. ESTOQUES
INSERT INTO estoque (idEstoque, localidade) VALUES
(1, 'Galpão Principal - SP Setor A'), (2, 'Galpão Principal - SP Setor B'),
(3, 'Galpão Principal - SP Setor C'), (4, 'Centro Dist. Guarulhos - Ala 1'),
(5, 'Centro Dist. Guarulhos - Ala 2'), (6, 'Galpão RJ - Pavilhão A'),
(7, 'Galpão RJ - Pavilhão B'), (8, 'Hub Expresso Centro RJ'),
(9, 'Hub Expresso Copacabana'), (10, 'Galpão BH - Setor Eletrônicos'),
(11, 'Galpão BH - Setor Geral'), (12, 'Hub Expresso Contagem'),
(13, 'Centro Dist. Betim - Ala A'), (14, 'Galpão Vitória - Setor 1'),
(15, 'Galpão Vitória - Setor 2'), (16, 'Hub Serra - Cargas Pesadas'),
(17, 'Hub Vila Velha'), (18, 'Reserva Técnica SP'),
(19, 'Reserva Técnica RJ'), (20, 'Reserva de Devoluções MG');

-- 7. FORMAS DE PAGAMENTO
INSERT INTO pagform (idPagamento, pg_idClient, modal_pag, card_num, card_titular, card_validade) VALUES
(1, 1, 'Crédito', '1111222233334444', 'CARLOS SILVA', '12/28'),
(2, 2, 'Débito', '5555666677778888', 'ANA SOUZA', '05/29'),
(3, 3, 'Crédito', '9999000011112222', 'TECHCORP LTDA', '10/30'),
(4, 4, 'Crédito', '3333444455556666', 'BRUNO COSTA', '01/27'),
(5, 5, 'Débito', '7777888899990000', 'CARLA DIAS', '08/28'),
(6, 6, 'Crédito', '1234567890123456', 'DANIEL GOMES', '11/29'),
(7, 7, 'Crédito', '6543210987654321', 'ELISA MARTINS', '04/27'),
(8, 8, 'Crédito', '1122334455667788', 'INOVACAO SA', '07/31'),
(9, 9, 'Débito', '9988776655443322', 'FERNANDO ALVES', '02/28'),
(10, 10, 'Crédito', '1020304050607080', 'GABRIELA LIMA', '06/29'),
(11, 11, 'Crédito', '8070605040302010', 'HUGO RIBEIRO', '09/27'),
(12, 12, 'Débito', '1357924680135792', 'IGOR MENDES', '03/30'),
(13, 13, 'Crédito', '2468013579246801', 'JULIANA CASTRO', '12/26'),
(14, 14, 'Crédito', '1111000022223333', 'KAUAN PINTO', '05/28'),
(15, 15, 'Débito', '4444555566667777', 'LETICIA FREITAS', '08/29'),
(16, 16, 'Crédito', '8888999900001111', 'MARCIO ARAUJO', '10/27'),
(17, 17, 'Crédito', '2222333344445555', 'LOGISTICABR ME', '01/32'),
(18, 18, 'Débito', '6666777788889999', 'NATALIA MELO', '06/28'),
(19, 19, 'Crédito', '0000111122223333', 'OTAVIO NUNES', '04/30'),
(20, 20, 'Crédito', '5555444433332222', 'PATRICIA BORGES', '11/29');

-- 8. PEDIDOS
INSERT INTO pedido (idPedido, P_idCliente, data_pedido, status_pedido, frete, P_idEntrega) VALUES
(1, 1, '2026-07-20', 'Em Processamento', 25.50, 1),
(2, 2, '2026-07-21', 'Confirmado', 15.00, 2),
(3, 3, '2026-07-15', 'Confirmado', 0.00, 3),
(4, 4, '2026-07-18', 'Confirmado', 30.00, 4),
(5, 5, '2026-07-25', 'Em Processamento', 12.50, 5),
(6, 6, '2026-07-26', 'Em Processamento', 45.00, 6),
(7, 7, '2026-07-10', 'Confirmado', 20.00, 7),
(8, 8, '2026-07-22', 'Confirmado', 0.00, 8),
(9, 9, '2026-07-23', 'Em Processamento', 35.00, 9),
(10, 10, '2026-07-12', 'Cancelado', 18.00, 10),
(11, 11, '2026-07-25', 'Em Processamento', 22.00, 11),
(12, 12, '2026-07-27', 'Confirmado', 28.50, 12),
(13, 13, '2026-07-14', 'Confirmado', 10.00, 13),
(14, 14, '2026-07-21', 'Em Processamento', 40.00, 14),
(15, 15, '2026-07-16', 'Confirmado', 15.50, 15),
(16, 16, '2026-07-23', 'Em Processamento', 25.00, 16),
(17, 17, '2026-07-26', 'Confirmado', 0.00, 17),
(18, 18, '2026-07-17', 'Confirmado', 32.00, 18),
(19, 19, '2026-07-25', 'Em Processamento', 14.00, 19),
(20, 20, '2026-07-28', 'Cancelado', 20.00, 20);

-- 9. ITEM_PEDIDO (Relaciona Pedido x Produto com Histórico de Preço)
INSERT INTO item_pedido (IP_idPedido, IP_idProduto, quantidade, preco_unitario) VALUES
(1, 1, 1, 8500.00), (1, 4, 1, 650.00),
(2, 2, 1, 7200.00),
(3, 17, 5, 1500.00), (3, 18, 5, 800.00),
(4, 3, 2, 1200.00),
(5, 6, 1, 120.00), (5, 7, 1, 95.00),
(6, 11, 1, 5000.00),
(7, 8, 3, 350.00),
(8, 1, 10, 8300.00), -- Desconto corporativo simulado
(9, 14, 1, 2200.00), (9, 15, 1, 1100.00),
(10, 12, 1, 1800.00),
(11, 4, 2, 650.00),
(12, 19, 1, 150.00),
(13, 9, 5, 90.00), (13, 10, 2, 45.00),
(14, 2, 1, 7200.00),
(15, 13, 2, 450.00),
(16, 16, 4, 300.00),
(17, 20, 10, 300.00),
(18, 5, 1, 450.00),
(19, 6, 1, 120.00),
(20, 7, 1, 95.00);

-- 10. PRODUTO_ESTOQUE (Onde cada produto está guardado)
INSERT INTO produto_estoque (PE_idEstoque, PE_idProduto, quantidade) VALUES
(1, 1, 50), (1, 2, 100), (2, 3, 30), (3, 4, 200),
(4, 5, 150), (5, 6, 500), (6, 7, 450), (7, 8, 120),
(8, 9, 600), (9, 10, 1000), (10, 11, 40), (11, 12, 80),
(12, 13, 250), (13, 14, 60), (14, 15, 90), (15, 16, 300),
(16, 17, 20), (17, 18, 15), (18, 19, 400), (19, 20, 180),
(20, 1, 5); -- Unidades na reserva

-- 11. PRODUTO_EX (Produtos vendidos por terceiros)
INSERT INTO produto_ex (PX_idVendedor, PX_idProduto, quantidade) VALUES
(1, 2, 15), (2, 3, 8), (3, 14, 5), (4, 11, 10),
(5, 1, 3), (6, 16, 40), (7, 6, 100), (7, 7, 120),
(8, 4, 50), (9, 2, 25), (10, 13, 60), (11, 15, 15),
(12, 9, 200), (13, 12, 20), (14, 19, 80), (15, 8, 30),
(16, 10, 150), (17, 5, 45), (18, 20, 35), (19, 17, 10),
(20, 18, 5);

-- 12. FORNECEDOR_PROD (Quem fornece o que)
INSERT INTO fornecedor_prod (FP_idFornecedor, FP_idProduto) VALUES
(1, 1), (2, 2), (19, 3), (4, 4), (4, 5),
(6, 6), (7, 7), (8, 10), (9, 10), (10, 9),
(10, 8), (3, 11), (18, 12), (11, 15), (12, 15), -- AMD e Intel competindo
(13, 14), (20, 14), (16, 19), (17, 20), (5, 4);

-- ==============================================================================
-- NÍVEL 1: EXPLORAÇÃO BÁSICA (Filtros, Ordenação e Textos)
-- ==============================================================================

-- 1. Quais são os nomes, sobrenomes e cidades de todos os clientes corporativos 
-- (CNPJ) cadastrados, ordenados em ordem alfabética pelo nome? 
with Empresas as (
	select C_nome as Empresa, sobrenome as Regime, cidade as Cidade
    from cliente
	where doc_type = "CNPJ"
) -- CTE que ajuda na otimização das querys
SELECT * FROM Empresas
order by Empresa asc;

-- 2. Quais produtos pertencem às categorias "Informática" ou "Acessórios" 
-- e custam mais de R$ 500,00?
WITH Info_Aces as (
	SELECT P_nome as Nome, categoria, valor
    from produto
    WHERE categoria IN ("Informática", "Acessórios")
)
SELECT *
FROM Info_Aces	
WHERE  valor > 500;

-- 3. Quais entregas possuem o código de rastreio começando com "TRK100" 
-- e não estão com o status "Entregue"?
SELECT idEntrega as Entrega, track_cod as Rastreio, status_entrega as Andamento
FROM entrega
WHERE track_cod LIKE "TRK100%" and status_entrega NOT IN ("Entregue");

-- 4. Quais clientes residem em avenidas (endereços que começam com "Av") 
-- no estado de São Paulo (SP)?
WITH Residentes_SP as (
	SELECT C_nome as Nome, sobrenome as Sobrenome, endereco, UF
    FROM cliente
    WHERE UF = "SP"
)
SELECT Nome, Sobrenome, endereco as Endereço
from Residentes_SP
WHERE endereco LIKE "Av%";

-- ==============================================================================
-- NÍVEL 2: AGRUPAMENTOS E MÉTRICAS (Agregações)
-- ==============================================================================

-- 5. Quantos clientes estão cadastrados por estado?
SELECT UF as Estado, COUNT(C_nome) AS Contagem
FROM cliente
GROUP BY UF;

-- 6. Qual é a média de preço, o maior preço e o menor preço dos produtos por categoria?
WITH Preco as (
	SELECT categoria as Categoria, AVG(valor) as Media_preco, MAX(valor) as Maior_Valor, MIN(valor) as Menor_Valor
    FROM produto
    GROUP BY categoria
)
SELECT * FROM Preco;

-- 7. Qual é o valor total arrecadado apenas com fretes em toda a operação do e-commerce?
WITH Frete_Entrega as (
SELECT DISTINCT P_idEntrega as Entrega, frete as Frete -- Se tiver 2 pedidos na mesma entrega, o segundo será ignorado
FROM pedido
)
SELECT SUM(Frete) as Frete_Total
FROM Frete_Entrega;

-- 8. Quais categorias de produtos possuem avaliação média (da tabela produto) 
-- superior a 4.5 e mais de 3 itens diferentes cadastrados no catálogo?
WITH Ava_Prod as(
SELECT categoria as Categoria, COUNT(categoria) as Contagem, AVG(Avaliacao) as Média
from produto
GROUP BY categoria
)
Select *
FROM Ava_Prod
WHERE Contagem > 3 AND Média > 4.5;

-- 9. Quantos pedidos foram feitos utilizando a modalidade de "Débito" versus "Crédito"? -- Essa é com JOIN, deveria estar em baixo
SELECT pg.modal_pag as Modalidade ,COUNT(pd.idPedido) as Contagem
FROM pedido as pd
JOIN pagform as pg
on pg.pg_idClient = pd.P_idCliente
GROUP BY pg.modal_pag;

-- ==============================================================================
-- NÍVEL 3: CRUZAMENTO DE DADOS (Relacionamentos Simples)
-- ==============================================================================

-- 10. Quais clientes (nome completo) realizaram pedidos que já foram entregues, 
-- e qual é a data exata em que o pedido foi feito?
with NC_Pedido as(
SELECT concat(cl.C_nome," ",cl.sobrenome) as Nome_Completo, pd.idPedido as Pedido, pd.data_pedido as Data_Pedido, P_idEntrega
from pedido as pd
join cliente as cl
on cl.idCliente = pd.P_idCliente
)
SELECT np.*, e.status_entrega as Entrega
from NC_Pedido as np
join entrega as e
on np.P_idEntrega = e.idEntrega
WHERE status_entrega = "Entregue";


-- 11. Quais produtos estão armazenados no estoque "Galpão Principal - SP Setor A" 
-- e qual a quantidade disponível de cada um deles?
with Estoque_prod as (
	SELECT e.localidade as Estoques, pe.PE_idProduto as EP_idProduto, pe.quantidade as QTD
    from produto_estoque as pe
    join estoque e
    on PE_idEstoque = e.idEstoque
    WHERE e.localidade = "Galpão Principal - SP Setor A"
)
SELECT ep.*, P_nome as Produto
from Estoque_prod ep
JOIN produto pr
ON ep.EP_idProduto = pr.idProduto;

-- 12. Quais clientes cadastrados no sistema NÃO possuem nenhuma forma de pagamento 
-- registrada?
SELECT cl.C_nome as Cliente, pg.modal_pag as Modalidade
from cliente cl
LEFT JOIN pagform pg
ON cl.idCliente = pg_idClient
WHERE pg.modal_pag is null;

-- 13. Qual é o nome fantasia dos fornecedores que entregam o produto "Notebook Dell XPS"?
WITH Produto_fornecido as (
	SELECT f.F_nomefantasia as Fornecedor, fp.FP_idProduto as PF_idProduto
    FROM fornecedor f
    JOIN fornecedor_prod fp
    ON f.idFornecedor = fp.FP_idFornecedor
)
SELECT pf.Fornecedor, pr.P_nome as Produto
from produto pr
JOIN Produto_fornecido pf
on pf.PF_idProduto = pr.idProduto
WHERE pr.P_nome = "Notebook Dell XPS";

-- ==============================================================================
-- NÍVEL 4: CONSULTAS AVANÇADAS (Visão de Negócios)
-- ==============================================================================

-- 14. Cálculo de Faturamento: Qual é o valor total de cada pedido (ID do pedido), 
-- considerando a quantidade comprada multiplicada pelo preço unitário histórico 
-- na tabela item_pedido?
SELECT IP_idPedido as Pedido, SUM(quantidade * preco_unitario) as Valor_Pedido
FROM item_pedido
GROUP BY IP_idPedido;

-- 15. Análise de Marketplace: Quais vendedores terceiros (nome fantasia) estão vendendo 
-- produtos da categoria "Hardware", quais são esses produtos e qual é o volume 
-- total que eles têm para venda?
WITH Itens_externos as (
	select pr.P_nome as Produto, px.PX_idVendedor as Vendedor_ex, quantidade as QTD
    FROM produto pr
    JOIN produto_ex px ON pr.idProduto = px.PX_idProduto
    WHERE pr.categoria = "Hardware"
)
SELECT vx.V_nomefantasia as Vendedor, ix.*
FROM ex_vendedor vx
JOIN Itens_externos ix on ix.Vendedor_ex = vx.idVendedor;

-- 16. Ticket Médio: Qual é o nome do cliente que mais gastou na loja (somando o 
-- valor dos produtos de todos os seus pedidos não cancelados)?
with Pedido_valor as(
	SELECT pd.P_idCliente as PV_idCliente, ip.IP_idPedido as Pedido, SUM(ip.quantidade * ip.preco_unitario) as Valor_Pedido
	FROM item_pedido ip
    JOIN pedido pd on ip.IP_idPedido = pd.idPedido
    WHERE pd.status_pedido not in("Cancelado")
	GROUP BY ip.IP_idPedido
)
SELECT cl.C_nome as Cliente, SUM(pv.Valor_Pedido) as Ticket_Total
FROM cliente cl
JOIN Pedido_Valor pv ON pv.PV_idCliente = cl.idCliente
GROUP BY cl.C_Nome
ORDER BY Ticket_Total DESC LIMIT 1;

-- 17. Eficiência de Estoque: Existe algum produto cadastrado no sistema (tabela produto) 
-- que não está alocado em nenhum estoque físico próprio e também não é vendido 
-- por nenhum terceiro?
WITH sem_estoque as (
	SELECT pr.idProduto as se_idProduto, pr.P_nome as Produto
    from produto pr
    LEFT JOIN produto_estoque pe on pr.idProduto = pe.PE_idProduto
    WHERE pe.PE_idEstoque is null
) -- Cruza produto com estoque para saber quem não está lá 
SELECT se.Produto 
FROM sem_estoque se
LEFT JOIN  produto_ex px on se.se_idProduto = px.PX_idProduto
WHERE px.PX_idVendedor is null; -- Pega quem sobrou para saber quem não é vendido por terceiro

-- 18. Auditoria de Preços: Quais produtos (nome) foram vendidos em algum pedido por 
-- um preco_unitario diferente do valor que está cadastrado atualmente na tabela 
-- principal de produto?
SELECT pr.P_nome as Produto, pr.valor, ip.preco_unitario
from produto pr
JOIN item_pedido ip on pr.idProduto = ip.IP_idProduto
WHERE pr.valor != ip.preco_unitario;
