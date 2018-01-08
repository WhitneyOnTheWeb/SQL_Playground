USE MarvelCharApps
---------------------------------------------------------------------------------------------
-- View of characters in each comic, with grouping showing how many characters are accounted
-- for in each comic 

-- These views are required for the mining model to work-------------------------------------
---------------------------------------------------------------------------------------------

--DROP VIEW CharacterAppearances
--CREATE VIEW CharacterAppearances AS
SELECT  n.ComicID
	  , n.ComicName
      , c.CharName
	  , c.CharID
	  , ROW_NUMBER() OVER (PARTITION BY n.ComicName ORDER BY n.ComicName) AS ComicCharNumber
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
ORDER BY n.ComicID, ComicCharNumber;


--DROP VIEW CharComicAppsView
CREATE VIEW CharComicAppsView AS
SELECT  n.ComicID
	  , n.ComicName
      , c.CharName
	  , c.CharID
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Data validation and investigation for the results of the mining model

--USE MarvelCharApps

--Use to compare the numbers grouped together by the data mining model in order to see the
--long form names of the characters that are likely to appear together.
SELECT a.CharName
	 , a.CharRealName
	 , a.CharID
FROM MarvelCharacters AS a
WHERE a.CharID IN ('6084', '2506', '1818')

--Verify that Volstagg, Fandral and Hogun all appear together in Thor 216
SELECT  n.ComicID
	  , n.ComicName
      , c.CharName
	  , c.CharID
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
WHERE n.ComicID IN ('6500')
