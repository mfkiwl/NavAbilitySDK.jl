
struct QueryOptions
    name::String
    query::String
    variables::Dict{String,Any}
end

struct MutationOptions
    name::String
    mutation::String
    variables::Dict{String,Any}
end

struct NavAbilityClient
    query::Function
    mutate::Function
end

function NavAbilityWebsocketClient( apiUrl::String="wss://api.navability.io/graphql")::NavAbilityClient
    throw("Not implemented")
end

"""
    $SIGNATURES

Main interactions with API for queries and mutations go through here.

DevNotes
- TODO TBD, rather use upstream retry logic instead, 
  - see https://github.com/JuliaWeb/HTTP.jl/pull/974/files
"""
function NavAbilityHttpsClient(
        apiUrl::String = "https://api.navability.io";
        auth_token::String = "",
        authorize::Bool = 0!==length(auth_token)
    )::NavAbilityClient
    #
    dianaClient = GraphQLClient(apiUrl)

    # auth
    if authorize
        tok = if 0===length(auth_token)
            # FIXME, use Base.getpass instead of readline once VSCode supports getpass.
                # st = Base.getpass("Copy-paste auth token")
                # seekstart(st)
                # tok = read(st, String)
                # Base.shred!(st)
            println("  > VSCode ONLY WORKAROUND, input issue, see https://github.com/julia-vscode/julia-vscode/issues/785")
            println("  >  Workaround: first press 0 then enter, and then paste the token and hit enter a second time.")
            println("Copy-paste auth token: ")
            readline(stdin)
        else
            auth_token
        end
        dianaClient.serverAuth("Bearer "*tok)
    end

    function query(options::QueryOptions)
        # NOTE, the query client library used is synchronous, locally converted to async for package consistency
        @async begin
            attempts = 0
            while true
                try
                    return dianaClient.Query(options.query, operationName=options.name, vars=options.variables)
                catch err
                    if attempts < 3
                        @warn "[Test Client] WARN Client saw an exception. Retrying! Query=$(options.query)" exception=(err, catch_backtrace())
                        sleep(rand()) 
                        attempts += 1
                    else
                        rethrow()
                    end
                end
            end
        end
    end

    function mutate(options::MutationOptions)
        # NOTE, the query client library used is synchronous, locally converted to async for package consistency
        @async begin
            attempts = 0
                while true
                try
                    return dianaClient.Query(options.mutation, operationName=options.name, vars=options.variables)
                catch err
                    if attempts < 3
                        @warn "[Test Client] WARN Client saw an exception. Retrying! Query=$(options.mutation)" exception=(err, catch_backtrace())
                        sleep(rand())
                        attempts += 1
                    else
                        rethrow()
                    end
                end
            end
        end
    end
    
    return NavAbilityClient(query, mutate)
end
