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
		<xsl:choose>
			<xsl:when test="/MenuDataResult/Info/MenuFragment='false'">
				 <xsl:if test="/MenuDataResult/Info/UseCssHardLink='true'">
				          <link type="text/css" rel="stylesheet">
				            <xsl:attribute name="href"><xsl:value-of select="/MenuDataResult/Info/CssFileName"/></xsl:attribute>
				          </link>
				        </xsl:if> 

				<div>
					<xsl:attribute name="class"><xsl:value-of select="/MenuDataResult/Info/WrappingClassName"/></xsl:attribute>
					<div>
						<xsl:attribute name="class">ekflexmenu</xsl:attribute>
						  <!-- <xsl:attribute name="id"><xsl:value-of select="$menuConst"/>0_ekflexmenu</xsl:attribute> -->
						  <xsl:attribute name="id">subNav</xsl:attribute>
						<!-- <xsl:attribute name="id">flexSubNav</xsl:attribute> --> 
						<xsl:if test="/MenuDataResult/Info/EnableMouseOverPopUp='true'"> 
							<xsl:attribute name="onmouseover">return (ekFlexMenuPopupMsIn(event));</xsl:attribute>
							<xsl:attribute name="onmouseout">return (ekFlexMenuPopupMsOut(event));</xsl:attribute>
						</xsl:if>
						<div>
							<xsl:attribute name="class">ekflexmenu_menu_level_0<xsl:text xml:space="preserve"> </xsl:text>ekflexmenu_submenu</xsl:attribute>
							<ul>
								<li>
									<ul>
										<xsl:attribute name="class">ekflexmenu_submenu_items</xsl:attribute>
										<xsl:attribute name="id"><xsl:value-of select="$menuConst"/>0_submenu_items</xsl:attribute>
										<xsl:apply-templates select="Item"/>
									</ul>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<xsl:call-template name="addJavascript"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="Item"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="Item[child::Menu | ItemType='Submenu']">
		<li>
			<xsl:attribute name="class">ekflexmenu_menu_level_<xsl:value-of select="ItemLevel"/><xsl:text xml:space="preserve"> </xsl:text>ekflexmenu_submenu<xsl:if test="(number(ItemLevel) = number($startLevel))"><xsl:text xml:space="preserve"> </xsl:text>ekflexmenu_startlevel</xsl:if></xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="./Menu/MenuIdString"/></xsl:attribute>
			<xsl:apply-templates select="Menu"/>
		</li>
	</xsl:template>

	<xsl:template name="makelist" match="Menu">
		<xsl:call-template name="makeButton" />
		<xsl:if test="./Item/Menu[MenuId!=''] | ./Item[ItemId!=''][ItemType!='Submenu'] ">
			<ul>
				<xsl:attribute name="id"><xsl:value-of select="MenuIdString"/>_submenu_items</xsl:attribute>
				<xsl:choose>
					<xsl:when test="MenuSelected='true' and /MenuDataResult/Info/EnableSmartOpen='true'">
						<xsl:attribute name="class">ekflexmenu_submenu_items</xsl:attribute>
					</xsl:when>
					<xsl:when test="ChildMenuSelected='true' and /MenuDataResult/Info/EnableSmartOpen='true'">
						<xsl:attribute name="class">ekflexmenu_submenu_items</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="/MenuDataResult/Info/StartCollapsed='true'">
								<xsl:attribute name="class">ekflexmenu_submenu_items_hidden</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">ekflexmenu_submenu_items</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="Item"/>
			</ul>
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
				<xsl:choose>
					<xsl:when test="ItemSelected='true'">
						<xsl:attribute name="class">ekflexmenu_link_selected</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
				<xsl:attribute name="class">ekflexmenu_link</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="ItemType='Javascript'">
						<xsl:attribute name="onclick">
							Javascript:<xsl:value-of select="ItemLink"/>;return false;
						</xsl:attribute>
						<xsl:attribute name="href">#NoScroll</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="not(ItemLink='')">
								<xsl:attribute name="href">
									<xsl:value-of select="ItemLink"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="href">#NoScroll</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:attribute name="target">
					<xsl:value-of select="$targetLoc"/>
				</xsl:attribute>
				<xsl:if test="not(ItemImage='')">
					<img>
						<xsl:attribute name="border">0</xsl:attribute>
						<xsl:attribute name="src">
							<xsl:value-of select="ItemImage"/>
						</xsl:attribute>
					</img>
				</xsl:if>
				<xsl:if test="not(ItemImageOverride='true')">
					<xsl:text> </xsl:text>
					<xsl:value-of select="ItemTitle"/>
				</xsl:if>
			</a>
			<xsl:apply-templates select="Item|Menu"/>
		</li>
	</xsl:template>

	<xsl:template name="makeButton">
		<xsl:if test="not((/MenuDataResult/Info/MenuFragment='true') and (MenuLevel = '1') and $slaveMenu='true')">				  
			   		  		
			   <a>
				<xsl:attribute name="id"><xsl:value-of select="MenuIdString"/>_button</xsl:attribute>
				<xsl:attribute name="onkeydown">return (ekFlexMenuKey(event));</xsl:attribute>
				<xsl:attribute name="onblur">return (ekFlexMenuMsOut(event));</xsl:attribute>
				<xsl:attribute name="onfocus">return (ekFlexMenuMsOvr(event));</xsl:attribute>
				<xsl:attribute name="onclick">return (ekFlexMenuClk(event));</xsl:attribute>
				<xsl:attribute name="onmouseover">return (ekFlexMenuMsOvr(event));</xsl:attribute>
				<xsl:attribute name="onmouseout">return (ekFlexMenuMsOut(event));</xsl:attribute>
				<xsl:choose>
					<xsl:when test="MenuSelected='true'">
						<xsl:attribute name="class">ekflexmenu_button_selected</xsl:attribute>
					</xsl:when>
					<xsl:when test="ChildMenuSelected='true'">
						<xsl:attribute name="class">ekflexmenu_button_selected</xsl:attribute>
					</xsl:when>
					<xsl:otherwise> 						
						<xsl:attribute name="class">ekflexmenu_button</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
					<xsl:choose>
					<xsl:when test="Link=''">
						<xsl:attribute name="href"><xsl:value-of select="$buttonNoScriptLink"/><xsl:value-of select="MenuIdString"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="href">
							<xsl:value-of select="Link"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="not(Image='')">
					<img>
						<xsl:attribute name="border">0</xsl:attribute>
						<xsl:attribute name="src">
							<xsl:value-of select="Image"/>
						</xsl:attribute>
					</img>
				</xsl:if>
				<xsl:if test="not(ImageOverride='true')">
					<xsl:value-of select="Title"/>
				</xsl:if>
			</a>			
		</xsl:if>
		<input type="hidden">
			<xsl:attribute name="id"><xsl:value-of select="MenuIdString"/>_parentid</xsl:attribute>
			   <xsl:choose>
				<xsl:when test="$slaveMenu='true' and (MenuLevel = '1')"> 
					<xsl:attribute name="value"><xsl:value-of select="$masterHash"/>_<xsl:value-of select="/MenuDataResult/Info/ControlMenuId"/>_<xsl:value-of select="ParentId"/></xsl:attribute>
				 </xsl:when> 
				<xsl:otherwise>
					<xsl:attribute name="value"><xsl:value-of select="$menuConst"/><xsl:value-of select="ParentId"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose> 
		</input>
	</xsl:template>

	<xsl:template name="addJavascript">
		<script language="JavaScript" type="text/javascript">
			// Pass server control properties, etc., to Javascript:
			if (("undefined" == typeof window.ekFlexMenu_ekflexmenuArray)
				|| (null == window.ekFlexMenu_ekflexmenuArray)) {
				window.ekFlexMenu_ekflexmenuArray = new Array;
			}
			window.ekFlexMenu_ekflexmenuArray[window.ekFlexMenu_ekflexmenuArray.length] = "<xsl:value-of select="$menuConst"/>0";
			//
			if (("undefined" == typeof window.ekFlexMenu_swRev)
			|| (null == window.ekFlexMenu_swRev)) {
			window.ekFlexMenu_swRev = new Array;
			}
			window.ekFlexMenu_swRev["<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>"] = "<xsl:value-of select="/MenuDataResult/Info/SWRevision"/>";
			//
			if (("undefined" == typeof window.ekFlexMenu_startupSubmenuBranchId)
			|| (null == window.ekFlexMenu_startupSubmenuBranchId)) {
			window.ekFlexMenu_startupSubmenuBranchId = new Array;
			}
			window.ekFlexMenu_startupSubmenuBranchId["<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>"] = "";
			//
			if (("undefined" == typeof window.ekFlexMenu_autoCollapseBranches)
			|| (null == window.ekFlexMenu_autoCollapseBranches)) {
			window.ekFlexMenu_autoCollapseBranches = new Array;
			}
			window.ekFlexMenu_autoCollapseBranches["<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>"] = "<xsl:value-of select="/MenuDataResult/Info/AutoCollapseBranches"/>";
			//
			if (("undefined" == typeof window.ekFlexMenu_startCollapsed)
			|| (null == window.ekFlexMenu_startCollapsed)) {
			window.ekFlexMenu_startCollapsed = new Array;
			}
			window.ekFlexMenu_startCollapsed["<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>"] = "<xsl:value-of select="/MenuDataResult/Info/StartCollapsed"/>";
			//
			if (("undefined" == typeof window.ekFlexMenu_startWithRootFolderCollapsed)
			|| (null == window.ekFlexMenu_startWithRootFolderCollapsed)) {
			window.ekFlexMenu_startWithRootFolderCollapsed = new Array;
			}
			window.ekFlexMenu_startWithRootFolderCollapsed["<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>"] = "false";
			//
			if (("undefined" == typeof window.ekFlexMenu_masterControlIdHash)
				|| (null == window.ekFlexMenu_masterControlIdHash)) {
				window.ekFlexMenu_masterControlIdHash = new Array;
			}
			window.ekFlexMenu_masterControlIdHash["<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>"] = "<xsl:value-of select="/MenuDataResult/Info/MasterControlIdHash"/>";
			<xsl:if test="not($masterHash = '')">
				//
				if (("undefined" == typeof window.ekFlexMenu_subscriberList)
				|| (null == window.ekFlexMenu_subscriberList)) {
				window.ekFlexMenu_subscriberList = new Array;
				}
				if ("undefined" == typeof window.ekFlexMenu_subscriberList["<xsl:value-of select="/MenuDataResult/Info/MasterControlIdHash"/>"]) {
				window.ekFlexMenu_subscriberList["<xsl:value-of select="/MenuDataResult/Info/MasterControlIdHash"/>"] = "<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>";
				}
				else {
				window.ekFlexMenu_subscriberList["<xsl:value-of select="/MenuDataResult/Info/MasterControlIdHash"/>"] += ",<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>";
				}
			</xsl:if>
			//
			if (("undefined" == typeof window.ekFlexMenu_ajaxEnabled)
			|| (null == window.ekFlexMenu_ajaxEnabled)) {
			window.ekFlexMenu_ajaxEnabled = new Array;
			}
			window.ekFlexMenu_ajaxEnabled["<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>"] = "<xsl:value-of select="/MenuDataResult/Info/AjaxEnabled"/>";
			//
			if (("undefined" == typeof window.ekFlexMenu_ajaxWSPath)
			|| (null == window.ekFlexMenu_ajaxWSPath)) {
			window.ekFlexMenu_ajaxWSPath = new Array;
			}
			window.ekFlexMenu_ajaxWSPath["<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>"] = "<xsl:value-of select="/MenuDataResult/Info/AppPath"/>webservices/";
			// 
			if (("undefined" == typeof window.ekFlexMenu_displayXslt)
			|| (null == window.ekFlexMenu_displayXslt)) {
			window.ekFlexMenu_displayXslt = new Array;
			}
			window.ekFlexMenu_displayXslt["<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>"] = "<xsl:value-of select="/MenuDataResult/Info/XslFileName"/>";
			//
			if (("undefined" == typeof window.ekFlexMenu_cacheInterval)
			|| (null == window.ekFlexMenu_cacheInterval)) {
			window.ekFlexMenu_cacheInterval = new Array;
			}
			window.ekFlexMenu_cacheInterval["<xsl:value-of select="/MenuDataResult/Info/ControlIdHash"/>"] = "<xsl:value-of select="/MenuDataResult/Info/CacheInterval"/>";
			//
			//////////////////////////////////////////////////////////////////
			// Add event handler calling functions:
			//   Test to ensure that ekFlexMenu is valid/reachable (this is needed 
			//   to prevent intermittent Javascript errors that can occur if user
			//   causes event to fire while page is being torn down (i.e. a link is
			//   clicked, browser is fetching new page, movement causes mouse-out...):
			function ekFlexMenu_IsValid(obj) {
				return (("undefined" != typeof obj) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> (null != obj));
			}
			function ekFlexMenuPopupMsIn(event) {
				if (ekFlexMenu_IsValid(ekFlexMenu) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> ekFlexMenu_IsValid(ekFlexMenu.mouseIn)) {
					return (ekFlexMenu.mouseIn(event));
				}
				return (true);
			}
			function ekFlexMenuPopupMsOut(event) {
				if (ekFlexMenu_IsValid(ekFlexMenu) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> ekFlexMenu_IsValid(ekFlexMenu.mouseOut)) {
					return (ekFlexMenu.mouseOut(event));
				}
				return (true);
			}
			function ekFlexMenuKey(event) {
				if (ekFlexMenu_IsValid(ekFlexMenu) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> ekFlexMenu_IsValid(ekFlexMenu.menuBtnKeyHdlr)) {
					return (ekFlexMenu.menuBtnKeyHdlr(event));
				}
				return (true);
			}
			function ekFlexMenuMsOut(event) {
				if (ekFlexMenu_IsValid(ekFlexMenu) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> ekFlexMenu_IsValid(ekFlexMenu.menuBtnMouseOutHdlr)) {
					return (ekFlexMenu.menuBtnMouseOutHdlr(event));
				}
				return (true);
			}
			function ekFlexMenuMsOvr(event) {
				if (ekFlexMenu_IsValid(ekFlexMenu) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> ekFlexMenu_IsValid(ekFlexMenu.menuBtnMouseOverHdlr)) {
					return (ekFlexMenu.menuBtnMouseOverHdlr(event));
				}
				return (true);
			}
			function ekFlexMenuClk(event) {
				if (ekFlexMenu_IsValid(ekFlexMenu) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> ekFlexMenu_IsValid(ekFlexMenu.menuBtnClickHdlr)) {
					return (ekFlexMenu.menuBtnClickHdlr(event));
				}
				return (true);
			}
		</script>
		<xsl:if test="/MenuDataResult/Info/UseJavascriptHardLink='true'">
			<script language="javascript" type="text/javascript">
				<xsl:attribute name="src"><xsl:value-of select="/MenuDataResult/Info/AppPath"/>java/ek_flexmenu.js</xsl:attribute>
			</script>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>