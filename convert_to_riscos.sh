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

for dir in 'c' 'h' 'lib' 'lib/h' 'lib/c' 'lib/smb' 'lib/smb/c' 'lib/smb/h' 'lib/smb/o' 'lib/smbclient' 'lib/smbclient/c' 'lib/smbclient/h' 'lib/smbclient/o' 'include/h' 'include/netsmb/h' \
    'kernel/netsmb/c' 'kernel/netsmb/h' 'kernel/smbfs/c' 'kernel/smbfs/h'; do
    if [ ! -d $dir ]; then
        mkdir -p smbclient/$dir
    fi
done

# Ensure that the required directories exist, and are read and writable from RISC OS

for dir in 'CoreFoundation/c' 'CoreFoundation/h'; do
    if [ ! -d $dir ]; then
        mkdir -p $dir
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

for source in 'md4' 'md4c' 'netbios' 'smb_2' 'smb_conn_2' 'smb_conn' 'smb_converter' 'smb_crypt' 'smb_dev_2' 'smb_dev' 'smb_fid' 'smb_gss_2' 'smb_gss' 'smb_iod' 'smb_packets_2' 'smb_read_write' 'smb_rq_2' 'smb_rq' 'smb_sleephandler' 'smb_smb_2' 'smb_smb' 'smb_sbr' 'smb_tran' 'smb_trantcp' 'smb_usr_2' 'smb_usr' 'smb_mc_support' 'smb_mc' 'smb'; do
    for type in 'c' 'h'; do
        copy_or_diff SMBClient-src/kernel/netsmb/$source.$type  smbclient/kernel/netsmb/$type/$source
    done
done

# kernel/smbfs/*.(c|h) files

for source in 'smbfs_attrlist' 'smbfs_io' 'smbfs_lockf' 'smbfs_node' 'smbfs_notify_change' 'smbfs_security' 'smbfs_smb_2' 'smbfs_smb' 'smbfs_subr_2' 'smbfs_subr' 'smbfs_vfsops' 'smbfs_vnops' 'smbfs'; do
    for type in 'c' 'h'; do
        copy_or_diff SMBClient-src/kernel/smbfs/$source.$type  smbclient/kernel/smbfs/$type/$source
    done
done

# include/netsmb/*.h files

for header in 'nb_lib' 'rq' 'smb_lib' 'smb_rap' 'smbio_2' 'smbio' 'upi_mbuf'; do
    copy_or_diff SMBClient-src/include/netsmb/$header.h smbclient/include/netsmb/h/$header
done



for source in CFApplicationPreferences CFArray CFAvailability CFBag CFBase CFBasicHash CFBigNumber CFBinaryHeap CFBinaryPList CFBitVector CFBuiltinConverters CFBundle_Binary CFBundle_BinaryTypes CFBundle_Grok CFBundle_InfoPlist CFBundle_Internal CFBundle_Locale \
CFBundle_Resources CFBundle_Strings CFBundle CFBundlePriv CFBurstTrie CFByteOrder CFCalendar CFCharacterSet CFCharacterSetPriv CFConcreteStreams CFData CFDate CFDateFormatter CFDictionary CFError_Private CFError CFFileUtilities CFICUConverters \
CFICULogging CFInternal CFLocale CFLocaleIdentifier CFLocaleInternal CFLocaleKeys CFLogUtilities CFMachPort CFMessagePort CFNumber CFNumberFormatter CFPlatform CFPlatformConverters CFPlugIn_Factory CFPlugIn_Instance CFPlugIn_PlugIn CFPlugIn \
CFPlugInCOM CFPreferences CFPriv CFPropertyList CFRunLoop CFRuntime CFSet CFSocket CFSocketStream CFSortFunctions CFStorage CFStream CFStreamAbstract CFStreamInternal CFStreamPriv \
CFString CFStringDefaultEncoding CFStringEncodingConverter CFStringEncodingConverterExt CFStringEncodingConverterPriv CFStringEncodingDatabase CFStringEncodingExt CFStringEncodings CFStringScanner CFStringUtilities \
CFSystemDirectories CFTimeZone CFTree CFUniChar CFUniCharPriv CFUnicodeDecomposition CFUnicodePrecomposition CFURL CFURL.inc CFURLAccess CFURLPriv CFUserNotification CFUtilities CFUUID CFVersion CFWindowsUtilities \
CFXMLInputStream CFXMLNode CFXMLParser CFXMLPreferencesDomain CFXMLTree CoreFoundation_Prefix CoreFoundation ForFoundationOnly plconvert TargetConditionals ; do
    for type in 'c' 'h'; do
        copy_or_diff CF-src/$source.$type  CoreFoundation/$type/$source
    done
done

