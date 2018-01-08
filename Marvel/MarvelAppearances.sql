--DROP VIEW CharacterAppearances

--CREATE VIEW CharacterAppearances AS
--USE MarvelCharApps
SELECT  n.ComicID
	  , n.ComicName
      , c.CharName
	  , c.CharID
	  , ROW_NUMBER() OVER (PARTITION BY n.ComicName ORDER BY n.ComicName) AS ComicCharNumber
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
ORDER BY n.ComicID, ComicCharNumber

SELECT  a.ComicID
	  , a.CharID
	  , a.AppID
FROM CharComicApps AS a
ORDER BY a.ComicID

SELECT a.CharName
FROM MarvelCharacters AS a
WHERE a.CharID IN ('6084', '2664', '2506', '1818')