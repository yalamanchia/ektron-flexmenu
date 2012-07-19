
function metadatatype(metaname) {

    var text = '';

    switch (metaname) {
        case 'language':
            text = 'Enter the default language for the item you are working with. Default value is 1033 for English';
            break;
        case 'cacheinterval':
            text = 'Sets the cache interval property of the control for a duration.';
            break;
        case 'displayxslt':
            text = 'Use a custom display xslt for custom layout and styling of the object.';
            break;
        case 'enableajax':
            text = 'Only downloads submenus as they are needed in the menu.';
            break;
        case 'enablesmartopen':
            text = 'If checked, this reads the folder and template associations of the menu and opens to the proper location of the menu automacically.';
            break;
        case 'enablemouseoverpopup':
            text = 'If checked, submenus appear as soon as the cursor moves over them. If uncheched, submenus only appear when the root node is clicked.';
            break;
        case 'startlevel':
            text = 'The starting level of the menu';
            break;
        case 'startcollapsed':
            text = 'Start with all nodes collapsed in the menu structure.';
            break;
        case 'stylesheet':
            text = 'Specify a stylesheet to use if the display xslt is set for the menu';
            break;
        case 'displayvertical':
            text = 'Display a vertical menu instead of horizontal using the builtin display xslt and stylesheet for the vertical menu. If unchecked, menu will display horizontally.';
            break;
        case 'menudepth':
            text = 'Sets how many levels to retrieve in the flex menu.';
            break;
        case 'purpose':
            text = 'The FlexMenu widget uses a flex menu control and fills the properties selected in edit mode. Available options are discribed in the menu above.';
            break;
        default: text = 'The FlexMenu widget uses a flex menu control and fills the properties selected in edit mode. Available options are discribed in the menu above.';
    }
    document.getElementById('description').innerHTML = '<p>' + text + '</p>';
}