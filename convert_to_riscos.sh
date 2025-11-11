#!/bin/bash
#
# Convert parts of the standard smbclient source tree into the RISC OS source tree.
#
# Changed files are not overwritten - either manually merge them,
# or write them back to the standard source tree and delete them
# from the RISC OS tree before using git to merge the changes and
# then re-convert them.
#
# Copyright 2023 Rob McKay
#
# This file is part of 'RISC OS SMB Client'
#


function copy_or_diff() {
    if [ -f $1 ]; then
        if [ ! -f $2 ]; then
            cp -n -p $1 $2
        else
            diff --strip-trailing-cr -p $1 $2
        fi
    fi
}


# Ensure that the required directories exist, and are read and writable from RISC OS

for dir in 'c' 'h' 'o' 'lib' 'lib/h' 'lib/c' 'lib/smb' 'lib/smb/c' 'lib/smb/h' 'lib/smb/o' 'lib/smbclient' 'lib/smbclient/c' 'lib/smbclient/h' 'lib/smbclient/o' 'include/h' 'include/netsmb/h' 'kernel/netsmb/c' 'kernel/netsmb/h'; do
    if [ ! -d $dir ]; then
        mkdir -p smbclient/$dir
    fi
done

# lib/smb/*.(c|h) files

for source in 'charsets' 'ctx' 'file' 'gss' 'interface' 'mbuf' 'msdfs' 'nb_name' 'nb_net' 'nb' 'nbns_rq' 'parse_url' 'preference' 'print' 'rcfile_priv' 'rc_file' 'remount' 'rq' 'smb_preferences' 'smbio_2' 'smbio' 'subr' ; do
    for type in 'c' 'h'; do
        copy_or_diff SMBClient-src/lib/smb/$source.$type  smbclient/lib/smb/$type/$source
    done
done

# lib/smbclient/*.(c|h) files

for source in 'fileio' 'netbios' 'netfs' 'ntstatus' 'raw' 'server' 'smbclient_internal' 'smbclient_netfs' 'smbclient_private' 'smbclient' 'util' ; do
    for type in 'c' 'h'; do
        copy_or_diff SMBClient-src/lib/smbclient/$source.$type  smbclient/lib/smbclient/$type/$source
    done
done

# kernel/netsmb/*.(c|h) files

for source in 'md4' 'md4c' 'netbios' 'smb_2' 'smb_conn_2' 'smb_conn' 'smb_converter' 'smb_crypt' 'smb_dev_2' 'smb_dev' 'smd_fid' 'smd_gss_2' 'smd_gss' 'smd_iod' 'smd_packets_2' 'smd_read_write' 'smd_rq_2' 'smd_rq' 'smd_sleephandler' 'smd_smb_2' 'smd_smb' 'smd_sbr' 'smd_tran' 'smd_trantcp' 'smd_usr_2' 'smd_usr' 'smd_mc_support' 'smd_mc' ; do
    for type in 'c' 'h'; do
        copy_or_diff SMBClient-src/kernel/netsmb/$source.$type  smbclient/kernel/netsmb/$type/$source
    done
done

# include/netsmb/*.h files

for header in 'nb_lib' 'rq' 'smb_lib' 'smb_rap' 'smbio_2' 'smbio' 'upi_mbuf'; do
    copy_or_diff SMBClient-src/include/netsmb/$header.h smbclient/include/netsmb/h/$header
done
