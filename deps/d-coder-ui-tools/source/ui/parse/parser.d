module ui.parse.parser;

import std.stdio;
import ui.parse.t.parser : Doc;
import std.stdio : File;
import std.file  : exists;
import std.file  : mkdir;
import std.path  : buildPath;
import std.string : stripLeft;
import std.string : startsWith;

// create .def
// dub build
//   read .def
//     parse
//     write generated/class.d
//     write generated/package.d
//       import all generated/*


bool parse( string fileName )
{
    Doc doc;

    remove_pre_generated();

    parse_t( fileName, &doc );

    generate_style( &doc );
    generate_body( &doc );
    generate_package( &doc );

    return true;
}


void remove_pre_generated()
{
    import std.file  : rmdirRecurse;

    if ( exists( buildPath( "source", "generated" ) ) )
    {
        rmdirRecurse( buildPath( "source", "generated" ) );
    }
}

bool parse_t( string fileName, Doc* doc )
{
    import ui.parse.t.parser : TParser;
    
    auto tparser = new TParser;
    tparser.parseFile( fileName );

    *doc = tparser.doc;

    return true;
}


void generate_body( Doc* doc )
{
    import std.format : format;
    import std.conv : to;

    string s;

    s ~= "module generated.tree;\n";
    s ~= "\n";
    s ~= "\n";

    s ~= "import ui;\n";
    s ~= "import generated.style;\n";
    s ~= "\n";

    s ~= "void initUI( Document* document )\n";
    s ~= "{\n";
    s ~= "  Element* element;\n";
    s ~= "  Element* parentElement;\n";
    s ~= "  \n";

    s ~= "  // body \n";
    foreach ( className; doc.body.classes )
    s ~= format!"  document.body.addClass!%s;\n"(  className );
    s ~= "  \n";

    foreach ( element; doc.body.childs )
    {
        s ~= format!"    // %s\n"( element.tagName );
        s ~= format!"    element = document.createElement( %s );\n"( element.tagName.quote() );
        foreach ( className; element.classes )
        s ~= format!"    element.addClass!%s;\n"(  className );
        s ~=        "    document.body.appendChild( element );\n";
        s ~=        "    \n";

        if ( element.childs.length > 0 )
        s ~=        "    parentElement = element;\n";
        s ~=        "    \n";

        foreach ( e; element.childs )
        {
            s ~= format!"      // %s\n"( e.tagName );
            s ~= format!"      element = document.createElement( %s );\n"( e.tagName.quote() );
            foreach ( className; element.classes )
            s ~= format!"      element.addClass!%s;\n"(  className );
            s ~=        "      parentElement.appendChild( element );\n";
            s ~=        "      \n";
        }
    }

    s ~= "}\n";

    writeln( s );

    //
    createFolder( buildPath( "source", "generated" ) );

    // save file
    writeText( buildPath( "source", "generated", "tree.d" ), s );
}


string quote( string s )
{
    return '"' ~ s ~ '"';
}


void generate_style( Doc* doc )
{
    import std.format : format;
    import std.conv : to;

    string s;

    s ~= "module generated.style;\n";
    s ~= "\n";
    s ~= "\n";
    s ~= "import ui;\n";
    s ~= "\n";

    foreach ( cls; doc.style.classes )
    {
        s ~= format!"struct %s\n"( cls.className );
        s ~=        "{\n";
        s ~= format!"    string name = %s;\n"( cls.className.quote );
        s ~=        "    \n";
        s ~=        "    static\n";
        s ~= format!"    void setter( Element* element )\n";
        s ~=        "    {\n";
        s ~=        "        with ( element.computed )\n";
        s ~=        "        {\n";
        foreach ( setter; cls.setters )
        {
        s ~= format!"            %s\n"( setter );
        }
        s ~=        "        }\n";
        s ~=        "    }\n";
        s ~=        "    \n";
        if ( cls.EventCallbacks.length > 0 )
        s ~= format!"    %s\n"( generate_on( doc, cls.EventCallbacks ) );
        s ~=        "}\n";
        s ~=        "\n";
    }


    writeln( s );

    //
    createFolder( buildPath( "source", "generated" ) );

    // save file
    writeText( buildPath( "source", "generated", "style.d" ), s );
}

void createFolder( string path )
{
    if ( !exists( path ) )
    {
        mkdir( path );
    }
}

void writeText( string path, string text )
{
    auto f = File( path, "w" );
    f.write( text );
    f.close();
}

void generate_package( Doc* doc )
{
    import std.format : format;
    import std.conv : to;

    string s;

    s ~= "module generated;\n";
    s ~= "\n";
    s ~= "public import generated.style;\n";
    s ~= "public import generated.tree;\n";
    s ~= "\n";

    writeln( s );

    //
    createFolder( buildPath( "source", "generated" ) );

    // save file
    writeText( buildPath( "source", "generated", "package.d" ), s );
}


