import std.stdio;
import ui;
import ui.app : App;


void main()
{
    auto app = 
        App!()()
            .init_()
            .UI()
            .eventLoop()
            .exit_();
}

