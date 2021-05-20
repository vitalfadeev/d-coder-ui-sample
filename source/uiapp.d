module uiapp;

import ui;


version ( OPENGL )
{
    import bindbc.glfw;
}


/** */
struct App
{
    version ( OPENGL )
    {
        AppGL _app;
        alias _app this;
    }
    else
    {
        AppGDI _app;
        alias  _app this;
    }
}


version ( OPENGL )
{
/** */
struct AppGL
{
    GLFWwindow* window;
    WindowData  data;

    /** */ 
    void init_()
    {
        import bindbc.glfw;

        GLFWSupport ret = loadGLFW( "libs/glfw3.dll" );
        if ( ret != glfwSupport ) 
        {

            if ( ret == GLFWSupport.noLibrary ) 
            {
                // GLFW shared library failed to load
                assert( 0, "error: GLFW shared library failed to load" );
            }
            else 

            if ( GLFWSupport.badLibrary ) 
            {
                // One or more symbols failed to load. The likely cause is that the
                // shared library is for a lower version than bindbc-glfw was configured
                // to load (via GLFW_31, GLFW_32 etc.)
                assert( 0, "error: One or more symbols failed to load" );
            }
        }
    }

    /** */ 
    void UI()
    {
        import bindbc.glfw;
        import generated : initUI;

        auto document = new Document;

        initUI( document );

        // Init GL
        if ( !glfwInit() )
        {
            assert( 0, "error: Initialization failed" );
        }

        // Create Window
        window = glfwCreateWindow( 640, 480, "My Title", null, null );
        if ( !window )
        {
            glfwTerminate();
            assert( 0, "error: Window or OpenGL context creation failed" );
        }

        glfwMakeContextCurrent( window );

        glfwSetWindowUserPointer( window, &data );

        glfwSwapInterval(1); // Set vsync on so glfwSwapBuffers will wait for monitor updates.
        // note: 1 is not a boolean! Set e.g. to 2 to run at half the monitor refresh rate.
    }

    /** */ 
    extern(C) static nothrow
    void keyCallback( GLFWwindow* window, int key, int scancode, int action, int mods ) 
    {
        if ( key == GLFW_KEY_ESCAPE && action == GLFW_PRESS )
            glfwSetWindowShouldClose( window, GLFW_TRUE );
    }

    /** */
    void eventLoop()
    {
        // Event loop
        glfwSetKeyCallback( window, &keyCallback );

        double oldTime = glfwGetTime();

        // eventloop
        while ( !glfwWindowShouldClose( window ) )
        {
            const newTime = glfwGetTime();
            const elapsedTime = newTime - oldTime;
            oldTime = newTime;

            vid( window );

            glfwSwapBuffers( window );
            glfwPollEvents();
        }

        // exit
        //glfwDestroyWindow( window );
        glfwTerminate();
    }

    void vid( GLFWwindow* window )
    {
        WindowData* windowData = cast( WindowData* ) glfwGetWindowUserPointer( window );

        if ( windowData !is null )
        if ( windowData.document !is null )
        {
            //document.body.update();
            windowData.document.body.vid( this );
            //document.body.dump();
        }
    }

    /// Data stored in the window's user pointer
    ///
    /// Note: assuming you only have one window, you could make these global variables.
    struct WindowData 
    {
        // These are stored in the window's user data so that when exiting fullscreen,
        // the window can be set to the position where it was before entering fullscreen
        // instead of resetting to e.g. (0, 0)
        int xpos;
        int ypos;
        int width;
        int height;
        Document* document;

        @nogc nothrow 
        void update( GLFWwindow* window ) 
        {
            glfwGetWindowPos( window, &this.xpos, &this.ypos );
            glfwGetWindowSize( window, &this.width, &this.height );
        }
    }
}

class GLDrawer : IDrawer
{
    //
}
} // version ( OPENGL )


/** */
import ui.oswindow : OSWindow;
struct AppGDI
{
    OSWindow window;
    bool     doLoop = true;

    /** */ 
    void init_()
    {
        //
    }


    /** */ 
    void UI()
    {
        import generated   : initUI;

        auto document = new Document;

        initUI( document );

        window = new OSWindow( document );
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
}
