


function testExportSession(
    client = NVA.NavAbilityHttpsClient(;authorize=false),
    context = NVA.Client(
                "guest@navability.io",
                "TESTING",
                "EXPORTSESSION_"*(string(NVA.uuid4())[1:4])
              );
    buildNewGraph::Bool=false
  )
  #
  if buildNewGraph
    # build a graph
    resultId = NVA.addVariable(client, context, NVA.Variable("x0", :Pose2)) |> fetch
    # Wait for them to be done before proceeding.
    @info "Wait on addVariable eventId" resultId
    NVA.waitForCompletion(client, [resultId], expectedStatuses=["Complete"], maxSeconds=180)
    
    eventId = NVA.addFactor(client, context, 
        NVA.Factor("x0f1", "PriorPose2", ["x0"], NVA.PriorPose2Data())
    ) |> fetch
    @info "Wait on addFactor eventId" resultId

    # eventId = NVA.addFactor(client, context, NVA.Factor())
    NVA.waitForCompletion(client, [eventId], expectedStatuses=["Complete"], maxSeconds=180)
  end

  # export the graph
  eventId = NVA.exportSession(client, context, "testexport.tar.gz",
                              options=NVA.ExportSessionOptions(
                                format="NVA" # TODO TARGZ
                              )) |> fetch

  @info "waiting for export Session" eventId
  NVA.waitForCompletionExportSession(client, eventId)
end


function runSolveTests(client, context)
  @testset "test exportSession" begin
    @info "Running test exportSession"

    @error "restore exportSession test"
    # testExportSession(client, context; buildNewGraph=false)
  end
end
