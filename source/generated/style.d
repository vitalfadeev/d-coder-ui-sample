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
            borderColor = Color( 0x0, 0x30, 0x0 );
            width = (100.000000).px;
            height = (100.000000).px;
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
            borderColor = Color( 0x0, 0x80, 0x0 );
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
            borderColor = Color( 0x0, 0xC0, 0x0 );
            width = (10.000000).px;
            height = (10.000000).px;
        }
    }
}

