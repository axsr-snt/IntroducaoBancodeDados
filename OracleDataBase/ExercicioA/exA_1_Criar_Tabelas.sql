--CRIANDO AS TABELAS

CREATE TABLE t_sip_departamento (
    cod_departamento  NUMBER(2) NOT NULL,
    nom_departamento  VARCHAR2(30) NOT NULL
);

CREATE TABLE t_sip_dependente (
    cod_dependente   NUMBER(6) NOT NULL,
    cod_funcionario  NUMBER(5) NOT NULL,
    nom_dependente   VARCHAR2(60) NOT NULL,
    dat_nascimento   DATE NOT NULL
);

CREATE TABLE t_sip_funcionario (
    cod_funcionario   NUMBER(5) NOT NULL,
    cod_departamento  NUMBER(2) NOT NULL,
    nom_funcionario   VARCHAR2(60) NOT NULL,
    dat_nascimento    DATE NOT NULL,
    dat_admissao      DATE NOT NULL,
    des_endereço      VARCHAR2(80) NOT NULL,
    val_salario       NUMBER(7, 2) NOT NULL
);

CREATE TABLE t_sip_implantacao (
    cod_implantacao  NUMBER(4) NOT NULL,
    cod_projeto      NUMBER(5) NOT NULL,
    cod_funcionario  NUMBER(5) NOT NULL,
    dat_entrada      DATE NOT NULL,
    dat_saida        DATE
);

CREATE TABLE t_sip_projeto (
    cod_projeto  NUMBER(5) NOT NULL,
    nom_projeto  VARCHAR2(30) NOT NULL,
    dat_inicio   DATE NOT NULL,
    dat_termino  DATE
);

-- ADICIONANDO CONSTRAINTS

-- PRIMARY KEY

ALTER TABLE t_sip_departamento ADD CONSTRAINT t_sip_departamento_pk PRIMARY KEY ( cod_departamento );

ALTER TABLE t_sip_dependente ADD CONSTRAINT t_sip_dependente_pk PRIMARY KEY ( cod_dependente,
                                                                              cod_funcionario );
                                                                            
ALTER TABLE t_sip_implantacao ADD CONSTRAINT t_sip_implantacao_pk PRIMARY KEY ( cod_implantacao,
                                                                                cod_projeto );
ALTER TABLE t_sip_projeto ADD CONSTRAINT t_sip_projeto_pk PRIMARY KEY ( cod_projeto );

ALTER TABLE t_sip_funcionario ADD CONSTRAINT t_sip_funcionario_pk PRIMARY KEY ( cod_funcionario );

-- VALIDAÇÃO

ALTER TABLE t_sip_departamento ADD CONSTRAINT un_sip_departamento UNIQUE ( nom_departamento );


ALTER TABLE t_sip_funcionario ADD CONSTRAINT ck_sip_funcionario CHECK ( val_salario >= 937 );

-- FOREIGN KEY

ALTER TABLE t_sip_dependente
    ADD CONSTRAINT fk_sip_depen_func FOREIGN KEY ( cod_funcionario )
        REFERENCES t_sip_funcionario ( cod_funcionario );

ALTER TABLE t_sip_funcionario
    ADD CONSTRAINT fk_sip_func_depar FOREIGN KEY ( cod_departamento )
        REFERENCES t_sip_departamento ( cod_departamento );

ALTER TABLE t_sip_implantacao
    ADD CONSTRAINT fk_sip_impl_func FOREIGN KEY ( cod_funcionario )
        REFERENCES t_sip_funcionario ( cod_funcionario );

ALTER TABLE t_sip_implantacao
    ADD CONSTRAINT fk_sip_impl_proj FOREIGN KEY ( cod_projeto )
        REFERENCES t_sip_projeto ( cod_projeto );