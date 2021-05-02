module generated.tree;


import ui;
import generated.style;

void initUI( Document* document )
{
  Element* element;
  Element* parentElement;
  
  // body 
  document.body.addClass!stage;
  
    // e
    element = document.createElement( "e" );
    element.addClass!stage;
    element.addClass!dark;
    document.body.appendChild( element );
    
    
    // e
    element = document.createElement( "e" );
    element.addClass!stage;
    element.addClass!intro;
    document.body.appendChild( element );
    
    
}
