import std.stdio;
import ui;
import ui.oswindow : OSWindow;


bool doLoop = true;


void main()
{
    initUI();
    eventLoop();
}


void initUI()
{
    import generated;

    auto document = new Document;

    generated.initUI( document );

    auto window = new MyWindow( 640, 480 );

    window.document = document;
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


/** */
void exit()
{
    doLoop = false;
}


/** */
class MyWindow : OSWindow
{
    this( int cd, int gh )
    {
        super( cd, gh );
    }
}


