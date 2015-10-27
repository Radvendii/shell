{-# LANGUAGE MonadComprehensions #-}
import Prelude
import System.Process
import System.Console.Haskeline
import System.IO
import GHC.IO.Handle
import Control.Concurrent
import Control.Monad
import System.IO.Memoize

($>) :: a -> (a -> b) -> b
a $> f = f a
infixl 9 $>

python :: IO (IO (Handle, Handle, Handle))
python = once $ [(i,o,e) | (Just i, Just o, Just e, _) <- createProcess (shell "python"){std_in = CreatePipe, std_out = CreatePipe, std_err = CreatePipe}]

flush :: IO ()
flush = hFlush stdout

(>>=>>=) :: Monad m => m (m a) -> (a -> m b) -> m b
a >>=>>= f = a >>= (>>= f)

loop :: Monad m => m a -> m b
loop m = m >> loop m

main :: IO ()
main = python >>=>>= (\(i,o,e) ->
                         do
                           -- _ <- forkIO . forever $
                           --      hWaitForInput o (-1) >>
                           --      hGetChar o >>= putStr . (:[])
                           putStr "py> "
                           flush
                           getLine >>= hPutStr i
                           hFlush i
                           hGetLine o >>= putStrLn
                           flush
                           putStr "py> "
                           flush
                           threadDelay $ 10^7
                           -- getLine >>= hPutStr i
                           -- hFlush i
                           -- hGetLine o >>= putStrLn
                           -- flush
                     )
