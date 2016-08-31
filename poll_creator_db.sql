CREATE TABLE questions (
	id_question SERIAL NOT NULL,
	question TEXT NOT NULL,
	username VARCHAR(45),
	is_public BOOLEAN DEFAULT true NOT NULL,
	is_anonimius BOOLEAN DEFAULT false NOT NULL,
	created DATE DEFAULT CURRENT_DATE NOT NULL,
	image CHARACTER VARYING,
	CONSTRAINT questions_pk PRIMARY KEY (id_question)
) WITH (
  OIDS=FALSE
);

CREATE TABLE answers (
	id_answer SERIAL NOT NULL,
	id_question INTEGER NOT NULL,
	answer TEXT NOT NULL,
	is_other BOOLEAN DEFAULT false NOT NULL,
	votes INTEGER DEFAULT 0 NOT NULL,
	image CHARACTER VARYING,
	CONSTRAINT answers_pk PRIMARY KEY (id_answer)
) WITH (
  OIDS=FALSE
);

CREATE  TABLE users (
  username VARCHAR(45) UNIQUE NOT NULL ,
  password VARCHAR(60) NOT NULL ,
  enabled SMALLINT NOT NULL DEFAULT 1 ,
  avatar CHARACTER VARYING,
  PRIMARY KEY (username));

CREATE TABLE user_roles (
  user_role_id BIGSERIAL NOT NULL,
  username varchar(45) NOT NULL,
  role varchar(45) DEFAULT 'ROLE_USER' NOT NULL,
  PRIMARY KEY (user_role_id)
);

CREATE TABLE persistent_logins (
    username varchar(64) NOT NULL,
    series varchar(64) NOT NULL,
    token varchar(64) NOT NULL,
    last_used timestamp NOT NULL,
    PRIMARY KEY (series)
);

CREATE TABLE picked_polls (
  id_picked_poll BIGSERIAL,  
  id_question INTEGER NOT NULL,
  username VARCHAR(45),
  PRIMARY KEY (id_picked_poll) 
);

ALTER TABLE user_roles ADD CONSTRAINT fk_username FOREIGN KEY (username) REFERENCES users (username)ON DELETE CASCADE;

ALTER TABLE questions ADD CONSTRAINT fk_questions FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE;

ALTER TABLE answers ADD CONSTRAINT fk_answers FOREIGN KEY (id_question) REFERENCES questions(id_question) ON DELETE CASCADE;

ALTER TABLE picked_polls ADD CONSTRAINT fk_username FOREIGN KEY (username) REFERENCES users (username)ON DELETE CASCADE;

ALTER TABLE picked_polls ADD CONSTRAINT fk_question FOREIGN KEY (id_question) REFERENCES questions(id_question) ON DELETE CASCADE;




CREATE OR REPLACE FUNCTION votes_increment (VARCHAR(45),INTEGER) RETURNS boolean AS $$
DECLARE
v_id_question INTEGER := (SELECT id_question FROM answers WHERE id_answer=$2);

BEGIN 
IF (v_id_question IS NOT NULL) AND EXISTS(SELECT username FROM users WHERE username LIKE $1) AND 
NOT EXISTS (SELECT id_picked_poll FROM picked_polls WHERE username LIKE $1 AND id_question = v_id_question)
THEN
    UPDATE answers SET votes = votes + 1 WHERE id_answer = $2;
    INSERT INTO picked_polls VALUES( DEFAULT,v_id_question, $1);
    RETURN true;
END IF;
RETURN false; 
END; 
$$  LANGUAGE plpgsql


