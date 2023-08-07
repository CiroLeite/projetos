-- Criação do banco de dados
CREATE DATABASE projeto0;
USE projeto0;

-- Criação das tabelas
CREATE TABLE Paciente (
    PacienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100),
    Telefone VARCHAR(20),
    Email VARCHAR(100),
    DataNascimento DATE,
    CPF VARCHAR(14)
);

CREATE TABLE Exame (
    ExameID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100),
    Descricao VARCHAR(255),
    Valor DECIMAL(10 , 2 )
);

CREATE TABLE Convenio (
    ConvenioID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100),
    TaxaCoparticipacao DECIMAL(5 , 2 )
);

CREATE TABLE Medico (
    MedicoID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100),
    CRM VARCHAR(20),
    Telefone VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE Especialidade (
    EspecialidadeID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100)
);

CREATE TABLE PacienteExame (
    PacienteID INT,
    ExameID INT,
    DataExame DATE,
    PRIMARY KEY (PacienteID , ExameID),
    FOREIGN KEY (PacienteID)
        REFERENCES Paciente (PacienteID),
    FOREIGN KEY (ExameID)
        REFERENCES Exame (ExameID)
);

CREATE TABLE PacienteConvenio (
    PacienteID INT,
    ConvenioID INT,
    PRIMARY KEY (PacienteID , ConvenioID),
    FOREIGN KEY (PacienteID)
        REFERENCES Paciente (PacienteID),
    FOREIGN KEY (ConvenioID)
        REFERENCES Convenio (ConvenioID)
);

CREATE TABLE MedicoEspecialidade (
    MedicoID INT,
    EspecialidadeID INT,
    PRIMARY KEY (MedicoID , EspecialidadeID),
    FOREIGN KEY (MedicoID)
        REFERENCES Medico (MedicoID),
    FOREIGN KEY (EspecialidadeID)
        REFERENCES Especialidade (EspecialidadeID)
);

-- Criação dos índices únicos
CREATE UNIQUE INDEX UK_Paciente_CPF ON Paciente (CPF);
CREATE UNIQUE INDEX UK_Convenio_Nome ON Convenio (Nome);

-- Criação das procedures
DELIMITER //

CREATE PROCEDURE sp_InserirPaciente(
    IN p_Nome VARCHAR(100),
    IN p_Telefone VARCHAR(20),
    IN p_Email VARCHAR(100),
    IN p_DataNascimento DATE,
    IN p_CPF VARCHAR(14)
)
BEGIN
    INSERT INTO Paciente (Nome, Telefone, Email, DataNascimento, CPF)
    VALUES (p_Nome, p_Telefone, p_Email, p_DataNascimento, p_CPF);
END//

CREATE PROCEDURE sp_AtualizarPaciente(
    IN p_PacienteID INT,
    IN p_Nome VARCHAR(100),
    IN p_Telefone VARCHAR(20),
    IN p_Email VARCHAR(100),
    IN p_DataNascimento DATE,
    IN p_CPF VARCHAR(14)
)
BEGIN
    UPDATE Paciente
    SET Nome = p_Nome,
        Telefone = p_Telefone,
        Email = p_Email,
        DataNascimento = p_DataNascimento,
        CPF = p_CPF
    WHERE PacienteID = p_PacienteID;
END//

CREATE PROCEDURE sp_ExcluirPaciente(
    IN p_PacienteID INT
)
BEGIN
    DELETE FROM Paciente
    WHERE PacienteID = p_PacienteID;
END//
DELIMITER ;

-- Criação das triggers
DELIMITER //

CREATE TRIGGER tr_InsertPacienteExame AFTER INSERT ON PacienteExame
FOR EACH ROW
BEGIN
    INSERT INTO Log (NomeTabela, TipoAcao, ID_Gravado, DataLog)
    VALUES ('PacienteExame', 'INSERT', NEW.PacienteID, NOW());
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER tr_UpdatePacienteExame AFTER UPDATE ON PacienteExame
FOR EACH ROW
BEGIN
    INSERT INTO Log (NomeTabela, TipoAcao, ID_Gravado, DataLog)
    VALUES ('PacienteExame', 'UPDATE', NEW.PacienteID, NOW());
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER tr_DeletePacienteExame AFTER DELETE ON PacienteExame
FOR EACH ROW
BEGIN
    INSERT INTO Log (NomeTabela, TipoAcao, ID_Gravado, DataLog)
    VALUES ('PacienteExame', 'DELETE', OLD.PacienteID, NOW());
END //

DELIMITER ;

-- Criação da view para o faturamento mensal
CREATE VIEW FaturamentoMensal AS
    SELECT 
        YEAR(PacienteExame.DataExame) AS Ano,
        MONTH(PacienteExame.DataExame) AS Mes,
        SUM(Exame.Valor) AS ValorFaturado
    FROM
        PacienteExame
            INNER JOIN
        Exame ON PacienteExame.ExameID = Exame.ExameID
    GROUP BY YEAR(PacienteExame.DataExame) , MONTH(PacienteExame.DataExame);

-- Criação dos usuários e concessão de privilégios
GRANT SELECT, INSERT, UPDATE, DELETE ON projeto0.* TO 'recepcionista'@'localhost';
GRANT SELECT, INSERT, UPDATE ON projeto0.* TO 'medico'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON projeto0.FaturamentoMensal TO 'financeiro'@'localhost';
GRANT ALL PRIVILEGES ON projeto0.* TO 'admin'@'localhost';
