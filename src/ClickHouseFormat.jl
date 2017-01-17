module ClickHouseFormat
module CSV

"""
    s1 = CSV.String(\""" " - it is quote \""")
"""    
immutable String
 v::AbstractString
 String(x::AbstractString) = new(x)
 String(x::Any) = new(string(x))
end


""" q("hello") """
q(io::IO, x::AbstractString) = ( write(io, '\'', replace(x, '"', "\"\""), '\''); nothing)
q(io::IO, x) = ( write(io, '\'', replace( string(x), '"', "\"\""), '\''); nothing)
q(x) = q(STDOUT,x)


""" qq("hello") """
qq(io::IO, x::String) = ( write(io, '"', replace(x.v, '"', "\"\""), '"'); nothing)
qq(io::IO, x) = ( write(io, '"', replace( string(x), '"', "\"\""), '"'); nothing)
qq(x) = qq(STDOUT,x)



""" CSV.String(\""" " - it is quote \""") |> print """
Base.print( io::IO, s::CSV.String )::Void = qq(io, s.v)



""" CSV.DateTime(DateTime("2017-01-17")) """
immutable DateTime
 v::Dates.DateTime
end



""" Dates.DateTime("2017-01-17T15:36:42") """
DateTime(s::AbstractString) = DateTime( Dates.DateTime(s))



""" CSV.DateTime("2017-01-17T15:36:42")"""
DateTime(y::Int, m::Int=1, d::Int=1, h::Int=0, mi::Int=0, s::Int=0) = DateTime( Dates.DateTime(y,m,d,h,mi,s))



""" CSV.unix2datetime(1482891697) """
unix2datetime( n::Number) = DateTime( Dates.unix2datetime(n))



""" CSV.unix2datetime("1482891697") """
unix2datetime( s::AbstractString) = DateTime( Dates.unix2datetime( parse( Int32, s)))


"""
    d1 = CSV.DateTime(DateTime("2017-01-17"))
    
    print( d1)
"""
Base.print( io::IO, dt::DateTime) = qq(io, string(dt.v))



""" CSV.Date(Date(2017,1,17)) """
immutable Date
 v::Dates.Date
end


""" CSV.Date( "2017-1-17") """
Date( s::AbstractString ) = Date( Dates.Date(s))


""" CSV.Date(2017,1,17) """
Date( y::Int, m::Int=1, d::Int=1 ) = Date( Dates.Date(y,m,d))


""" d1 = CSV.Date( Date(2017,1,17))

    print( d1 )
    
    "\$d1" 
"""
Base.print( io::IO, d::Date) = qq(io, d.v)


immutable Array
 a::Base.Array
end


"array elements quoting"
aq{ T<:Union{Date,DateTime,String} }( io::IO, x::T ) = q( io, x.v)
aq(io::IO, x) = ( write(io, string(x)); nothing )

function Base.print(io::IO, a::Array)::Void
 write(io, "\"[")
 #join(io, map(_->aq(io,_), a.a), ',')
 for el in a.a[1:(end-1)]
  aq(io, el)
  write(io,',')
 end
 aq(io,a.a[end]) 
 write(io, "]\"")
 nothing
end

Base.size(a::Array) = size(a.a)


end # module CSV

# -- Any other formats before finish ? --

end # module ClickHouseFormat