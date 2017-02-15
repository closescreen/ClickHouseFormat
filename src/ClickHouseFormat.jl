module ClickHouseFormat
module CSV


"""
    s1 = CSV.String(\""" " - it is quote \""")

    let s::CSV.String = "hello"; s end 
"""
immutable String
 v::Base.String
 String(x::Base.String) = new(x)
 String(x::Any) = new(Base.String(x))
end
Base.convert( ::Type{CSV.String}, s::AbstractString ) = String(s)



""" CSV.String(\""" " - it is quote \""") |> print """
Base.show(io::IO, s::CSV.String ) = write(io, '"', qqx2(s.v), '"')


""" CSV.DateTime(DateTime(\"2017-01-17\")) 

let dt::CSV.DateTime = \"2017-01-18T23:59:01\"; dt end
"""
immutable DateTime
 v::Dates.DateTime
end

Base.convert( ::Type{CSV.DateTime}, s::AbstractString) = DateTime(s)

""" Dates.DateTime(\"2017-01-17T15:36:42\") """
DateTime(s::AbstractString) = DateTime( Dates.DateTime(s))

""" CSV.DateTime(\"2017-01-17T15:36:42\")"""
DateTime(y::Int, m::Int=1, d::Int=1, h::Int=0, mi::Int=0, s::Int=0) = DateTime( Dates.DateTime(y,m,d,h,mi,s))


import Base.Dates: unix2datetime
export unix2datetime

""" CSV.unix2datetime(1482891697)

    CSV.unix2datetime(\"1482891697\") 
"""
unix2datetime(s::AbstractString) = unix2datetime( parse( Int32, s))

"""
    d1 = CSV.DateTime(DateTime(\"2017-01-17\"))
    
    print( d1)
"""
Base.show(io::IO, dt::DateTime) = write(io, '"', string(dt.v), '"')



""" CSV.Date(Date(2017,1,17)) """
immutable Date
 v::Dates.Date
end


""" CSV.Date( \"2017-1-17\") """
Date( s::AbstractString ) = Date( Dates.Date(s))


""" CSV.Date(2017,1,17) """
Date( y::Int, m::Int=1, d::Int=1 ) = Date( Dates.Date(y,m,d))

Base.convert( ::Type{CSV.Date}, s::AbstractString) = Date(s)


""" d1 = CSV.Date( Date(2017,1,17))

    print( d1 )
    
    "\$d1" 
"""
Base.show(io::IO, d::Date) = write(io, '"', string(d.v), '"')


""" All single CSV - types """
typealias Scalar Union{Date,DateTime,String}


"""
a1 = [ CSV.String(\"123=kuku\"), CSV.String(\"345=ksks\") ]
\"\$a1\"
"""
function Base.show{T<:Scalar}(io::IO, a::AbstractArray{T})
 write(io, '"', '[')
 l = length(a)
 if l>1
    for el in a[1:(l-1)]
	write(io, '\'', qqx2( string(el.v)) , '\'', ',' )
    end
 end
 l>0 && write(io, '\'', qqx2( string(a[l].v)), '\'')
 write(io, ']', '"')
end

qqx2(s::AbstractString)::AbstractString = replace( s, "\"", "\"\"")

end # module CSV

# -- Any other formats before finish ? --

end # module ClickHouseFormat