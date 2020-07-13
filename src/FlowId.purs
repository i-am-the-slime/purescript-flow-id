module FlowId where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)
import Simple.JSON (class ReadForeign, class WriteForeign)

newtype FlowId = FlowId String
derive instance ntFlowId :: Newtype FlowId _
derive newtype instance eqFlowId :: Eq FlowId
derive newtype instance ordFlowId :: Ord FlowId
derive newtype instance readForeignFlowId :: ReadForeign FlowId
derive newtype instance writeForeignFlowId :: WriteForeign FlowId
derive instance genericFlowId ∷ Generic FlowId _
instance showFlowId ∷ Show FlowId where
  show = genericShow
