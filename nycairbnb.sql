/* Data Analysis Project */

--What borough has the most listings?

SELECT neighbourhood_group, count(id) as 'Listing Count'
FROM dbo.AB_NYC_2019$
GROUP BY neighbourhood_group 
ORDER BY [Listing Count] DESC;

--Manhatten has the most listings while Brooklyn comes to a close second

------------------------------------------------------------------------------------------------

--Which neighbourhood has the highest listing count? 

SELECT neighbourhood, count(id) as 'Neighbourhood Listing Count'
FROM dbo.AB_NYC_2019$ 
GROUP BY neighbourhood
ORDER BY [Neighbourhood Listing Count] DESC

--Interesting that Manhattan has the highest amount of listings but Williamsburg, 
--a neighbourhood in Brooklyn, has more total listings per neighbourhood


-------------------------------------------------------------------------------------------------

--What boourough has the most hosts? 

SELECT neighbourhood_group, count(distinct(host_id)) as 'Host Count'
FROM dbo.AB_NYC_2019$ 
GROUP BY neighbourhood_group
ORDER BY [Host Count] DESC;

--Manhatten has the highest host count

---------------------------------------------------------------------------------------------------------

--What is the average price of a room in each borough?

SELECT neighbourhood_group, avg(price) AS 'average price'
FROM dbo.AB_NYC_2019$
GROUP BY neighbourhood_group
ORDER BY [average price] DESC;

--Manhattan is the most expensive

----------------------------------------------------------------------------------------------------------

--What is the number of each kind of airbnb and average price of room per type?

SELECT room_type, count(ID) AS 'Room Type Count',avg(price) AS 'Average Price'
FROM dbo.AB_NYC_2019$
GROUP BY room_type
ORDER BY [Average Price],Count(ID) 

-- Entire home/apartment has the highest count and highest average price

----------------------------------------------------------------------------------------------------------
 -- On average, how many airbnb's does each host own? 


SELECT neighbourhood_group, COUNT(DISTINCT host_id) AS 'Host Count', ROUND(COUNT(*)/COUNT(DISTINCT host_id), 2) AS 'Listings Per Host'
FROM dbo.AB_NYC_2019$
GROUP BY neighbourhood_group
ORDER BY [Host Count] DESC;

-----------------------------------------------------------------------------------------------------------
--Who has the most listings on Airbnb?

SELECT host_id, host_name, COUNT(id) AS 'Listing Count'
FROM dbo.AB_NYC_2019$
GROUP BY host_id, host_name
ORDER BY [Listing Count] DESC

--The Sonder Group NYC 

-----------------------------------------------------------------------------------------------------------

--Where does the Sonder Group NYC have the most listings? 

SELECT neighbourhood, neighbourhood_group, host_name, COUNT(DISTINCT id) as 'Number of Listings'
FROM dbo.AB_NYC_2019$
WHERE host_name like '%Sonder%'
GROUP BY neighbourhood, neighbourhood_group, host_name
ORDER BY COUNT(id) DESC

--All of Sonder's properties are located in Manhattan with the most listings in the Financial District and the least in Kips Bay











