--Cleaning data in SQL queries 

Select*
from PortfolioProject.dbo.NashvilleHousing

--Standardize Sale Date format

Select SaleDateConverted, convert(date,saledate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
Set Saledate = convert(date,saledate)

Alter table NashvilleHousing
add SaledateConverted date;

update NashvilleHousing
Set SaledateConverted = convert(date,saledate)

--Populate Property Address data

Select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  WHere a.PropertyAddress is Null

  update a
  set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]

  --Breaking out Address Into Individual Columns (Address, City, State)

  Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) as Address

from PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

Alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress))

Select*
from PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3)
, PARSENAME(Replace(OwnerAddress,',','.'),2)
, PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
add OwnerAddressSplitAddress Nvarchar(255);

update NashvilleHousing
Set OwnerAddressSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter table NashvilleHousing
add OwnerAddressSplitCity Nvarchar(255);

update NashvilleHousing
Set OwnerAddressSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter table NashvilleHousing
add OwnerAddressSplitState Nvarchar(255);

update NashvilleHousing
Set OwnerAddressSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select *
from PortfolioProject.dbo.NashvilleHousing

--Change Y and N into Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
End
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
End

--Remove Duplicate

Select *,
ROW_NUMBER() over(
partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by 
			   UniqueID
			   ) row_num
from PortfolioProject.dbo.NashvilleHousing

--remove Duplicate

With RownumCTE As(
Select *,
ROW_NUMBER() over(
partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by 
			   UniqueID
			   ) row_num
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Delete
From RownumCTE
where row_num > 1
Order by PropertyAddress

--Delete Unused Columns

Select *
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress