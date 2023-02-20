--select SaleDateConverted, CONVERT(Date, SaleDate)
--from portfolio_project.dbo.Nashville_housing


--Update Nashville_housing
--Set SaleDate = CONVERT(Date, SaleDate)

--Changing Date formating
ALTER TABLE Nashville_housing
Add SaleDateConverted Date;

Update Nashville_housing
Set SaleDateConverted = CONVERT(Date, SaleDate)

--Replacing Null Property Addresses with the known address using the Parcel ID's & UniqueID's and updating Table

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
from portfolio_project.dbo.Nashville_housing a
join portfolio_project.dbo.Nashville_housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> B.[UniqueID ]
where a.PropertyAddress is null;

Update a
set PropertyAddress = ISNULL(a.propertyAddress, b.PropertyAddress)
from portfolio_project.dbo.Nashville_housing a
join portfolio_project.dbo.Nashville_housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> B.[UniqueID ]
where a.PropertyAddress is null



select PropertyAddress
from portfolio_project.dbo.Nashville_housing;
--Using Substring and Charindex to seperate street address and city from propertyAddress
select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from portfolio_project.dbo.Nashville_housing;


ALTER TABLE Nashville_housing
Add PropertyStreetAddress nvarchar(255);

--Updating the table to include these new columns
Update Nashville_housing
Set PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)



ALTER TABLE Nashville_housing
Add PropertyCityAddress nvarchar(255);


Update Nashville_housing
Set PropertyCityAddress = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


select *
from portfolio_project.dbo.Nashville_housing

alter table nashville_housing
drop column PropertyStreetAddressn;

select OwnerAddress
from portfolio_project.dbo.Nashville_housing
--Using Parsename & Replace instead of substring & CharIndex to split owner's street, city, & state
select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from portfolio_project.dbo.Nashville_housing

--adding the new columns
ALTER TABLE Nashville_housing
Add OwnerStreetAddress nvarchar(255);

Update Nashville_housing
Set OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)



ALTER TABLE Nashville_housing
Add OwnerCityAddress nvarchar(255);


Update Nashville_housing
Set OwnerCityAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),2)



ALTER TABLE Nashville_housing
Add OwnerStateAddress nvarchar(255);


Update Nashville_housing
Set OwnerStateAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


-- using a case to update 'y' and 'n' to the approprite format for uniformity 
select SoldAsVacant,
case when SoldAsVacant = 'Y' THEN 'Yes'
	 when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 End
from portfolio_project.dbo.Nashville_housing

Update Nashville_housing
set SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'Yes'
	 when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 End

select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
from portfolio_project.dbo.Nashville_housing
Group By SoldAsVacant
order by 2 desc;
--Utilizing a CTE alongside partition to find duplicates and deleting based off of if there are additional rows 
with RowNUMCTE AS(
Select *, ROW_NUMBER() Over (
		Partition by ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference 
		ORDER BY
			UniqueID)
			Row_num
from portfolio_project.dbo.Nashville_housing
--order by ParcelID)
)select *
from RowNUMCTE
where Row_num > 1

select *
From portfolio_project.dbo.Nashville_housing;
--dropping unused columns
Alter Table portfolio_project.dbo.Nashville_housing
drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table portfolio_project.dbo.Nashville_housing
drop column SaleDate;