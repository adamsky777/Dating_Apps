WITH DatingCompanies AS (
    SELECT DISTINCT c.CompanyID, c.CompanyName, c.Website
    FROM Company c
    join pitchbook_db.CompanyDescription cd on c.CompanyID = cd.CompanyID
    WHERE cd.DescriptionShort LIKE '%Dating%' 
       OR CompanyName IN ('Tinder', 'Bumble', 'Hinge', 'OkCupid', 'Match', 'PlentyOfFish')
),
FundingDetails AS (
    -- Extract financing details (Replace 'Deals' with the correct table)
    SELECT 
        c.CompanyID, 
        c.CompanyName,
        d.DealSize AS InvestmentAmount,
        d.PremoneyValuation,
        d.PostValuation,
        dti.DealType,
        d.InvestorOwnership
    FROM DatingCompanies c
    JOIN pitchbook_db.Deal d ON c.CompanyID = d.CompanyID
    join pitchbook_db.DealTypeInfo dti on d.DealID = dti.DealID
    WHERE dti.DealType IN ('Angel', 'Seed', 'Series A') -- Modify as needed
)
SELECT 
    f.CompanyName,
    f.InvestmentAmount,
    f.PremoneyValuation,
    f.PostValuation,
    f.DealType,
    f.InvestorOwnership
FROM FundingDetails f
ORDER BY f.CompanyName


WITH DatingCompanies AS (
    SELECT DISTINCT c.CompanyID, c.CompanyName, c.Website
    FROM pitchbook_db.Company c
    JOIN pitchbook_db.CompanyDescription cd ON c.CompanyID = cd.CompanyID
    WHERE cd.DescriptionShort LIKE '%Dating%' 
       OR c.CompanyName IN ('Tinder', 'Bumble', 'Hinge', 'OkCupid', 'Match', 'PlentyOfFish') 
),
FundingDetails AS (
    SELECT 
        c.CompanyID, 
        c.CompanyName,
        c.Website,
        d.DealSize AS InvestmentAmount,
        d.PremoneyValuation,
        d.PostValuation,
        dti.DealType,
        d.InvestorOwnership
    FROM DatingCompanies c
    JOIN pitchbook_db.Deal d ON c.CompanyID = d.CompanyID
    JOIN pitchbook_db.DealTypeInfo dti ON d.DealID = dti.DealID
    WHERE dti.DealType IN ('Angel (individual)', 'Seed Round', 'Early Stage VC', 'Accelerator/Incubator') 
)
SELECT 
    f.CompanyName,
    f.Website,
    f.InvestmentAmount,
    f.PremoneyValuation,
    f.PostValuation,
    f.DealType,
    f.InvestorOwnership
FROM FundingDetails f
where f.PremoneyValuation is not null
ORDER BY 1 asc
