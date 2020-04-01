import XMonad

main :: IO ()
main 
  = xmonad def
  { terminal = "kitty"
  , modMask = mod4Mask
  , borderWidth = 3
  }
