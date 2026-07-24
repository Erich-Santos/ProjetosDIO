-- create database oficina;
-- USE oficina;
-- DROP DATABASE oficina;

-- Criação de Tabelas 
create table if not exists cliente(
	idCliente int primary key auto_increment,
    nome varchar(50) not null,
    sobrenome varchar(50) not null,
    CPF CHAR(11) not null,
    endereco varchar(100) not null, -- xxxxxxxx, nnnn, bbbb
    cidade varchar(30) not null,
    UF char(2) not null,
    constraint unique_cliente unique(CPF)
    );

CREATE TABLE IF NOT EXISTS veiculo(
	idVeiculo INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT,
    fabricante VARCHAR(30),
    modelo VARCHAR(30), 
    ano INT, 
    placa CHAR(7),
    chassi CHAR(17), 
    CONSTRAINT unique_veiculo_chassi UNIQUE(chassi),
    CONSTRAINT unique_veiculo_placa UNIQUE(placa),
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
); -- Relação N:1 com a tabela Cliente

CREATE TABLE IF NOT EXISTS mecanico(
	idMecanico INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50) NOT NULL,
    CPF CHAR(11) not null,
    especialidade VARCHAR(50),
    CONSTRAINT unique_mecanico UNIQUE(CPF)
);

