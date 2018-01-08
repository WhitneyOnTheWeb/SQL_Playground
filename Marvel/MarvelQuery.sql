USE MarvelCharApps

SELECT  AppID
      , c.CharName
	  , n.ComicName
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
  WHERE n.ComicName LIKE '%xm%'  --X-Men Appearances
  ORDER BY ComicName;

SELECT  AppID
      , c.CharName
	  , n.ComicName
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
  WHERE n.ComicName LIKE '%sm%'  --Spiderman Appearances
  ORDER BY ComicName;

SELECT  AppID
      , c.CharName
	  , n.ComicName
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
  WHERE n.ComicName LIKE '%pwj%'  --Punisher War Journal Appearances
  ORDER BY ComicName;
----------------------------------------------------------------------

SELECT  AppID
      , c.CharName
	  , n.ComicName
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
  WHERE c.CharName LIKE '%AMERICAN EAGLE%'  --Appearances of the Punisher
  ORDER BY ComicName;


  --------------------------------------------------------------------
  --------------------------------------------------------------------
  --	Experimental Practice for Updating Names to Full Length		--
  --	    Updates to full column name are not yet complete		--
  --           Consider column for pubdate in the future        	--
  --------------------------------------------------------------------
  --------------------------------------------------------------------

USE MarvelCharApps

BEGIN TRANSACTION

UPDATE ComicNames
SET ComicName = REPLACE(ComicName, 'COC', 'MARVEL SUPER HERO CONTEST OF CHAMPIONS')
WHERE ComicName LIKE 'COC %'


UPDATE MarvelCharacters
SET CharName = 'PROFESSOR X/CHARLES XAVIER'
WHERE CharName = 'PROFESSOR X/CHARLES '

--ROLLBACK TRANSACTION
--COMMIT TRANSACTION


--before
SELECT  c.CharName
	  , n.ComicName
	  , n.ComicShortName
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
  WHERE n.ComicName LIKE 'warlock%' 
  ORDER BY ComicName;

--after
SELECT  c.CharName
	  , n.ComicName
	  , n.ComicShortName
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
  WHERE n.ComicName LIKE '%Marvel%'
  ORDER BY ComicName;

SELECT *
FROM ComicNames
Order by ComicID
