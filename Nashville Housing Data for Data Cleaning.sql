
select * 
from portfolioproject2.dbo.Nashvilehousing

select datesaled, CONVERT(date,saledate) as date 
from portfolioproject2.dbo.Nashvilehousing

update Nashvilehousing
set SaleDate= CONVERT(date,saledate) 

ALTER TABLE Nashvilehousing
add datesaled date;

update Nashvilehousing
set datesaled = CONVERT(date,saledate)

select PropertyAddress
from portfolioproject2.dbo.Nashvilehousing
where PropertyAddress is NULL

select a.PropertyAddress,a.ParcelID, b.PropertyAddress ,b.ParcelID , ISNULL(a.PropertyAddress , b.PropertyAddress)
from portfolioproject2.dbo.Nashvilehousing a
JOIN portfolioproject2.dbo.Nashvilehousing b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL


update a
set PropertyAddress=ISNULL(a.PropertyAddress , b.PropertyAddress)
from portfolioproject2.dbo.Nashvilehousing a
JOIN portfolioproject2.dbo.Nashvilehousing b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

select
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) as Address ,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) as Address
from portfolioproject2.dbo.Nashvilehousing

ALTER TABLE Nashvilehousing
add PropertyAdresssplit Nvarchar(255);

update Nashvilehousing
set PropertyAdresssplit = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Nashvilehousing
add Propertysplitcity Nvarchar(255);

update Nashvilehousing
set Propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) 

select *
from portfolioproject2.dbo.Nashvilehousing

select OwnerAddress
from portfolioproject2.dbo.Nashvilehousing

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from portfolioproject2.dbo.Nashvilehousing

ALTER TABLE Nashvilehousing
add OwnerAdresssplit Nvarchar(255);

update Nashvilehousing
set OwnerAdresssplit = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Nashvilehousing
add Ownercity Nvarchar(255);

update Nashvilehousing
set Ownercity = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 

ALTER TABLE Nashvilehousing
add Ownerstate Nvarchar(255);

update Nashvilehousing
set Ownerstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select Distinct(SoldAsVacant), count(SoldAsVacant)
from portfolioproject2.dbo.Nashvilehousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
 CASE when SoldAsVacant = 'Y' THEN 'Yes'
      when SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
from portfolioproject2.dbo.Nashvilehousing

update Nashvilehousing
set SoldAsVacant=  CASE when SoldAsVacant = 'Y' THEN 'Yes'
      when SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END

---remove duplicates

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

From portfolioproject2.dbo.NashvileHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

ALTER TABLE PortfolioProject2.dbo.Nashvilehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

select *
from portfolioproject2.dbo.Nashvilehousing