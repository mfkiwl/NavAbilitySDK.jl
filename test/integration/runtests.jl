include("./testVariable.jl")
include("./testFactor.jl")
include("./testSolve.jl")

using Test
using Random
using .TestVariable
using .TestFactor
using .TestSolve

apiUrl = get(ENV,"API_URL","http://localhost:4343")
userId = get(ENV,"USER_ID","Guest")
robotId = get(ENV,"ROBOT_ID","IntegrationRobot")
sessionId = get(ENV,"SESSION_ID","TestSession"*randstring(7))

@testset "nva-sdk-integration-testset" begin
    @info "Running nva-sdk-integration-testset..."
    TestVariable.RunTests(apiUrl, userId, robotId, sessionId)
    TestFactor.RunTests(apiUrl, userId, robotId, sessionId)
    TestSolve.RunTests(apiUrl, userId, robotId, sessionId)
end
