'''
Created on Jul 23, 2011

@author: Carol Anderson

Purpose: to reformat a SNP list produced by Mummer into the format expected by ReCombine
'''



#################USER INPUTS######################################
#enter the name of the file produced by Mummer
SNPlist='YPS128_DBVPG1106_snps.txt'

#enter the name of the output file to be created
output='YPS128_DBVPG1106_reformatted.txt'
##################################################################

inhandle=open(SNPlist, 'rU')
outhandle=open(output,'w')


def convertToChr(line):
    line = line.replace("ref|NC_001133|", "Chr01")
    line = line.replace("ref|NC_001134|", "Chr02")
    line = line.replace("ref|NC_001135|", "Chr03")
    line = line.replace("ref|NC_001136|", "Chr04")
    line = line.replace("ref|NC_001137|", "Chr05")
    line = line.replace("ref|NC_001138|", "Chr06")
    line = line.replace("ref|NC_001139|", "Chr07")
    line = line.replace("ref|NC_001140|", "Chr08")
    line = line.replace("ref|NC_001141|", "Chr09")
    line = line.replace("ref|NC_001142|", "Chr10")
    line = line.replace("ref|NC_001143|", "Chr11")
    line = line.replace("ref|NC_001144|", "Chr12")
    line = line.replace("ref|NC_001145|", "Chr13")
    line = line.replace("ref|NC_001146|", "Chr14")
    line = line.replace("ref|NC_001147|", "Chr15")
    line = line.replace("ref|NC_001148|", "Chr16")
    return line

for line in inhandle:
    newline=convertToChr(line)
    list=newline.split('\t')
    #print list
    try:
        int(list[0])
        flag=True
    except ValueError:
        #outhandle.write(newline)
        flag=False
    
    if flag==True:  
        Spos=int(list[0])
        Sbase=list[1]
        Rbase=list[2]
        Rpos=int(list[3])
        Schr=list[8]
        Rcontig=list[9]
        

        if Sbase=='.':  #this is an insertion
            type='I'
            Sstart=Spos+1
            Send=Spos+2
            Rstart=Rpos+1
            Rend=Rpos+1
            Sbase='-'
            
        elif Rbase=='.':  #this is a deletion
            type='D'
            Sstart=Spos+1
            Send=Spos+1
            Rstart=Rpos+1
            Rend=Rpos+2
            Rbase='-'
            
        else:  #this is a SNP
            type='S'
            Sstart=Spos
            Send=Spos
            Rstart=Rpos
            Rend=Rpos
    
        outputline='%s\t%s\t%s\t%s\t%s\t>\t%s\t%s\t%s\t%s\n'%(Schr, str(Sstart), str(Send), type, Sbase,Rbase,Rcontig.rstrip(),Rstart, Rend)
        outhandle.write(outputline)

