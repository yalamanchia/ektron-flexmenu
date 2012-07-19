/***** FREEWARE *****

Copyright 2010 Ektron. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are
permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list
      of conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY EKTRON ``AS IS'' AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL EKTRON OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
                                                                                 
The views and conclusions contained in the software and documentation are those of the
authors and should not be interpreted as representing official policies, either expressed
or implied, of Ektron.
******************************************************************************************/


using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ektron.Cms.Widget;
using System.ComponentModel;
using System.Reflection;
using Ektron.Cms;
using System.Data;

public partial class widgets_FlexMenu : System.Web.UI.UserControl
{
    private IWidgetHost _host;

    private long _menuID;
    private bool _verticalField;
    private int _cacheInterval;
    private string _displayXslt;
    private int _Language;
    private string _Stylesheet;
    private bool _enableAjax;
    private bool _enablesmartOpen;
    private bool _enablemouseoverPopup;
    private bool _startCollapsed;
    private int _startLevel;
    private int _menuDepth;    


    [WidgetDataMember(0)]
    public long menuID { get { return _menuID; } set { _menuID = value; } }
    [WidgetDataMember(true)]
    public bool verticalField { get { return _verticalField; } set { _verticalField = value; } }
    [WidgetDataMember(300)]
    public int cacheInterval { get { return _cacheInterval; } set { _cacheInterval = value; } }
    [WidgetDataMember("")]
    public string displayXslt { get { return _displayXslt; } set { _displayXslt = value; } }
    [WidgetDataMember(1033)]
    public int Language { get { return _Language; } set { _Language = value; } }
    [WidgetDataMember("")]
    public string Stylesheet { get { return _Stylesheet; } set { _Stylesheet = value; } }
    [WidgetDataMember(false)]
    public bool enableAjax { get { return _enableAjax; } set { _enableAjax = value; } }
    [WidgetDataMember(false)]
    public bool enablesmartOpen { get { return _enablesmartOpen; } set { _enablesmartOpen = value; } }
    [WidgetDataMember(false)]
    public bool enablemouseoverPopup { get { return _enablemouseoverPopup; } set { _enablemouseoverPopup = value; } }
    [WidgetDataMember(1)]
    public int startLevel { get { return _startLevel; } set { _startLevel = value; } }
    [WidgetDataMember(true)]
    public bool startCollapsed { get { return _startCollapsed; } set { _startCollapsed = value; } }
    [WidgetDataMember(0)]
    public int menuDepth { get { return _menuDepth; } set { _menuDepth = value; } }    

    protected void Page_Init(object sender, EventArgs e)
    {
        string sitepath = new CommonApi().SitePath;
        _host = WidgetHost.GetHost(this);
        _host.Title = "FlexMenu";
        _host.HelpFile = sitepath + "Widgets/FlexMenu/FlexMenuHelp.htm";
        _host.Edit += new EditDelegate(_host_Edit);
        PreRender += new EventHandler(delegate(object PreRenderSender, EventArgs Evt) { SetOutput(); });

        ViewSet.SetActiveView(View);
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
    }

    protected void SetOutput()
    {
        if (_menuID != 0)
        {
            fm.EnableSmartOpen = enablesmartOpen;
            fm.EnableAjax = enableAjax;
            if (enablesmartOpen)
            {
                fm.EnableAjax = false;
            }
            fm.CacheInterval = cacheInterval;
            fm.SuppressAddEdit = true;
            fm.EnableMouseOverPopUp = enablemouseoverPopup;
            fm.Language = Language;
            fm.StartLevel = startLevel;
            fm.StartCollapsed = startCollapsed;
            fm.MenuDepth = menuDepth;
            fm.Page = this.Page;
            fm.DefaultMenuID = menuID;

            if ((displayXslt != "") && (Stylesheet != ""))
            {
                fm.Stylesheet = Stylesheet;
                fm.DisplayXslt = displayXslt;
            }
            else if (verticalField == true)
            {
                fm.Stylesheet = "~/Widgets/FlexMenu/vertical.css";
                fm.DisplayXslt = "~/Widgets/FlexMenu/vertical.xsl";
            }
            else
            {
                fm.Stylesheet = "~/Widgets/FlexMenu/horizontal.css";
                fm.DisplayXslt = "~/Widgets/FlexMenu/horizontal.xsl";
            }

            fm.Fill();
        }
        else
        {
            fm.Visible = false;
        }
    }

    void _host_Edit(string settings)
    {
        menulist.Items.Clear();
        //get list of menu's
        Ektron.Cms.CommonApi m_refApi = new Ektron.Cms.CommonApi();
        PageRequestData req = new PageRequestData();
        req.PageSize = 500;       
        Microsoft.VisualBasic.Collection menu_list = m_refApi.EkContentRef.GetMenuReport("", ref req);
        ListItem li = new ListItem();        
        for (int i = 0; i <= menu_list.Count; i++)
        {
            if (i != 0)
            {
                Microsoft.VisualBasic.Collection menuData = (Microsoft.VisualBasic.Collection)menu_list[i];
                li = new ListItem();
                try
                {
                    li.Text = menuData[3].ToString();
                    li.Value = menuData[1].ToString();
                    menulist.Items.Add(li);
                }
                catch
                {
                }
            }
        }
        if (_menuID != 0)
        {
            menulist.SelectedValue = _menuID.ToString();
        }
        vert.Checked = _verticalField;
        cacheinterval.Text = _cacheInterval.ToString();
        displayxslt.Text = _displayXslt;
        language.Text = _Language.ToString();
        stylesheet.Text = _Stylesheet;
        enableajax.Checked = _enableAjax;
        enablesmartopen.Checked = _enablesmartOpen;
        enablemouseoverpopup.Checked = _enablemouseoverPopup;
        startlevel.Text = _startLevel.ToString();
        startcollapsed.Checked = _startCollapsed;
        menudepth.Text = _menuDepth.ToString();

        ViewSet.SetActiveView(Edit);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        long.TryParse(menulist.SelectedValue, out _menuID);
        _verticalField = vert.Checked;
        int.TryParse(cacheinterval.Text, out _cacheInterval);
        _displayXslt = displayxslt.Text;
        int.TryParse(language.Text, out _Language);
        _Stylesheet = stylesheet.Text;
        _enableAjax = enableajax.Checked;
        _enablesmartOpen = enablesmartopen.Checked;
        _enablemouseoverPopup = enablemouseoverpopup.Checked;
        int.TryParse(startlevel.Text, out _startLevel);
        _startCollapsed = startcollapsed.Checked;
        int.TryParse(menudepth.Text, out _menuDepth);

        _host.SaveWidgetDataMembers();

        ViewSet.SetActiveView(View);
    }
}
