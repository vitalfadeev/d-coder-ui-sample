module generated.tree;


import ui;
import generated.style;

void initUI( ref Document document )
{
  Element* element;
  Element* parentElement;
  
  // body 
  
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
