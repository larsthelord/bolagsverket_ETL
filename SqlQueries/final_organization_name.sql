SELECT
    organisationsidentitet as OrganizationIdentity,
    objektType as OrganizationNameType,
    ROW_NUMBER() OVER (PARTITION BY organisationsidentitet, objektType ORDER BY Namn_datum) as Enumerator,
    Namn as Name,
    Namn_type as NameType,
    Namn_datum as NameDate,
    Namn_Beskrivelse as NameDescription
FROM
    organisationsnamn