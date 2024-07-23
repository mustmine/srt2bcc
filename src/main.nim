import std/strutils

type body = object
    `from`: float
    to :    float
    location:int =2
    content: string

proc parsetime(time: string): float =
    # example input: 00:00:14,480
    let time2 = time.split(":")
    let hour = time2[0]
    let min = time2[1]
    let time3 = time2[2].split(",")
    let sec = time3[0]
    let msec = time3[1]
    let allsec = sec.parseFloat() + min.parseFloat()*60 + hour.parseFloat()*60*60 + msec.parseFloat()*0.001
    return allsec

proc srt2bbc() =
    let infile = open("input.srt", fmRead)
    let outfile = open("out.bcc", fmReadWrite)
    defer: 
        infile.close()
        outfile.close()

    let header = """
{
"font_size": 0.4,
"font_color": "#FFFFFF",
"background_alpha": 0.5,
"background_color": "#9C27B0",
"stroke": "none",
"body": [
"""

    let ender = """
]
}
    """

    outfile.write(header)

    var bodyseq: seq[body]
    var initbody = body()
    var i = 1
    for line in infile.lines:
        
        if i mod 4 == 1:
            i = i + 1
            continue
        elif i mod 4 == 2:
            i = i + 1
            let times = line.split(" ")
            initbody.`from` = parsetime(times[0])
            initbody.`to` = parsetime(times[2])
        elif i mod 4 == 3:
            i = i + 1
            initbody.content = line
            bodyseq.add(initbody)
        else: 
            i = i + 1
            continue

    for i,mbody in bodyseq:
        outfile.write("""
{"from":
""")
        outfile.write(mbody.`from`)
        outfile.write(",")
        outfile.write("""
"to":
""")
        outfile.write(mbody.to)
        outfile.write(",")
        outfile.write("""
"location": 
""")
        outfile.write(mbody.location)
        outfile.write(",")
        outfile.write("""
"content":  
""")
        outfile.write('"')
        outfile.write(mbody.content)
        outfile.write('"')
        if i == bodyseq.high:
            outfile.write("""
}
""")
        else:
            outfile.write("""
},
""")

    outfile.write(ender)

srt2bbc()