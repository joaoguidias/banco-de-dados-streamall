-- NOME: JOÃO GUILHERME DIAS PASCOLAT

CREATE DATABASE IF NOT EXISTS streamall
	CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
    
USE streamall;

CREATE TABLE IF NOT EXISTS usuarios(
	id_usuario BIGINT AUTO_INCREMENT,
    nome_completo VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE ,
    cpf CHAR(11) NOT NULL UNIQUE ,
    data_nascimento DATE NOT NULL,
    nome_exibicao VARCHAR(100) NOT NULL,
    
    
    CONSTRAINT pk_usuario PRIMARY KEY(id_usuario)
    
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS assinaturas(
	id_assinatura BIGINT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL, 
    preco DECIMAL(6,2) NOT NULL,
    qualidade_audio VARCHAR(50),
    qualidade_video VARCHAR(50),
    telas_simultaneas INT,
    
    CONSTRAINT pk_assinatura PRIMARY KEY (id_assinatura)
    
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS conteudos(
	id_conteudo BIGINT AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    duracao INT NOT NULL,
    data_lancamento DATE NOT NULL,
    
    CONSTRAINT pk_conteudo PRIMARY KEY (id_conteudo)

)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS artistas(
	id_artista BIGINT AUTO_INCREMENT,
    nome_artistico VARCHAR(255) NOT NULL, 
    pais_origem VARCHAR(255) NOT NULL, 
    biografia TEXT,
    
    CONSTRAINT pk_artista PRIMARY KEY (id_artista)

)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- tabelas com dependencias(fk) 

CREATE TABLE IF NOT EXISTS historico_assinaturas(
	id_historico BIGINT UNSIGNED AUTO_INCREMENT,
	id_assinatura BIGINT UNSIGNED,
    id_usuario BIGINT UNSIGNED, 
    data_evento DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_historico PRIMARY KEY (id_historico),
    CONSTRAINT fk_historico_assinatura_assinatura FOREIGN KEY (id_assinatura) REFERENCES assinaturas(id_assinatura),
    CONSTRAINT fk_historico_assinatura_usuario FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario) 

)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS enderecos(
	id_endereco BIGINT NOT NULL AUTO_INCREMENT,
    id_usuario BIGINT, 
    logradouro VARCHAR (255) NOT NULL,
    cidade VARCHAR(255) NOT NULL, 
    estado CHAR(2) NOT NULL,
    cep VARCHAR (20) NOT NULL,
    
    CONSTRAINT pk_endereco PRIMARY KEY (id_endereco),
    CONSTRAINT fk_usuario FOREIGN KEY (id_usuario)
							REFERENCES usuarios(id_usuario)
                            ON DELETE RESTRICT 
                            ON UPDATE CASCADE
                            
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- MUSICAS 

CREATE TABLE IF NOT EXISTS albuns(
	id_album BIGINT AUTO_INCREMENT,
    id_artista BIGINT, 
    titulo VARCHAR(255) NOT NULL, 
    lancamento DATE NOT NULL,
    url_capa VARCHAR (300) NOT NULL,
    
    CONSTRAINT pk_album PRIMARY KEY (id_album),
    CONSTRAINT fk_artista_album FOREIGN KEY(id_artista) REFERENCES artistas(id_artista)
    
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS musicas(
		id_conteudo BIGINT PRIMARY KEY,
        id_album BIGINT,
        letra TEXT,
        
        CONSTRAINT fk_musica_conteudo FOREIGN KEY (id_conteudo)
									REFERENCES conteudos(id_conteudo),
		CONSTRAINT fk_musica_album FOREIGN KEY (id_album) REFERENCES albuns(id_album)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS filmes(
	id_conteudo BIGINT PRIMARY KEY,
    sinopse TEXT NOT NULL,
    classificacao_etaria VARCHAR(10),
    
    CONSTRAINT fk_filmes_conteudo FOREIGN KEY (id_conteudo) REFERENCES conteudos(id_conteudo)
    
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS series(
	id_serie BIGINT AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    sinopse TEXT NOT NULL, 
    lancamento DATE NOT NULL,
    classificacao_etaria VARCHAR(10),
    status_producao VARCHAR(50),
    
    CONSTRAINT pk_serie PRIMARY KEY (id_serie) 
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS temporadas(
	id_temporada BIGINT AUTO_INCREMENT,
    id_serie BIGINT,
    numero_ordem INT,
    ano_lancamento DATE,
    
    CONSTRAINT pk_temporada PRIMARY KEY (id_temporada),
    CONSTRAINT fk_serie_temporada FOREIGN KEY(id_serie) REFERENCES series(id_serie)
    
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS episodios(
	id_conteudo BIGINT PRIMARY KEY,
    id_temporada BIGINT, 
    numero_ordem TEXT,
    sinopse TEXT,
    
    CONSTRAINT fk_episodios_conteudo FOREIGN KEY (id_conteudo) REFERENCES conteudos(id_conteudo),
    CONSTRAINT fk_episodios_temporada FOREIGN KEY(id_temporada) REFERENCES temporadas(id_temporada) 
		

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS playlists (
    id_playlist BIGINT AUTO_INCREMENT ,
    id_usuario BIGINT,
    nome VARCHAR(255),
    descricao TEXT,
    visibilidade VARCHAR(20),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_playlist PRIMARY KEY (id_playlist),
    CONSTRAINT fk_playlist_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS playlist_itens (
    id_playlist BIGINT,
    id_conteudo BIGINT,
    ordem INT,
    PRIMARY KEY (id_playlist, id_conteudo),
    CONSTRAINT fk_playlist_item_lista FOREIGN KEY (id_playlist) REFERENCES playlists(id_playlist),
    CONSTRAINT fk_playlist_item_conteudo FOREIGN KEY (id_conteudo) REFERENCES conteudos(id_conteudo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS playlist_seguidores (
    id_usuario BIGINT,
    id_playlist INT,
    data_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_playlist),
    CONSTRAINT fk_seguidor_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_seguidor_playlist FOREIGN KEY (id_playlist) REFERENCES playlists(id_playlist)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS filmes_diretor (
    id_conteudo BIGINT,
    id_profissional BIGINT,
    PRIMARY KEY (id_conteudo, id_profissional),
    CONSTRAINT fk_diretor_filme FOREIGN KEY (id_conteudo) REFERENCES filmes(id_conteudo),
    CONSTRAINT fk_diretor_prof FOREIGN KEY (id_profissional) REFERENCES profissionais(id_profissional)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS elenco_filme (
    id_conteudo BIGINT,
    id_profissional BIGINT,
    personagem VARCHAR(255),
    posicao_creditos VARCHAR(100),
    PRIMARY KEY (id_conteudo, id_profissional, personagem),
    CONSTRAINT fk_elenco_filme FOREIGN KEY (id_conteudo) REFERENCES filmes(id_conteudo),
    CONSTRAINT fk_elenco_prof FOREIGN KEY (id_profissional) REFERENCES profissionais(id_profissional)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



	