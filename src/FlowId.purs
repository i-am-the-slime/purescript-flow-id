module FlowId where

import Prelude

import Data.Newtype (class Newtype)
import Simple.JSON (class ReadForeign, class WriteForeign)

newtype FlowId = FlowId String
derive instance ntFlowId :: Newtype FlowId _
derive newtype instance eqFlowId :: Eq FlowId
derive newtype instance ordFlowId :: Ord FlowId
derive newtype instance readForeignFlowId :: ReadForeign FlowId
derive newtype instance writeForeignFlowId :: WriteForeign FlowId

