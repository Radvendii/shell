{-# LANGUAGE MonadComprehensions #-}
import Prelude
import System.Process
import System.IO
import GHC.IO.Handle
import Control.Concurrent
import Control.Monad
-- import System.IO.Memoize

python :: IO Handle
python = [i | (Just i,_,_,_) <- createProcess (proc "python" []){std_in = CreatePipe, std_out = UseHandle stdout, std_err = UseHandle stderr}]

flush :: IO ()
flush = hFlush stdout

main :: IO ()
main = python >>= (\i ->
                     do
                       putStr "py> "
                       flush
                       getLine >>= hPutStr i
                       hFlush i
                  )
