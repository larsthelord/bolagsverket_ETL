CREATE OR REPLACE TABLE JurForm AS 
SELECT
    *
FROM (
    VALUES
    (10, 'Fysisk person'),
    (21, 'Enkla bolag'),
    (22, 'Partrederier'),
    (23, 'Värdepappersfonder'),
    (31, 'Handelsbolag, kommanditbolag'),
    (32, 'Gruvbolag'),
    (41, 'Bankaktiebolag'),
    (42, 'Försäkringsaktiebolag'),
    (43, 'Europabolag'),
    (49, 'Övriga aktiebolag'),
    (51, 'Ekonomiska föreningar'),
    (53, 'Bostadsrättsföreningar'),
    (54, 'Kooperativ hyresrättsförening'),
    (61, 'Ideella föreningar'),
    (62, 'Samfälligheter'),
    (63, 'Registrerade trossamfund'),
    (71, 'Familjestiftelser'),
    (72, 'Övriga stiftelser och fonder'),
    (81, 'Statliga enheter'),
    (82, 'Primärkommuner, borgerliga'),
    (83, 'Kommunalförbund'),
    (84, 'Landsting'),
    (85, 'Allmänna försäkringskassor'),
    (87, 'Offentliga korporationer och anstalter'),
    (88, 'Hypoteksföreningar'),
    (89, 'Regionala statliga myndigheter'),
    (91, 'Oskiftade dödsbon'),
    (92, 'Ömsesidiga försäkringsbolag'),
    (93, 'Sparbanker'),
    (94, 'Understödsföreningar'),
    (95, 'Arbetslöshetskassor'),
    (96, 'Utländska juridiska personer'),
    (98, 'Övriga svenska juridiska personer bildade enligt särskild lagstiftning'),
    (99, 'Juridisk form ej utredd')
) v (JurForm, JurDesc);

SELECT
    s.PeOrgNr as PersonOrganizationNumber,
    s.Namn as Name,
    s.Foretagsnamn as OrganizationName,
    s.FtgStat as CompanySatusCode,
    CASE 
        WHEN s.FtgStat = 0 THEN 'Har aldrig varit verksam'
        WHEN s.FtgStat = 1 THEN 'Är verksam enligt företagsregistrets kriterier'
        WHEN s.FtgStat = 9 THEN 'Ej verksam, enligt företagsregistrets kriterier'
        END as CompanySatusDescription,
    s.Gatuadress as StreetAddress,
    s.COAdress as CoAddress,
    s.PostNr as PostalNumber,
    s.PostOrt as PostCity,
    s.JEStat as LegalEntityStatusCode,
    CASE 
        WHEN s.JEStat = 0 THEN 'Ingår i populationen och är registrerad i Skatteverkets organisationsnummerregister'
        WHEN s.JEStat = 1 THEN 'Ingår i populationen och är registrerad på annat sätt'
        WHEN s.JEStat = 2 THEN 'Objekt som ingår i populationen för SCB:s företagsregister men inte ingår i Skatteverkets organisationsnummerregister'
        WHEN s.JEStat = 9 THEN 'Ingår inte längre i populationen (Företaget ligger kvar i SCB:s företagsregister som avregistrerat och rensas bort efter 6 månader.)'
        END as LegalEntityStatusDescription,
    s.JurForm as LegalFormCode,
    jk.JurDesc as LegalFormDescription,
    TRY_CAST(CONCAT(LEFT(s.RegDatKtid::VARCHAR, 4), '-', SUBSTRING(s.RegDatKtid::VARCHAR, 5, 2), '-',  RIGHT(s.RegDatKtid::VARCHAR, 2)) as DATE) as RegistryDate,
    CASE 
        WHEN s.Ng1 IS NOT NULL THEN CONCAT(LEFT(s.Ng1::VARCHAR, 2), '.', RIGHT(s.Ng1::VARCHAR, 3))
        ELSE NULL::VARCHAR
        END as IndustrialClassificationCode1,
    CASE 
        WHEN s.Ng2 IS NOT NULL THEN CONCAT(LEFT(s.Ng2::VARCHAR, 2), '.', RIGHT(s.Ng2::VARCHAR, 3))
        ELSE NULL::VARCHAR
        END as IndustrialClassificationCode2,
    CASE 
        WHEN s.Ng3 IS NOT NULL THEN CONCAT(LEFT(s.Ng3::VARCHAR, 2), '.', RIGHT(s.Ng3::VARCHAR, 3))
        ELSE NULL::VARCHAR
        END as IndustrialClassificationCode3,
    CASE 
        WHEN s.Ng4 IS NOT NULL THEN CONCAT(LEFT(s.Ng4::VARCHAR, 2), '.', RIGHT(s.Ng4::VARCHAR, 3))
        ELSE NULL::VARCHAR
        END as IndustrialClassificationCode4,
    CASE 
        WHEN s.Ng5 IS NOT NULL THEN CONCAT(LEFT(s.Ng5::VARCHAR, 2), '.', RIGHT(s.Ng5::VARCHAR, 3))
        ELSE NULL::VARCHAR
        END as IndustrialClassificationCode5,
    s.Reklamsparrtyp as AdvertisementBlockCode,
    CASE 
        WHEN s.Reklamsparrtyp = 1 THEN 'Företag har inte frånsagt sig mottagande av reklam'
        WHEN s.Reklamsparrtyp = 2 THEN 'Företag har frånsagt sig mottagande av reklam'
        END as AdvertisementBlockDescription
FROM
    scb s
LEFT OUTER JOIN
    JurForm jk
    ON
        s.JurForm = jk.JurForm