CREATE TABLE IF NOT EXISTS peca(
	idPeca INT PRIMARY KEY AUTO_INCREMENT,
    peca VARCHAR(30) NOT NULL,
    descricao VARCHAR(255),
    fabricante VARCHAR(30) NOT NULL,
    ano_fabricacao INT NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    valor DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS servico(
	idServico INT PRIMARY KEY AUTO_INCREMENT,
    servico VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    valor DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS equipe(
	idEquipe INT PRIMARY KEY AUTO_INCREMENT,
    nome_equipe VARCHAR(50) NOT NULL
);

-- Tabela delhando quem faz parte da equipe naquele momento
CREATE TABLE IF NOT EXISTS equipes_mem(
	idEquipe  INT, 
    idMecanico INT,
	data_inicio DATE NOT NULL,
    data_final DATE,
    PRIMARY KEY (idEquipe, idMecanico),
    constraint fk_equipe_mec foreign key (idMecanico) references mecanico(idMecanico),
    constraint fk_equipe_membro foreign key (idEquipe) references equipe(idEquipe)
);

CREATE TABLE IF NOT EXISTS os(
	idOs INT PRIMARY KEY AUTO_INCREMENT,
    idVeiculo INT,
    idEquipe INT,
    data_emissao DATETIME,
    status_os ENUM('Aberto', 'Em Execução', 'Aguardando Peça', 'Finalizado', 'Cancelado') DEFAULT 'Aberto',
    data_entrega DATE,
    valor_total_servicos DECIMAL(10,2),
    valor_total_pecas DECIMAL(10,2),
    valor_total DECIMAL(10,2),
    CONSTRAINT fk_os_veiculo FOREIGN KEY (idVeiculo) REFERENCES veiculo(idVeiculo),
    CONSTRAINT fk_os_equipe FOREIGN KEY (idEquipe) REFERENCES equipe(idEquipe)
);

-- Serviços aplicados com histórico de preços
CREATE TABLE IF NOT EXISTS servico_os(
	idOs INT,
    idServico INT,
    quantidade INT DEFAULT 1, -- caso trocarem 3 rodas, 3
    valor_unitario DECIMAL(10,2),
    PRIMARY KEY(idOs, idServico),
    CONSTRAINT fk_so_os FOREIGN KEY (idOS) REFERENCES os(idOs),
    CONSTRAINT fk_so_servico FOREIGN KEY(idServico) REFERENCES servico(idServico)
);

CREATE TABLE IF NOT EXISTS peca_os(
    idOs INT,
	idPeca INT,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idOS, idPeca),
    CONSTRAINT fk_PO_pecas FOREIGN KEY (idPeca) REFERENCES peca(idPeca),
    CONSTRAINT fk_PO_os FOREIGN KEY (idOs) REFERENCES os(idOs)
);

-- 1. Inserindo Clientes (10 clientes)
INSERT INTO cliente (nome, sobrenome, CPF, endereco, cidade, UF) VALUES
('Ana', 'Souza', '11122233344', 'Rua das Flores, 123', 'São Paulo', 'SP'),
('Bruno', 'Martins', '22233344455', 'Av. Paulista, 900', 'São Paulo', 'SP'),
('Camila', 'Lima', '33344455566', 'Rua do Ouvidor, 45', 'Rio de Janeiro', 'RJ'),
('Diego', 'Costa', '44455566677', 'Av. Brasil, 1500', 'Rio de Janeiro', 'RJ'),
('Eduarda', 'Alves', '55566677788', 'Rua Bahia, 10', 'Belo Horizonte', 'MG'),
('Felipe', 'Gomes', '66677788899', 'Rua Amazonas, 300', 'Curitiba', 'PR'),
('Gabriela', 'Rocha', '77788899900', 'Av. Sete de Setembro, 50', 'Salvador', 'BA'),
('Henrique', 'Melo', '88899900011', 'Rua da Paz, 77', 'Porto Alegre', 'RS'),
('Isabela', 'Ribeiro', '99900011122', 'Rua XV de Novembro, 202', 'Curitiba', 'PR'),
('Lucas', 'Carvalho', '00011122233', 'Av. Boa Viagem, 400', 'Recife', 'PE');

-- 2. Inserindo Veículos (13 veículos - Os 3 primeiros clientes possuem 2 carros)
INSERT INTO veiculo (idCliente, fabricante, modelo, ano, placa, chassi) VALUES
(1, 'Chevrolet', 'Onix', 2021, 'ABC1234', '9BG12345678901234'), -- Carro 1 da Ana
(1, 'Hyundai', 'HB20', 2019, 'XYZ9876', '93W12345678901234'), -- Carro 2 da Ana
(2, 'Toyota', 'Corolla', 2022, 'DEF5678', '9BR12345678901234'), -- Carro 1 do Bruno
(2, 'Toyota', 'Hilux', 2020, 'GHI9012', '8AJ12345678901234'), -- Carro 2 do Bruno
(3, 'Jeep', 'Compass', 2023, 'JKL3456', '94D12345678901234'), -- Carro 1 da Camila
(3, 'Jeep', 'Renegade', 2018, 'MNO7890', '94D09876543210987'), -- Carro 2 da Camila
(4, 'Volkswagen', 'Polo', 2021, 'PQR1234', '9BW12345678901234'),
(5, 'Honda', 'Civic', 2017, 'STU5678', '93H12345678901234'),
(6, 'Fiat', 'Argo', 2020, 'VWX9012', '9BD12345678901234'),
(7, 'Renault', 'Kwid', 2022, 'YZA3456', '93Y12345678901234'),
(8, 'Ford', 'Ka', 2019, 'BCD7890', '9BF12345678901234'),
(9, 'Nissan', 'Kicks', 2021, 'EFG1234', '3N112345678901234'),
(10, 'Chevrolet', 'Tracker', 2023, 'HIJ5678', '9BG09876543210987');

-- 3. Inserindo Mecânicos (8 mecânicos com especialidades distintas)
INSERT INTO mecanico (nome, sobrenome, CPF, especialidade) VALUES
('Carlos', 'Ferreira', '10120230340', 'Mecânica Geral'),
('João', 'Batista', '20230340450', 'Suspensão e Freios'),
('Marcos', 'Silva', '30340450560', 'Motor e Transmissão'),
('André', 'Luiz', '40450560670', 'Injeção Eletrônica'),
('Rafael', 'Nunes', '50560670780', 'Elétrica Automotiva'),
('Pedro', 'Henrique', '60670780890', 'Ar-Condicionado'),
('Tiago', 'Mendes', '70780890900', 'Mecânica Geral'),
('Bruno', 'Alves', '80890900010', 'Motor e Transmissão');

-- 4. Inserindo Serviços (Mínimo 5)
INSERT INTO servico (servico, descricao, valor) VALUES
('Troca de Óleo', 'Substituição do óleo do motor e filtro', 100.00),
('Alinhamento e Balanceamento', 'Ajuste da geometria da suspensão e balanceamento das 4 rodas', 150.00),
('Revisão de Freios', 'Troca de pastilhas e verificação dos discos', 200.00),
('Limpeza de Bicos', 'Limpeza do sistema de injeção eletrônica', 180.00),
('Carga de Gás', 'Recarga de gás do ar-condicionado', 250.00),
('Retífica de Motor', 'Serviço completo de retífica', 1500.00);

-- 5. Inserindo Peças (Mínimo 5)
INSERT INTO peca (peca, descricao, fabricante, ano_fabricacao, modelo, valor) VALUES
('Óleo 5W30', 'Óleo sintético para motor', 'Castrol', 2023, 'Sintético', 45.00),
('Filtro de Óleo', 'Filtro blindado', 'Fram', 2023, 'Universal', 35.00),
('Pastilha de Freio', 'Jogo de pastilhas dianteiras', 'Cobreq', 2022, 'Cerâmica', 120.00),
('Fluido de Freio', 'Fluido DOT 4', 'Varga', 2023, 'DOT4', 40.00),
('Filtro de Ar Condicionado', 'Filtro de cabine', 'Tecfil', 2023, 'Carvão Ativado', 55.00),
('Kit Correia Dentada', 'Correia e tensor', 'Gates', 2022, 'Original', 250.00);

-- 6. Inserindo Equipes (4 equipes estruturadas por complexidade)
INSERT INTO equipe (nome_equipe) VALUES
('Equipe Revisão Rápida'),
('Equipe Suspensão e Freios'),
('Equipe Motor e Injeção'), 
('Equipe Elétrica e Climatização');

-- 7. Atribuindo Mecânicos às Equipes (N:M - Histórico)
INSERT INTO equipes_mem (idEquipe,idMecanico, data_inicio) VALUES
(1, 1, '2025-01-10'),
(1, 7, '2025-01-10'), 
(2, 2, '2025-01-15'), 
(3, 3, '2025-02-01'), 
(3, 4, '2025-02-01'), 
(3, 8, '2025-02-01'), 
(4, 5, '2025-03-10'), 
(4, 6, '2025-03-10'); 

-- 8. Inserindo Ordens de Serviço (30 registros)
-- Distribuindo de forma realista: carros voltando para revisões ao longo de 2025 e 2026.
INSERT INTO os (idVeiculo, idEquipe, data_emissao, status_os, data_entrega, valor_total_servicos, valor_total_pecas, valor_total) VALUES
-- Veiculos da Ana (1 e 2)
(1, 1, '2025-05-10', 'Finalizado', '2025-05-10', 100.00, 215.00, 315.00),
(1, 2, '2025-11-20', 'Finalizado', '2025-11-21', 200.00, 120.00, 320.00),
(2, 4, '2025-12-05', 'Finalizado', '2025-12-06', 250.00, 55.00, 305.00),
(2, 1, '2026-06-15', 'Finalizado', '2026-06-15', 150.00, 0.00, 150.00),
-- Veiculos do Bruno (3 e 4)
(3, 3, '2025-04-10', 'Finalizado', '2025-04-15', 1500.00, 250.00, 1750.00),
(3, 1, '2026-01-10', 'Finalizado', '2026-01-10', 100.00, 215.00, 315.00),
(4, 2, '2025-08-20', 'Finalizado', '2025-08-21', 200.00, 160.00, 360.00),
(4, 3, '2026-03-11', 'Finalizado', '2026-03-12', 180.00, 0.00, 180.00),
-- Veiculos da Camila (5 e 6)
(5, 1, '2025-02-25', 'Finalizado', '2025-02-25', 250.00, 215.00, 465.00),
(5, 4, '2025-10-10', 'Finalizado', '2025-10-11', 250.00, 55.00, 305.00),
(6, 2, '2025-06-14', 'Finalizado', '2025-06-15', 200.00, 120.00, 320.00),
(6, 1, '2026-02-20', 'Finalizado', '2026-02-20', 150.00, 0.00, 150.00),
-- Restante da frota (7 a 13) rodando a oficina
(7, 3, '2025-03-15', 'Finalizado', '2025-03-18', 1500.00, 250.00, 1750.00),
(8, 1, '2025-04-20', 'Finalizado', '2025-04-20', 100.00, 215.00, 315.00),
(9, 2, '2025-05-25', 'Finalizado', '2025-05-25', 200.00, 120.00, 320.00),
(10, 4, '2025-07-30', 'Finalizado', '2025-07-30', 250.00, 55.00, 305.00),
(11, 1, '2025-09-10', 'Finalizado', '2025-09-10', 250.00, 215.00, 465.00),
(12, 3, '2025-11-15', 'Finalizado', '2025-11-16', 180.00, 0.00, 180.00),
(13, 1, '2026-01-20', 'Finalizado', '2026-01-20', 100.00, 215.00, 315.00),
(7, 1, '2026-02-10', 'Finalizado', '2026-02-10', 150.00, 0.00, 150.00),
(8, 2, '2026-03-05', 'Finalizado', '2026-03-05', 200.00, 160.00, 360.00),
(9, 4, '2026-04-12', 'Finalizado', '2026-04-12', 250.00, 55.00, 305.00),
(10, 3, '2026-05-18', 'Finalizado', '2026-05-20', 1500.00, 250.00, 1750.00),
(11, 1, '2026-06-22', 'Finalizado', '2026-06-22', 100.00, 215.00, 315.00),
(12, 2, '2026-07-01', 'Finalizado', '2026-07-02', 200.00, 120.00, 320.00),
(13, 4, '2026-07-10', 'Finalizado', '2026-07-11', 250.00, 55.00, 305.00),
-- Ordens de Serviço Atuais (Em andamento/Abertas - Julho/Agosto 2026)
(1, 3, '2026-07-20', 'Em Execução', '2026-07-25', 1500.00, 250.00, 1750.00),
(3, 2, '2026-07-22', 'Aguardando Peça', '2026-07-26', 200.00, 120.00, 320.00),
(5, 1, '2026-07-23', 'Aberto', '2026-07-23', 100.00, 215.00, 315.00),
(8, 4, '2026-07-23', 'Em Execução', '2026-07-24', 250.00, 55.00, 305.00);

-- 9. Povoando servico_os (Com o valor unitário congelado na data da OS)
-- (Gerando inserções representativas para algumas das OS acima baseadas no valor cobrado)
INSERT INTO servico_os (idOs, idServico, quantidade, valor_unitario) VALUES
(1, 1, 1, 100.00), 
(2, 3, 1, 200.00), 
(3, 5, 1, 250.00), 
(4, 2, 1, 150.00), 
(5, 6, 1, 1500.00), 
(6, 1, 1, 100.00),
(7, 3, 1, 200.00),
(8, 4, 1, 180.00), 
(9, 1, 1, 100.00),
(9, 2, 1, 150.00), 
(10, 5, 1, 250.00),
(27, 6, 1, 1500.00), 
(28, 3, 1, 200.00), 
(29, 1, 1, 100.00), 
(30, 5, 1, 250.00); 

-- 10. Povoando peca_os (Com quantidade e valor unitário)
INSERT INTO peca_os (idOs,idPeca, quantidade, valor_unitario) VALUES
(1, 1, 4, 45.00), 
(1, 2, 1, 35.00), 
(2, 3, 1, 120.00),
(3, 5, 1, 55.00), 
(5, 6, 1, 250.00), 
(6, 1, 4, 45.00),
(6, 2, 1, 35.00),
(7, 3, 1, 120.00),
(7, 4, 1, 40.00), 
(9, 1, 4, 45.00),
(9, 2, 1, 35.00),
(10, 5, 1, 55.00),
(27, 6, 1, 250.00),
(28, 3, 1, 120.00),
(29, 1, 4, 45.00),
(29, 2, 1, 35.00),
(30, 5, 1, 55.00);
