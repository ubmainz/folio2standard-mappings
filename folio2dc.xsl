<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"      
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:srw_dc="info:srw/schema/1/dc-schema"
    version="1.0">
    

    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <!-- Mapping from FOLIO raw format to dc for the FOLIO Z39.50 server 
         Marko Knepper, UB Mainz 2025, Apache 2.0 -->
    
    <xsl:template match="opt"> <!-- expecting an opt element for the record -->
        <oai_dc:dc>
            <xsl:apply-templates mode="instance"/>
            <!-- 
            <dc:identifier source="hrid"><xsl:value-of select="hrid"/></dc:identifier>
            <dc:identifier source="uuid"><xsl:value-of select="id"/></dc:identifier>
            -->
        </oai_dc:dc>
    </xsl:template>
    
    <xsl:template match="title" mode="instance">
            <dc:title><xsl:value-of select="."/></dc:title>
    </xsl:template>
    
    <xsl:template match="contributors" mode="instance">
        <dc:contributor>
            <xsl:value-of select="name"/>
        </dc:contributor>
    </xsl:template>
    
    <xsl:template match="publication" mode="instance">
        <dc:date>
            <xsl:value-of select="translate(dateOfPublication, 'c', '')"/>
        </dc:date>
        <dc:publisher>
            <xsl:value-of select="publisher"/>
        </dc:publisher>
    </xsl:template>
    
    <xsl:template match="subjects" mode="instance">
        <dc:subject>
            <dc:topic><xsl:value-of select="value"/></dc:topic>
        </dc:subject>
    </xsl:template>
    
    <xsl:template match="identifiers" mode="instance">
        <xsl:variable name="list"> <!-- covering some of the reference data -->
            <dc:identifier type="8261054f-be78-422d-bd51-4ed9f33c3422" displayLabel="ISBN" typeURI="http://id.loc.gov/vocabulary/identifiers/isbn"/>
            <dc:identifier type="913300b2-03ed-469a-8179-c1092c991227" displayLabel="ISSN" typeURI="http://id.loc.gov/vocabulary/identifiers/issn"/>
            <dc:identifier type="ebfd00b6-61d3-4d87-a6d8-810c941176d5" displayLabel="ISMN" typeURI="http://id.loc.gov/vocabulary/identifiers/ismm"/>
            <dc:identifier type="39554f54-d0bb-4f0a-89a4-e422f6136316" displayLabel="DOI" typeURI="http://id.loc.gov/vocabulary/identifiers/doi"/>
        </xsl:variable>
        <dc:identifier type="{identifierTypeId}">
            <xsl:copy-of select="$list/dc:identifier[@type=current()/identifierTypeId]/@*"/>
            <xsl:value-of select="value"/>
        </dc:identifier>
    </xsl:template>
    
    <xsl:template match="text()" mode="instance"/>
</xsl:stylesheet>