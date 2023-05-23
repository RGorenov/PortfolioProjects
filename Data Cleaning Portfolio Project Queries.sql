

SELECT * 
From PortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------

--Standardize Data Format 

Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER Table NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)





--Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Brealing out Address Int Individual Columns ( Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
order by ParcelID

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

ALTER Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 )

ALTER Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE (OwnerAddress,',', '.') , 3)
,PARSENAME(REPLACE (OwnerAddress,',', '.') , 2)
,PARSENAME(REPLACE (OwnerAddress,',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing




ALTER Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE (OwnerAddress,',', '.') , 3)

ALTER Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE (OwnerAddress,',', '.') , 2)

ALTER Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE (OwnerAddress,',', '.') , 1)


Select *
From PortfolioProject.dbo.NashvilleHousing



--Select Y and N to YES and NO in 'Sold as Vacant' field


Select Distinct(SoldasVacant), Count(SoldasVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldasVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant ='N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing 

Update NashvilleHousing
SET SoldasVacant = CASE When SoldasVacant =  'Y' THEN 'Yes'
       When SoldAsVacant ='N' THEN 'No'
	   ELSE SoldAsVacant
	   END




 -- Remove Duplicates

 With RowNumCTE AS (
 Select *,
 ROW_NUMBER () OVER (
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY 
			    UniqueID
				) row_num
 From PortfolioProject.dbo.NashvilleHousing
 )
Select *
 From RowNumCTE
 Where row_num > 1
 Order by PropertyAddress


 --Delete Unused Colums


 Select*
 From PortfolioProject.dbo.NashvilleHousing


 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 DROP COLUMN SaleDate

