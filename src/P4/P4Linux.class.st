Class {
	#name : #P4Linux,
	#superclass : #P4AbstractOS,
	#category : #'P4-SystemSpec'
}

{ #category : #elf }
P4Linux >> elfABI [
	"
	ELFOSABI_NONE		0	No extensions or unspecified
	ELFOSABI_HPUX		1	Hewlett-Packard HP-UX
	ELFOSABI_NETBSD		2	NetBSD
	ELFOSABI_LINUX		3	Linux
	ELFOSABI_SOLARIS		6	Sun Solaris
	ELFOSABI_AIX			7	AIX
	ELFOSABI_IRIX			8	IRIX
	ELFOSABI_FREEBSD	9	FreeBSD
	ELFOSABI_TRU64		10	Compaq TRU64 UNIX
	ELFOSABI_MODESTO	11	Novell Modesto
	ELFOSABI_OPENBSD	12	Open BSD
	ELFOSABI_OPENVMS	13	Open VMS
	ELFOSABI_NSK			14	Hewlett-Packard Non-Stop Kernel
	ELFOSABI_AROS		15	Amiga Research OS
	ELFOSABI_FENIXOS	16	The FenixOS highly scalable multi-core OS
 	64-255					Architecture-specific value range
	"
	^ 16r00
]

{ #category : #elf }
P4Linux >> elfABIVersion [
	^ 16r00
]

{ #category : #accessing }
P4Linux >> executableFormat [
	^ P4ELF new
		os: self  
]
