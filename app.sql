1
SELECT COUNT(*) AS nombre_matchs 
FROM Match 
WHERE numJournee = 12;

2
SELECT numJournee, COUNT(*) AS Nombre 
FROM Match 
GROUP BY numJournee;

3
SELECT * 
FROM Match 
ORDER BY nombreSpectateur DESC 
LIMIT 1;

4
SELECT 
    SUM(
        CASE 
            WHEN codeEquipeLocaux = 112 AND nombreButLocaux > nombreButVisiteurs THEN 3
            WHEN codeEquipeVisiteurs = 112 AND nombreButVisiteurs > nombreButLocaux THEN 3
            WHEN (codeEquipeLocaux = 112 OR codeEquipeVisiteurs = 112) AND nombreButLocaux = nombreButVisiteurs THEN 1
            ELSE 0
        END
    ) AS points
FROM Match
WHERE codeEquipeLocaux = 112 OR codeEquipeVisiteurs = 112;


5
    delimiter //
CREATE PROCEDURE EquipesGagnantes(  numJourneeParam INT)
BEGIN
    SELECT e.nomEquipe 
    FROM Match m
    JOIN Equipe e ON (m.codeEquipeLocaux = e.codeEquipe AND m.nombreButLocaux > m.nombreButVisiteurs)
        OR (m.codeEquipeVisiteurs = e.codeEquipe AND m.nombreButVisiteurs > m.nombreButLocaux)
    WHERE m.numJournee = numJourneeParam;
END//




6
delimiter //
CREATE TRIGGER VerifierEquipesDifferentes
BEFORE INSERT ON Match
FOR EACH ROW
BEGIN
    IF NEW.codeEquipeLocaux = NEW.codeEquipeVisiteurs THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Une équipe ne peut pas jouer contre elle-même';
    END IF;
END//
