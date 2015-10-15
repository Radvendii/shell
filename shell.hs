{-# LANGUAGE MonadComprehensions #-}
import Prelude
import System.Process
import GHC.IO.Handle
import Control.Concurrent
-- import System.IO.Memoize

python :: IO (Handle, Handle, Handle)
python = runInteractiveProcess "python" [] Nothing Nothing >>= (\(w,r,e,_) -> return (w,r,e))

-- python :: IO (Handle, Handle, Handle, ProcessHandle)
-- python = runInteractiveProcess "python" [] Nothing Nothing

main :: IO ()
main = python >>= (\(i,o,e) ->
                     getLine >>= hPutStr i >>
                     hGetLine o >>= putStrLn)
