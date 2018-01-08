USE MarvelCharApps

--X-Men comics
SELECT  AppID
      , c.CharName
	  , n.ComicName
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
  WHERE n.ComicName LIKE '%xm%'  --X-Men Comics
  ORDER BY ComicName;

--Spiderman Comics
SELECT  AppID
      , c.CharName
	  , n.ComicName
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
  WHERE n.ComicName LIKE '%sm%'  --Spiderman Comics
  ORDER BY ComicName;

--Appearances of the Invisible Woman
SELECT  AppID
      , c.CharName
	  , n.ComicName
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
  WHERE c.CharName LIKE 'INVISIBLE WOMAN'  --Appearances of the Invisible Woman
  ORDER BY ComicName;

--Appearances of the Scarlet Witch
SELECT  AppID
      , c.CharName
	  , n.ComicName
FROM CharComicApps AS a
	JOIN MarvelCharacters AS c ON a.CharID = c.CharID
	JOIN ComicNames AS n ON a.ComicID = n.ComicID
  WHERE c.CharName LIKE 'SCARLET WITCH'  --Appearances of the Scarlet Witch
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
--Script used to do manual DB updates of comic long names
UPDATE ComicNames
SET ComicName = REPLACE(ComicName, 'COC', 'MARVEL SUPER HERO CONTEST OF CHAMPIONS')
WHERE ComicName LIKE 'COC %'


--Script used to do manual DB updates of character names
UPDATE MarvelCharacters
SET CharName = 'VOLSTAGG [ASGARDIAN]'
WHERE CharName = 'VOLSTAGG'

--ROLLBACK TRANSACTION
--COMMIT TRANSACTION



begin transaction  
 
UPDATE ComicNames
SET ComicName = REPLACE(ComicName, 'COC', 'MARVEL SUPER HERO CONTEST OF CHAMPIONS')
WHERE ComicName LIKE 'COC %'

begin transaction  -- there is only one transaction - this only increments the @@trancount counter

delete from MarvelCharacters
WHERE CharName = 'VOLSTAGG [ASGARDIAN]'

select @@Trancount  --2

rollback

select @@Trancount  --0


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
