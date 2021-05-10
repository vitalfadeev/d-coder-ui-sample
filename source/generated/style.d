module generated.style;


import ui;

struct stage
{
    string name = "stage";
    
    static
    void setter( Element* element )
    {
        with ( element.computed )
        {
            borderWidth = (3.000000).px;
            borderStyle = LineStyle.solid;
            borderColor = Color( 0x0, 0x0, 0x30 );
            width = (100.000000).px;
            height = (100.000000).px;
        }
    }
    
    static
    void on( Element* element, Event* event )
    {
        switch ( event.type )
        {
            case WM_KEYDOWN: on_WM_KEYDOWN( element, event ); break;
            case WM_LBUTTONDOWN: on_WM_LBUTTONDOWN( element, event ); break;
            default:
        }
    }
    
    static
    void on_WM_KEYDOWN( Element* element, Event* event )
    {
        if ( event.arg1 == VK_SPACE )
        with ( element )
        {
            {
              addClass!selected();
            }
            return;
        }
    }
    
    static
    void on_WM_LBUTTONDOWN( Element* element, Event* event )
    {
        with ( element )
        {
        {
          toggleClass!selected();
        }
            return;
        }
        
    }
    

}

struct dark
{
    string name = "dark";
    
    static
    void setter( Element* element )
    {
        with ( element.computed )
        {
            borderWidth = (2.000000).px;
            borderStyle = LineStyle.solid;
            borderColor = Color( 0x0, 0x0, 0x80 );
            width = (50.000000).px;
            height = (50.000000).px;
        }
    }
    
}

struct intro
{
    string name = "intro";
    
    static
    void setter( Element* element )
    {
        with ( element.computed )
        {
            borderWidth = (1.000000).px;
            borderStyle = LineStyle.solid;
            borderColor = Color( 0x0, 0x0, 0xC0 );
            width = (10.000000).px;
            height = (10.000000).px;
        }
    }
    
}

struct selected
{
    string name = "selected";
    
    static
    void setter( Element* element )
    {
        with ( element.computed )
        {
            borderWidth = (1.000000).px;
            borderStyle = LineStyle.solid;
            borderColor = Color( 0x0, 0xC0, 0x0 );
        }
    }
    
}

