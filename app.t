head
  title: New window

style
  stage
    border: 3px solid #003
    width:  100px
    height: 100px

    on: WM_KEYDOWN VK_SPACE
      {
        addClass!selected();
      }

    on: WM_LBUTTONDOWN
      {
        toggleClass!selected();
      }

  dark
    border: 2px solid #008
    width:  50px
    height: 50px

  intro
    border: 1px solid #00C
    width:  10px
    height: 10px

  selected
    border: 1px solid #0C0

body stage
  e stage dark
  e stage intro

