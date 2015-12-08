'''
Created on Jul 23, 2011

@author: Carol Anderson

Purpose is to remove any indels covering multiple positions from a mummer-generated snplist

'''
############USER INPUTS###############################################################
#enter the name of the SNPlist. This list should be in the format produced by Mummer.
SNPlist='YPS128_DBVPG1106_reformatted.txt'

#enter the name of the output file to be created
outfile='YPS128_DBVPG1106_nomultibaseindels_snps.txt'
######################################################################################


inhandle=open(SNPlist, 'rU')


def make_list_of_markers_to_remove(SNPlist):
    Sposition_list=set()
    Rposition_list=set()
    markers_to_remove=set()
    
    inhandle=open(SNPlist, 'rU')
    for line in inhandle.readlines():
        
        list=line.split('\t')
        #print list
        try:
            int(list[0])
            flag=True
        except ValueError:
            flag=False
            pass
        
        if flag==True:
            Spos=list[0]
            Rpos=list[3]
            Schr=list[8]
            Rchr=list[9]
            Smarker=(Schr, Spos)
            Rmarker=(Rchr, Rpos)
            
            if Smarker in Sposition_list:
                #print Smarker
                markers_to_remove.add(Smarker)
            else:
                Sposition_list.add(Smarker)
            
            if Rmarker in Rposition_list:
                markers_to_remove.add(Rmarker)
            else:
                Rposition_list.add(Rmarker)
    
    return markers_to_remove

multibase_indels=make_list_of_markers_to_remove(SNPlist)
print len(multibase_indels)
outhandle=open(outfile, 'w')     
for line in inhandle.readlines():

    
    list=line.split('\t')
    #print list
    try:
        int(list[0])
        flag=True
    except ValueError:
        outhandle.write(line)
        flag=False
        
    
    if flag==True:
        Spos=list[0]
        Rpos=list[3]
        Schr=list[8]
        Rchr=list[9]
        Smarker=(Schr, Spos)
        Rmarker=(Rchr, Rpos)
        
        if Smarker not in multibase_indels:
            if Rmarker not in multibase_indels:
                outhandle.write(line)
            else:
                pass
        else:
            pass
            
outhandle.close()
