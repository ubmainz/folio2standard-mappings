<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-8.xsd"
    version="2.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <!-- Mapping from FOLIO raw format to mods for the FOLIO Z39.50 server 
         Marko Knepper, UB Mainz 2025, Apache 2.0 -->

    <xsl:template match="opt"> <!-- expecting an opt element for the record -->
        <mods:mods>
            <xsl:apply-templates mode="instance"/>
            <mods:location>
                <mods:physicalLocation><xsl:value-of select="holdingsRecords2[1]/permanentLocation/institution/name"/></mods:physicalLocation>
                <mods:holdingSimple>
                    <xsl:apply-templates select="//bareHoldingsItems" mode="holdings"/>
                </mods:holdingSimple>
            </mods:location>
            <mods:recordInfo>
                <mods:recordIdentifier source="hrid"><xsl:value-of select="hrid"/></mods:recordIdentifier>
                <mods:recordIdentifier source="uuid"><xsl:value-of select="id"/></mods:recordIdentifier>
            </mods:recordInfo>
        </mods:mods>
    </xsl:template>

    <xsl:template match="title" mode="instance">
        <mods:titleInfo>
            <mods:title><xsl:value-of select="."/></mods:title>
        </mods:titleInfo>
    </xsl:template>
    
    <xsl:template match="id">
        
    </xsl:template>

    <xsl:template match="bareHoldingsItems" mode="holdings"> <!-- mapping each item of all holdings on mods:copyInformation -->
        <!-- permanentLocation is empty on item level - fetching from holding level as workaround -->
        <mods:copyInformation>
            <xsl:apply-templates select="materialType,../permanentLocation,effectiveCallNumberComponents,../notes,chronology,copyNumber,barcode,hrid" mode="item"/>
        </mods:copyInformation>
    </xsl:template>
    
    <xsl:template match="effectiveCallNumberComponents" mode="item">
        <mods:shelfLocator><xsl:value-of select="prefix[text()],callNumber[text()],suffix[text()]" separator=" "/></mods:shelfLocator>
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

    <xsl:template match="(chronology|copyNumber)[text()]" mode="item">
        <mods:enumerationAndChronology unitType="1"><xsl:value-of select="."/></mods:enumerationAndChronology>
    </xsl:template>

    <xsl:template match="*" mode="#all"/>
</xsl:stylesheet>
