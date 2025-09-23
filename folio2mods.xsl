<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-8.xsd"
    version="1.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <!-- Mapping from FOLIO raw format to mods for the FOLIO Z39.50 server 
         Marko Knepper, UB Mainz 2025, Apache 2.0 -->

    <xsl:template match="opt"> <!-- expecting an opt element for the record -->
        <mods:mods>
            <xsl:apply-templates mode="instance"/>
            <mods:recordInfo>
                <mods:recordCreationDate encoding="iso8601"><xsl:value-of select="metadata/createdDate"/></mods:recordCreationDate>
                <mods:recordChangeDate encoding="iso8601"><xsl:value-of select="metadata/updatedDate"/></mods:recordChangeDate>
                <mods:recordIdentifier source="{source}"><xsl:value-of select="hrid"/></mods:recordIdentifier>
                <mods:recordIdentifier source="uuid"><xsl:value-of select="id"/></mods:recordIdentifier>
            </mods:recordInfo>
        </mods:mods>
    </xsl:template>

    <xsl:template match="holdingsRecords2" mode="instance">
        <mods:location>
            <mods:physicalLocation>
                <xsl:value-of select="permanentLocation/institution/name"/><xsl:text>, </xsl:text>
                <xsl:value-of select="permanentLocation/library/name"/>
            </mods:physicalLocation>
            <xsl:choose>
                <xsl:when test="bareHoldingsItems">
                    <mods:holdingSimple>
                        <xsl:apply-templates select="bareHoldingsItems" mode="holdings"/>                    
                    </mods:holdingSimple>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="callNumber" mode="holdings"/>
                </xsl:otherwise>
            </xsl:choose>
        </mods:location>
    </xsl:template>

    <xsl:template match="title" mode="instance">
        <mods:titleInfo>
            <mods:title><xsl:value-of select="."/></mods:title>
        </mods:titleInfo>
    </xsl:template>
    
    <xsl:template match="contributors" mode="instance">
        <mods:name>
            <mods:displayForm><xsl:value-of select="name"/></mods:displayForm>
        </mods:name>
    </xsl:template>
    
    <xsl:template match="publication" mode="instance">
        <mods:originInfo>
            <mods:publisher><xsl:value-of select="publisher"/></mods:publisher>
            <mods:dateIssued keyDate="yes"><xsl:value-of select="dateOfPublication"/></mods:dateIssued>
        </mods:originInfo>
    </xsl:template>
   
    <xsl:template match="classifications" mode="instance">
        <xsl:variable name="list"> <!-- covering some of the reference data -->
            <mods:classification authority="ce176ace-a53e-4b4d-aa89-725ed7b2edac" displayLabel="LCC" authorityURI="http://id.loc.gov/vocabulary/classSchemes/lcc"/>
            <mods:classification authority="42471af9-7d25-4f3a-bf78-60d29dcf463b" displayLabel="DDC" authorityURI="http://id.loc.gov/vocabulary/classSchemes/ddc"/>
        </xsl:variable>
        <mods:classification authority="{classificationTypeId}">
            <xsl:copy-of select="$list/mods:classification[@authority=current()/classificationTypeId]/@*"/>
            <xsl:value-of select="classificationNumber"/>
        </mods:classification>
    </xsl:template>
    
    <xsl:template match="subjects" mode="instance">
        <mods:subject>
            <mods:topic><xsl:value-of select="value"/></mods:topic>
        </mods:subject>
    </xsl:template>
   
    <xsl:template match="identifiers" mode="instance">
        <xsl:variable name="list"> <!-- covering some of the reference data -->
            <mods:identifier type="8261054f-be78-422d-bd51-4ed9f33c3422" displayLabel="ISBN" typeURI="http://id.loc.gov/vocabulary/identifiers/isbn"/>
            <mods:identifier type="913300b2-03ed-469a-8179-c1092c991227" displayLabel="ISSN" typeURI="http://id.loc.gov/vocabulary/identifiers/issn"/>
            <mods:identifier type="ebfd00b6-61d3-4d87-a6d8-810c941176d5" displayLabel="ISMN" typeURI="http://id.loc.gov/vocabulary/identifiers/ismm"/>
            <mods:identifier type="39554f54-d0bb-4f0a-89a4-e422f6136316" displayLabel="DOI" typeURI="http://id.loc.gov/vocabulary/identifiers/doi"/>
        </xsl:variable>
        <mods:identifier type="{identifierTypeId}">
            <xsl:copy-of select="$list/mods:identifier[@type=current()/identifierTypeId]/@*"/>
            <xsl:value-of select="value"/>
        </mods:identifier>
   </xsl:template>
   
    <xsl:template match="callNumber[text()]" mode="holdings">
        <mods:shelfLocator>
            <xsl:if test="../callNumberPrefix/text()"><xsl:value-of select="../callNumberPrefix"/><xsl:text> </xsl:text></xsl:if>
            <xsl:value-of select="."/>
            <xsl:if test="../callNumberSuffix/text()"><xsl:text> </xsl:text><xsl:value-of select="../callNumberSuffix"/></xsl:if>
        </mods:shelfLocator>
    </xsl:template>
   
    <xsl:template match="bareHoldingsItems" mode="holdings"> <!-- mapping each item of all holdings on mods:copyInformation -->
        <mods:copyInformation>
            <xsl:apply-templates select="materialType" mode="item"/>
            <xsl:choose>         <!-- permanentLocation is inherited here -->
                <xsl:when test="permanentLocation/name/text()">
                    <xsl:apply-templates select="permanentLocation" mode="item"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="../permanentLocation" mode="item"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="effectiveCallNumberComponents" mode="item"/>
            <xsl:apply-templates select="../notes" mode="item"/>
            <xsl:apply-templates select="chronology|copyNumber" mode="item"/>
            <xsl:apply-templates select="barcode|hrid" mode="item"/>
        </mods:copyInformation>
    </xsl:template>
    
    <xsl:template match="effectiveCallNumberComponents" mode="item">
        <mods:shelfLocator>
            <xsl:if test="prefix/text()"><xsl:value-of select="prefix"/><xsl:text> </xsl:text></xsl:if>
            <xsl:value-of select="callNumber"/>
            <xsl:if test="suffix/text()"><xsl:text> </xsl:text><xsl:value-of select="suffix"/></xsl:if>
        </mods:shelfLocator>
    </xsl:template>
    
    <xsl:template match="permanentLocation" mode="item">
        <mods:subLocation><xsl:value-of select="name"/></mods:subLocation>
    </xsl:template>
    
    <xsl:template match="barcode" mode="item">
        <mods:itemIdentifier type="barcode"><xsl:value-of select="."/></mods:itemIdentifier>
    </xsl:template>
    
    <xsl:template match="hrid" mode= "item">
        <mods:itemIdentifier type="hrid"><xsl:value-of select="."/></mods:itemIdentifier>
    </xsl:template>
    
    <xsl:template match="materialType" mode="item">
        <mods:form><xsl:value-of select="name"/></mods:form>
    </xsl:template>
    
    <xsl:template match="notes" mode="item">
        <mods:note type="{holdingsNoteType/name}"><xsl:value-of select="note"/></mods:note>
    </xsl:template>

    <xsl:template match="chronology[text()]|copyNumber[text()]" mode="item">
        <mods:enumerationAndChronology unitType="1"><xsl:value-of select="."/></mods:enumerationAndChronology>
    </xsl:template>

    <xsl:template match="text()" mode="instance"/>
</xsl:stylesheet>
