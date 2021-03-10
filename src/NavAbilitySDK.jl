module NavAbility


# object name NVA



## create objects

mutable struct NVADFG <: AbstractDFG


end


# https://github.com/JuliaRobotics/DistributedFactorGraphs.jl/blob/master/src/services/AbstractDFG.jl#L211-L309

# this is high level API
nfg = NavAbilityDFG("api.navability.io")


function addVariable!(dfg::NVADFG, variable)
  # send this as Dict or JSON as "Packed" version of a `DFGVariable` type
  # purposefully have one or two fields missing for robustness, or built on receiver side.
  #   {
  #     "label": "x0",
  #     "dataEntry": "{}",
  #     "nstime": "0",
  #     "dataEntryType": "{}",
  #     "smallData": "{}",
  #     "variableType": "RoME.Pose2",
  #     "solvable": 1,
  #     "tags": "[\"VARIABLE\"]",
  #     "timestamp": "2021-03-09T20:09:46.034-05:00",
  #     "_version": "0.12.0"
  #   }
end



function addFactor!(nfg::NVADFG, factor)
  # send this as Dict or JSON as "Packed" version of DFGFactor
  # skipped field `data` to be built on receiver side
  #   {
  #     "label": "x0l1f1",
  #     "_version": "0.12.0",
  #     "_variableOrderSymbols": "[\"x0\",\"l1\"]",
  #     "tags": "[\"FACTOR\"]",
  #     "timestamp": "2021-03-09T20:09:58.996-05:00",
  #     "nstime": "0",
  #     "fnctype": "Pose2Point2BearingRange",
  #     "solvable": 1
  #   }
end


# JS version?
# client.addVariable(args) 
# dfg.addVariable(args)

# "more functional / dispatchy"
# addVariable(client, args)
# addVariable(dfg, args)
## SC +1, JH , DF +1,



# # can Python unpack DFGVariable?
# SC no, JH , DF no

# # only implement the packed object in other languages (i.e PackedPose2, PackedPose2Pose2)?
# SC yes, JH, DF yes

# # does addVariable! require knowing DFGVariable? 
# SC no (knowing a packed DFGVariable), JH, DF no

# # Does the SDK only provide the high level API usage?
# SC no if DFG is high level, JH, DF unclear

# # SDK usage should be the same across languages
# SC , Jim yes, DF probably yes,



end

#
