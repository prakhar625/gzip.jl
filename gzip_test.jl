using Base.Test
include("gzip.jl")

let
  file = open("gunzip.c.gz", "r")
  bs = BitStream(file)
  @test read_gzip_byte(bs, 5) == 31
  @test read_gzip_byte(bs, 5) == 24
  @test read_gzip_byte(bs, 4) == 2
  close(file)
end

let
    flags = 0b10001
    @test has_ext(flags)
    @test !has_crc(flags)
    @test !has_extra(flags)
    @test !has_name(flags)
    @test has_comment(flags)
end

let
  file = open("gunzip.c.gz", "r")
  h = read(file, GzipHeader)
  close(file)
end

let
  file = open("gunzip.c.gz", "r")
  h = read(file, GzipFile)
  @test h.fname == "gunzip.c"
  close(file)
end

let
  file = open("gunzip.c.gz", "r")
  h = read(file, GzipFile)
  bs = BitStream(file)
  bf = read(bs, BlockFormat)
  @test bf.last
  @test bf.block_type == [0,1]
  close(file)
end

let
  file = open("gunzip.c.gz", "r")
  h = read(file, GzipFile)
  bs = BitStream(file)
  bf = read(bs, BlockFormat)

  # These are the real values!
  @test read_gzip_byte(bs, 5) == 23
  @test read_gzip_byte(bs, 5) == 27
  @test read_gzip_byte(bs, 4) == 8
  close(file)
end

