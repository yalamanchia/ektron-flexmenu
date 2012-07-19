<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes"/>
	<!--xsl:strip-space elements="*"/-->
	<xsl:variable name="controlHash"><xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/></xsl:variable>
	<xsl:variable name="menuConst"><xsl:value-of select="$controlHash"/>_<xsl:value-of select="/MenuDataResult/Info/ControlMenuId"/>_</xsl:variable>
	<xsl:variable name="masterHash"><xsl:value-of select="/MenuDataResult/Info/MasterControlIdHash"/></xsl:variable>
	<xsl:variable name="buttonNoScriptLink"><xsl:value-of select="/MenuDataResult/Info/ButtonNoScriptLink"/></xsl:variable>
	<xsl:variable name="slaveMenu"><xsl:value-of select="/MenuDataResult/Info/IsSlaveControl"/></xsl:variable>
	<xsl:variable name="startLevel"><xsl:value-of select="/MenuDataResult/Info/StartLevel"/></xsl:variable>

	<xsl:template match="/">	
		  <xsl:apply-templates select="MenuDataResult/Item"/>
	</xsl:template>

	<xsl:template match="Item[parent::MenuDataResult]">
		<!-- <xsl:when test="/MenuDataResult/Info/MenuFragment='false'">				
					<link type="text/css" rel="stylesheet">
						<xsl:attribute name="href"><xsl:value-of select="/MenuDataResult/Info/CssFileName"/></xsl:attribute>
					</link>				
		</xsl:when> -->		
		<ul>
			<xsl:apply-templates select="Item"/>
		</ul>
	</xsl:template>

	<xsl:template match="Item[child::Menu | ItemType='Submenu']">
		<li>
			<xsl:if test="ItemLevel='1'">
				<xsl:attribute name="class">section</xsl:attribute>
			</xsl:if>
			<xsl:if test="ItemLevel='2'">
				<xsl:attribute name="class">section</xsl:attribute>
			</xsl:if>
                        <xsl:if test="position() &lt; 6">
                        	<xsl:attribute name="class">section-top</xsl:attribute>
                        </xsl:if>
			<xsl:if test="(descendant-or-self::MenuSelected='true' or Item[descendant-or-self::ItemSelected='true'])">
				<xsl:attribute name="class">section-selected</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="Menu"/>
		</li>
	</xsl:template>

	<xsl:template name="makelist" match="Menu">
		<xsl:call-template name="makeButton" />
		<xsl:if test="./Item/Menu[MenuId!=''] | ./Item[ItemId!=''][ItemType!='Submenu'] ">
			<xsl:if test="(descendant-or-self::MenuSelected='true' or Item[descendant-or-self::ItemSelected='true']) and child::Item">
				<ul>
					<xsl:apply-templates select="Item"/>
				</ul>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Item[ItemType!='Submenu']">
		<li>
			<xsl:variable name="targetLoc">
				<xsl:choose>
					<xsl:when test="ItemTarget='1'">_blank</xsl:when>
					<xsl:when test="ItemTarget='3'">_parent</xsl:when>
					<xsl:when test="ItemTarget='4'">_top</xsl:when>
					<xsl:otherwise>_self</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="ItemLink"/>
				</xsl:attribute>
				<xsl:attribute name="target">
					<xsl:value-of select="$targetLoc"/>
				</xsl:attribute>
				<xsl:value-of select="ItemTitle"/>
			</a>
			<xsl:apply-templates select="Item|Menu"/>
		</li>
	</xsl:template>

	<xsl:template name="makeButton">
		<xsl:if test="not((/MenuDataResult/Info/MenuFragment='true') and (MenuLevel = '1') and $slaveMenu='true')">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="Link"/>
				</xsl:attribute>
				<xsl:value-of select="Title"/>
			</a>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

