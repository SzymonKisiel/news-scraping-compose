DELIMITER $$

DROP PROCEDURE IF EXISTS AddSearchTerm $$

CREATE PROCEDURE AddSearchTerm(IN in_client_name VARCHAR(100), IN in_search_term VARCHAR(200))
BEGIN
	SET @client_id := (
		SELECT c.id
		FROM news_scraping_db.client c
		WHERE c.name = in_client_name
	);
	SET @search_term_id := (
		SELECT st.id
		FROM news_scraping_db.search_term AS st
		WHERE st.term = in_search_term
	);	

	IF @client_id IS NULL THEN
		SET @msg = CONCAT('Client with name ', in_client_name, ' does not exist');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @msg;
	END IF;
	
	IF @search_term_id IS NULL THEN
		INSERT INTO news_scraping_db.search_term
			(term)
		VALUES
			(in_search_term);
		SET @search_term_id := LAST_INSERT_ID();
	ELSE
		SET @client_search_term_count := (
			SELECT COUNT(*)
			FROM news_scraping_db.client_search_term AS cst
			WHERE cst.client_id = @client_id AND
				cst.search_term_id = @search_term_id
		);
		IF @client_search_term_count > 0 THEN
			SET @msg = CONCAT('Client with name ', in_client_name, ' already has term ', in_search_term);
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @msg;
		END IF;
	END IF;

	INSERT INTO news_scraping_db.client_search_term
		(client_id, search_term_id)
	VALUES
		(@client_id, @search_term_id);
END $$

DELIMITER ;
