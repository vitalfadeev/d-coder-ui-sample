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
            borderWidth = (1.000000).px;
            borderStyle = LineStyle.solid;
            width = (100.000000).px;
        }
    }
    
    static
    void on( Element* element, Event* event )
    {
        switch ( event.type )
        {
            case WM_KEYDOWN: on_WM_KEYDOWN( element, event ); break;
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
              addClass( "selected" );
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
            borderWidth = (3.000000).px;
            borderStyle = LineStyle.solid;
            borderColor = Color( 0x0, 0xC0, 0x0 );
        }
    }
    
}

