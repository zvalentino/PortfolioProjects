/*
Cleaning Data in SQL Queries
*/


Select *
From portfolioproject.dbo.nashvillehousing


-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From portfolioproject.dbo.nashvillehousing


Update nashvillehousing
SET SaleDate = CONVERT(Date,SaleDate)


-- Populate Property Address data

Select *
From portfolioproject.dbo.nashvillehousing
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfolioproject.dbo.nashvillehousing a
JOIN portfolioproject.dbo.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfolioproject.dbo.nashvillehousing a
JOIN portfolioproject.dbo.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From portfolioproject.dbo.nashvillehousing


ALTER TABLE nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select OwnerAddress
From portfolioproject.dbo.nashvillehousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From portfolioproject.dbo.nashvillehousing



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From portfolioproject.dbo.nashvillehousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From portfolioproject.dbo.nashvillehousing


Update nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From portfolioproject.dbo.nashvillehousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From portfolioproject.dbo.nashvillehousing



-- Delete Unused Columns



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
