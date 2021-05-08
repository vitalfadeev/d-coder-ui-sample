module ui.parse.t.on;

import ui.parse.t.tokenize   : Tok;
import ui.parse.t.parser     : EventCallback;
import ui.parse.t.charreader : CharReader;


bool parse_on( R )( R range, Tok[] tokenized, size_t parentIndent, EventCallback[] evemtCallbacks )
{
    auto args = tokenized[ 2 .. $ ]; // skip ["event", ":"]

    // event: args...
    if ( !args.empty )
    {
        auto eventName = args.front.s; // = WM_KEYDOWN

        auto eventBody = read_event_body( range, parentIndent );

        evemtCallbacks ~= EventCallback( eventName, args, eventBody );
    }
}

/*
    void process_KeyboardKeyEvent( Element* element, KeyboardKeyEvent event )
    {
        if ( event.code == VK_SPACE )
        {
            element.addClass( "selected" );
        }
    }
*/

string[] read_event_body( R )( R range, size_t parentIndent )
{
    import ui.parse.t.style    : tokenize;
    import ui.parse.parser     : quote;
    import ui.parse.t.tokenize : readIndent;

    string[] eventBody;
    Tok[]    tokenized;

    if ( !range.empty )
    for ( string line; !range.empty; range.popFront() )
    {
        line = range.front;

        readIndent( new CharReader( line ), &indentLength );

        if ( indentLength >= parentIndent )
        {
            eventBody ~= line;
        }
        else

        {
            break;
        }
    }

    return eventBody;
}
