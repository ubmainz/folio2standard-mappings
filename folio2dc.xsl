<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"      
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:srw_dc="info:srw/schema/1/dc-schema"
    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd"
    version="1.0">
    

    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <!-- Mapping from FOLIO raw format to dc for the FOLIO Z39.50 server 
         Marko Knepper, UB Mainz 2025, Apache 2.0 -->
    
    <xsl:template match="opt"> <!-- expecting an opt element for the record -->
        <oai_dc:dc  xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
            xmlns:srw_dc="info:srw/schema/1/dc-schema"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
            <xsl:apply-templates mode="instance"/>
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
        <dc:subject><xsl:value-of select="value"/></dc:subject>
    </xsl:template>    
    <xsl:template match="identifiers" mode="instance">
        <xsl:if test="identifierTypeId='8261054f-be78-422d-bd51-4ed9f33c3422'">
            <dc:identifier>ISBN: <xsl:value-of select="value"/>
            </dc:identifier>
        </xsl:if>
        <xsl:if test="identifierTypeId='913300b2-03ed-469a-8179-c1092c991227'">
            <dc:identifier>ISSN: <xsl:value-of select="value"/>
            </dc:identifier>
        </xsl:if>
        <xsl:if test="identifierTypeId='ebfd00b6-61d3-4d87-a6d8-810c941176d5'">
            <dc:identifier>ISMN: <xsl:value-of select="value"/>
            </dc:identifier>
        </xsl:if>
        <xsl:if test="identifierTypeId='39554f54-d0bb-4f0a-89a4-e422f6136316'">
            <dc:identifier>DOI: <xsl:value-of select="value"/>
            </dc:identifier>
        </xsl:if>
        <xsl:if test="identifierTypeId='439bfbae-75bc-4f74-9fc7-b2a2d47ce3ef'">
            <dc:identifier>OCLC: <xsl:value-of select="value"/>
            </dc:identifier>
        </xsl:if>
        <xsl:if test="identifierTypeId='7e591197-f335-4afb-bc6d-a6d76ca3bace'">
            <dc:identifier><xsl:value-of select="value"/>
            </dc:identifier>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="languages" mode="instance">
        <dc:language>
            <xsl:value-of select="."/> 
        </dc:language>   
    </xsl:template>
    
    <xsl:template match="text()" mode="instance"/>
</xsl:stylesheet>