string generate_on( Doc* doc, EventCallback*[] EventCallbacks )
{
    import ui.parse.t.tokenize : Tok;

    string s;
    Tok[] tokenized;

    auto range = eventBody;

    // grouped name arg1
    // on
    // on WM_KEYDOWN
    // on WM_KEYDOWN VK_SPACE

    alias NAME = string;
    alias ARG1 = string;

    EventCallback*[ ARG1 ][ NAME ] grouped;
    string[] names; // ordered
    string[][ name ] args;  // ordered

    foreach ( ecb; eventCallbacks )
    {
        auto byArg1 = ecb.name in grouped;

        if ( byArg1 !is null )
        {
            auto arg1 = ( ecb.args.length > 0 ) ? ecb.args.front : "";

            auto callbacks = arg1 in *byArg1;
            if ( callbacks !is null )
            {
                args[ name ][ arg1 ] = ecb;
            }
            else

            {
                args[ name ] = [ ecb ];
            }
        }
        else

        {
            names ~= ecb.name;
        }
    }


    auto grouped = group_event_callbacks( eventCallbacks );

    s ~=        "    void on( Element* element, Event* event )\n";
    s ~=        "    {\n";
    s ~=        "        switch ( event.type )\n";
    s ~=        "        {\n";
    foreach( ecb; grouped )
    s ~= format!"            case %s: on_%s( element, event ); break;\n"( ecb.name, ecb.name );
    s ~=        "            default:\n";
    s ~=        "        }\n";
    s ~=        "    }\n";

    foreach( ecb; grouped )
    {
    s ~= format!"    void on_%s( Element* element, Event* event )\n"( ecb.name );
    s ~=        "    {\n";
    s ~=        "        with ( element )\n";
    if ( ecb.nativeCode )
    s ~=                 nativeCode;
    else
    s ~= format!"        %s( %s );\n"( functionName, functionArg.quote );
    s ~=        "    }\n";
    }


    if ( !range.empty )
    for ( string line; !range.empty; range.popFront() )
    {
        line = range.front;

        // Native D-lang code block
        // {
        //     addClass( "selected" );
        // }
        if ( line.stripLeft().startsWith( "{" ) )
        {
            string nativeCode;

            read_code_block( range, nativeCode );

            s ~=        "with ( element )\n";
            s ~=        nativeCode;
        }
        else

        // call function
        // addClass selected
        {
            auto functionName = tokenized.front.s;          // = addClass
            auto functionArg  = tokenized.drop(1).front.s;  // = selected

            s ~= format!"%s( %s );\n"( functionName, functionArg.quote );
        }
    }

    return s;
}


bool read_code_block( R )( R range, ref string nativeCode )
{
    import ui.parse.t.tokenize : readIndent;
    import ui.parse.t.charreader : CharReader;

    size_t startIndentLength;
    size_t indentLength;

    readIndent( new CharReader( range.front ), &startIndentLength );

    if ( !range.empty )
    for ( string line; !range.empty; range.popFront() )
    {
        line = range.front;

        auto charReader = new CharReader( line );
        readIndent( charReader, &indentLength );

        // add line
        nativeCode ~= format!"        %s\n"( line );

        if ( indentLength == startIndentLength )
        if ( charReader.front == "}" )
        {
            return true; // OK
        }
    }

    return false;
}

EventCallback*[] group_event_callbacks( EventCallback*[] eventCallbacks )
{
    // on
    //   WM_KEYDOWN 
    //     VK_SPACE
    //     VK_ESCAPE
    //   WM_KEYUP
    //     VK_SPACE
    //     VK_ESCAPE

    EventCallback*[] grouped;
    grouped.reserve( eventCallbacks.length );

    bool hasGroup1( EventCallback* cb )
    {
        foreach ( g; grouped )
        {
            if ( g.name == cb.name )
            {
                return true;
            }
        }

        return false;
    }

    bool hasGroup2( EventCallback* cb )
    {
        foreach ( g; grouped )
        {
            if ( g.args.front == cb.args.front )
            {
                return true;
            }
        }

        return false;
    }

    void insertAfterGroup1( EventCallback* cb )
    {
        import std.algorithm.searching : countUntil;

        auto posStart = grouped.countUntil!( a => a.name == cb.name )();
        auto posEnd   = grouped[ posStart .. $ ].countUntil!( a => a.name != cb.name )();

        // move
        grouped[ posEnd + 1 .. $ ] = grouped[ posEnd .. $-1 ];
        // set
        grouped[ posEnd ] = cb;
    }

    void insertAfterGroup1and2( EventCallback* cb )
    {
        import std.algorithm.searching : countUntil;

        auto posStart = grouped.countUntil!( a => a.name == cb.name && a.args.front == cb.args.front )();
        auto posEnd   = grouped[ posStart .. $ ].countUntil!( a => a.name != cb.name && a.args.front == cb.args.front )();

        // move
        grouped[ posEnd + 1 .. $ ] = grouped[ posEnd .. $-1 ];
        // set
        grouped[ posEnd ] = cb;
    }

    //
    foreach ( cb; eventCallbacks )
    {
        if ( hasGroup1( cb ) )
        {
            //
        }
    }

    return grouped;
}


//
struct OrderedAssocArray( T )
{
    string[] orderedKeys;
    T[ string ] array;

    void opOpAssign( string op : "~" )( T b )
    {
        auto key = keyFunc( b );
        auto x = key in array;
        if ( x !is null )
        {
            array[ key ] = b;
        }
        else

        {
            orderedKeys ~= key;
            array[ key ] = b;
        }
    }

    auto keyFunc( T b )
    {
        return b.name;
    }

    void each()
    {
        foreach( key; orderedKeys )
        {
            // auto x = array[ key ];
        }
    }
}

//
struct GroupedOrderedAssocArray( T, alias keyFunc )
{
    string[] orderedKeys;
    T[][ string ] array;

    void opOpAssign( string op : "~" )( T b )
    {
        auto key = keyFunc( b );
        auto group = key in array;
        if ( group !is null )
        {
            *group ~= b;
        }
        else

        {
            orderedKeys ~= key;
            array[ key ] = [ b ];
        }
    }

    void each()
    {
        foreach ( key; orderedKeys )
        {
            auto group = array[ key ];

            foreach ( x; group )
            {
                // writeln( *x );
            }
        }
    }
}

alias GroupedOrderedAssocArray!( EventCallback*, b => b.name ) groupedEventCallbacks;
