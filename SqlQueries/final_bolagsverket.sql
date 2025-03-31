SELECT
    LEFT(b.organisationsidentitet, instr(b.organisationsidentitet, '$') - 1) as OrganizationIdentity,
    CASE 
        WHEN RIGHT(b.organisationsidentitet, LEN(b.organisationsidentitet) - instr(b.organisationsidentitet, '$')) = 'ORGNR-IDORG' THEN 'Organisationsnummer'
        WHEN RIGHT(b.organisationsidentitet, LEN(b.organisationsidentitet) - instr(b.organisationsidentitet, '$')) = 'PERSON-IDORG' THEN 'Identitetsbetecknig person'
        END as IdentityType,
    namnskyddslopnummer::INTEGER as NameProtectionNumber,
    CASE 
        WHEN b.registreringsland = 'SE-LAND' THEN 'Sverige'
        ELSE b.registreringsland
        END as RegistrationCountry,
    orgnamn.Namn as CompanyName,
    orgnamn.Namn_datum as CompanyName_date,
    organisationsform as OrganizationForm,
    CASE 
        WHEN UPPER(avregistreringsdatum) = UPPER('null') THEN NULL::DATE
        ELSE avregistreringsdatum::DATE
        END  as DeregistrationDate,
    avregistreringsorsak as ReasonForDeregistration,
    registreringsdatum::DATE as RegistrationDate,
    verksamhetsbeskrivning as BusinessDescription,
    po.PostAdress as PostalAddress,
    po.CoAdress as CoAddress,
    po.PostStad as PostalCity,
    po.PostNummer as PostalNumber,
    po.PostLand as PostalCountry
FROM
    bolagsverket b
LEFT OUTER JOIN
    organisationsnamn orgnamn
    ON
        LEFT(b.organisationsidentitet, instr(b.organisationsidentitet, '$') - 1) = orgnamn.organisationsidentitet
        AND orgnamn.objektType = 'Foretagsnamn'
LEFT OUTER JOIN
    postadress po
    ON
        LEFT(b.organisationsidentitet, instr(b.organisationsidentitet, '$') - 1) = po.organisationsidentitet

;
