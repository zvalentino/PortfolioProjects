--Data Cleaning in SQL--

SELECT *
FROM athletes_event_results;


SELECT ID,
	   Name AS 'Athlete Name', --Rename athlete column for better understanding 
	   Age,
				CASE When Age < 18 then 'Under 18' 
				WHEN [Age] BETWEEN 18 AND 25 THEN '18-25'
				WHEN [Age] BETWEEN 25 AND 30 THEN '25-30'
				WHEN [Age] > 30 THEN 'Over 30'
				END AS 'Age Grouping',
		Height,
		Weight, 
		NOC AS 'Nation Code', --Explained Abbreviation
		LEFT(Games, CHARINDEX(' ', Games) -1) AS 'Year', --splits the year and season based on the space (use of charindex function)
		RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) AS 'Season',
		Sport,
		Event,
		CASE WHEN Medal = 'NA' THEN 'Not Registered' ELSE Medal END AS Medal -- Replaced NA with Not Registered

FROM [olympic_games].[dbo].[athletes_event_results]

		

		


FROM athletes_event_results;

--




