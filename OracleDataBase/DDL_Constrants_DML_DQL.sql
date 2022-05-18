/* REVISÃO
DDL (Data Definition Language) são Comandos aplicados a estrutura do banco, geralmente para definição de novas tabelas views, ou outros objetos dentro do banco. Um exemplo:
 create
 alter
 drop
 truncate

Constraints podem ser definições de chave primária, aceitação de valores nulos, valores únicos, dentre outros uma vez que a estrutura está criada, podemos pensar na manipulação dos dados 

*/

DROP TABLE dept2;

CREATE TABLE dept2(
    deptno NUMBER(2,0),
    dname  VARCHAR2(14),
    loc    VARCHAR2(13),
    CONSTRAINT pk_dept2 PRIMARY KEY (deptno) -- regras
);

/*
DML (Data Manipulation Language) são comandos utilizados para manipulação de dados
 insert
 update
 delete

O primeiro comando lógico a abordarmos é o insert, pois não temos nenhum dado em nossa tabela por para atualizar ou remover

*/

INSERT INTO dept2 VALUES (
    10,             -- deptno
    'ACCOUNTING',   -- dname
    'NEW YORK'      -- loc
);
INSERT INTO dept2 VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO dept2 VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dept2 VALUES (40, 'OPERATIONS', 'BOSTON');


/*
DQL (Data Query Language) são comandos para realizar consultas no banco de dados

*/
SELECT * FROM dept2;

INSERT INTO dept2 (SELECT 60, 'BI', 'TEXAS' FROM dual);
-- Foi utilizado um comando misto de DQL com DML onde eu seleciono a linha que eu quero inserir no banco;

-- dual é uma tabela ficticia para poder selecionar uma linha de forma tabular sem depender de uma tabela em que essa linha existe;

/*
DCL / TCL (Data Transaction Language / Transaction Control Language) comandos utilizados para garantir que os dados foram persistidos em caso de sucesso, ou voltar ao estado inicial em caso de falha (Rollback). Normalmente utilizados dentro de blocos de transação no Oracle.
 commit
 rollback

*/

-- VOLTANDO AO DML
/*
Update: Na verdade, o departamento 60 não se chama BI, se chama DATA. Como arrumar?

*/
UPDATE dept2
SET dname = 'DATA'
WHERE deptno = 60;

/*
Delete: Mas e se na verdade, este departamente nem sequer existe?
*/
DELETE FROM dept2
WHERE deptno = 60;

/*Select: O select, é sem dúvidas um dos comandos mais utilizados para análise de dados e profissionais de dados como um todo. Pois a partir dos dados persistidos no banco precisaremos consultá-los para chegar nas respostas das perguntas que o negócio precisa responder. Começando pelo simples:
*/
SELECT * FROM dept2;
-- O select * significa que consultaremos todas as colunas de determinada tabela.

-- Estrutura de um select:
SELECT *                -- colunas a serem selecionadas
FROM dept2              -- tabela de origem
WHERE deptno > 10       -- filtros (antes de qualquer agregação)
-- GROUP BY             -- campos para agregação
-- HAVING               -- filtros (após agregações)
ORDER BY deptno DESC;   -- campos para ordenação


-- vamos adicionar de volta nosso departamento de BI, desta vez em BOSTON
INSERT INTO dept2 VALUES (50, 'BI', 'BOSTON');
-- mas o time de BI está dividido entre BOSTON e TEXAS, portanto teremos mais um deptno
INSERT INTO dept2 VALUES (60, 'BI', 'TEXAS');
/*
Poderiamos ter a seguinte pergunta:
 Quais os departamentos que temos cadastrados?
 Quais as localizações em que temos departamentos?
 Poderiamos responder esta pergunta da seguinte forma:
*/

SELECT dname FROM dept2;

-- ou

SELECT loc FROM dept2;

-- dependendo da base, poderemos ter muitas linhas repetidas, para isso podemos
-- utilizar o distinct, para retornar valores únicos:
SELECT DISTINCT dname 
FROM dept2
ORDER BY dname; -- para uma melhor apresentação :)
-- ou
SELECT DISTINCT loc 
FROM dept2
ORDER BY loc DESC; -- caso a ordenação seja decrescente
-- ou poderíamos querer saber apenas a quantidade de departamentos da empresa.
-- para isso precisariamos utilizar uma função de agregação:
SELECT COUNT(*) FROM dept2; -- retonar o total de linhas
-- ou quem sabe o total de localizações únicas?
SELECT COUNT(DISTINCT loc) FROM dept2;
-- e a quantidade de localizações por departamento?
SELECT dname, COUNT(loc)
FROM dept2
GROUP BY dname;
-- vamos deixar mais apresentável com um alias
SELECT dname, COUNT(loc) AS qt_loc
FROM dept2
GROUP BY dname; -- campo para agregar os valores calculados
-- interessante, e se precisássemos filtrar apenas os departamentos com código maior que 20?
SELECT dname, COUNT(loc) AS qt_loc
FROM dept2
WHERE deptno > 20
-- WHERE deptno >= 20 -- caso não queira filtrar o 20 também
GROUP BY dname;
-- agora precisamos olhar especificamente os departamentos com mais de uma localização
SELECT dname, COUNT(loc) AS qt_loc
FROM dept2
GROUP BY dname
HAVING COUNT(loc) > 1; -- funciona para filtrar campos agregados
-- agora precisamos filtrar os departamentos com nome BI ou DATA
SELECT dname, COUNT(loc) AS qt_loc
FROM dept2
WHERE dname = 'BI' OR dname = 'DATA'
GROUP BY dname;
-- uma forma melhor para filtrar vários valores:
SELECT *
FROM dept2
WHERE dname IN ('BI', 'DATA');
-- interessante... mas e se precisássemos filtrar todos os departamentos com código
-- maior que 10 e que o nome fosse BI?
SELECT *
FROM dept2
WHERE dname = 'BI' AND deptno > 10;
-- legal exploramos bastante a tabela de departamentos.
-- vamos ver alguns outros comandos interessantes:
-- filtrar apenas uma quantidade de linhas da tabela para verificar conteúdo
SELECT * FROM dept2 where ROWNUM <= 3;
-- subquery
-- no lugar da tabela
SELECT * FROM (
    SELECT DISTINCT dname FROM dept2
);
-- para filtros
SELECT * FROM dept2
WHERE deptno = (SELECT MAX(deptno) FROM dept2);
-- JOINS
-- inner
-- left
-- right
-- full
-- cross