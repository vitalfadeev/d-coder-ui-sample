import std.stdio;
import ui;
import uiapp : App;


void main()
{
    App app;
    app.init_();
    app.UI();
    addControl( app.window.document );
    app.eventLoop();
}

void addControl( Document* document )
{
    Element* element;
  
    element = document.createElement();
    document.body.appendChild( element );

    //
    element.instanceClass.setter = 
        ( Element* element )
        {
            with ( element.computed )
            {
                marginRight =   10;
                marginTop   =   10;
                width       =  100;
                height      =  200;
                magnetRight = -100;
                magnetTop   = -100;

                borderWidth = (3.000000).px;
                borderStyle = LineStyle.solid;
                borderColor = Color( 0x30, 0x00, 0x30 );
            }
        };
}

