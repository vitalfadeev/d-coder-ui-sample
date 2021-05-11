import std.stdio;
import ui;
import ui.oswindow : OSWindow;


bool doLoop = true;


void main()
{
    UI();
    eventLoop();
}


void UI()
{
    import generated : initUI;

    auto document = new Document;

    initUI( document );

    auto window = new OSWindow( document );
}


/** */
void eventLoop()
{
    import core.sys.windows.windows;

    MSG msg;

   while ( doLoop && GetMessage( &msg, NULL, 0, 0 ) )
   {
       //TranslateMessage( &msg );
       DispatchMessage( &msg );
   }
}
