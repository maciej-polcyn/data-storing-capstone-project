USE warehousing_capstone;

DELIMITER $$
CREATE PROCEDURE UpdateSalesGenmodel()
BEGIN
    DECLARE current_id INT;
    SET current_id = (SELECT MIN(Row_ID) FROM sales);

    WHILE current_id IS NOT NULL DO
        UPDATE sales
        SET Genmodel = (
            CASE
                WHEN LOCATE(" ", Maker) = 0 THEN TRIM(TRIM(LEADING SUBSTRING_INDEX(Genmodel, " ", 1) FROM Genmodel))
                ELSE TRIM(TRIM(LEADING SUBSTRING_INDEX(Genmodel, " ", 2) FROM Genmodel))
            END
        )
        WHERE Row_ID = current_id;
        SET current_id = (SELECT MIN(Row_ID) FROM sales WHERE Row_ID > current_id);
    END WHILE;
END$$
DELIMITER ;

CALL UpdateSalesGenmodel();

SELECT * FROM sales
ORDER BY Maker;