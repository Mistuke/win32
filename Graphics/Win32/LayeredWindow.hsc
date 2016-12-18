{-# LANGUAGE CPP #-}
{- |
   Module      :  Graphics.Win32.LayeredWindow
   Copyright   :  2012-2013 shelarcy
   License     :  BSD-style

   Maintainer  :  shelarcy@gmail.com
   Stability   :  Provisional
   Portability :  Non-portable (Win32 API)

   Provides LayeredWindow functionality.
-}
module Graphics.Win32.LayeredWindow where
import Control.Monad    ( void )
import Data.Bits        ( (.|.) )
import Foreign.Ptr      ( Ptr )
import Graphics.Win32.GDI.AlphaBlend ( BLENDFUNCTION )
import Graphics.Win32.GDI.Types ( COLORREF )
import System.Win32.Types ( DWORD, HANDLE, BYTE, BOOL,
                            LONG_PTR, INT, HDC )

#include <windows.h>
##include "windows_cconv.h"

type WindowStyleEx = INT

toLayeredWindow :: HANDLE -> IO ()
toLayeredWindow w = do
  flg <- c_GetWindowLongPtr w gWL_EXSTYLE
  void $ c_SetWindowLongPtr w gWL_EXSTYLE (flg .|. (fromIntegral wS_EX_LAYERED))

-- test w =  c_SetLayeredWindowAttributes w 0 128 lWA_ALPHA

gWL_EXSTYLE :: INT
gWL_EXSTYLE = #const GWL_EXSTYLE

wS_EX_LAYERED :: WindowStyleEx
wS_EX_LAYERED = #const WS_EX_LAYERED

lWA_COLORKEY, lWA_ALPHA :: DWORD
lWA_COLORKEY = #const LWA_COLORKEY
lWA_ALPHA    = #const LWA_ALPHA

foreign import WINDOWS_CCONV unsafe "windows.h SetLayeredWindowAttributes"
  c_SetLayeredWindowAttributes :: HANDLE -> COLORREF -> BYTE -> DWORD -> IO BOOL

foreign import WINDOWS_CCONV unsafe "windows.h GetLayeredWindowAttributes"
  c_GetLayeredWindowAttributes :: HANDLE -> COLORREF -> Ptr BYTE -> Ptr DWORD -> IO BOOL

foreign import WINDOWS_CCONV unsafe "windows.h UpdateLayeredWindow"
  c_UpdateLayeredWindow :: HANDLE -> HDC -> Ptr POINT -> Ptr SIZE ->  HDC -> Ptr POINT -> COLORREF -> Ptr BLENDFUNCTION -> DWORD -> IO BOOL

-- | We should use this instead of "Graphics.Win32.Window" module's one.
-- "Graphics.Win32.Window" module's function type is wrong.
foreign import WINDOWS_CCONV "windows.h SetWindowLongPtrW"
  c_SetWindowLongPtr :: HANDLE -> INT -> LONG_PTR -> IO LONG_PTR

foreign import WINDOWS_CCONV "windows.h GetWindowLongPtrW"
  c_GetWindowLongPtr :: HANDLE -> INT -> IO LONG_PTR

#{enum DWORD,
 , uLW_ALPHA    = ULW_ALPHA
 , uLW_COLORKEY = ULW_COLORKEY
 , uLW_OPAQUE   = ULW_OPAQUE
 }
