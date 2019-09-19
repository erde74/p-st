Class {
	#name : #P4MOCommand,
	#superclass : #P4Object,
	#instVars : [
		'size'
	],
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MOCommand >> commandSize [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
P4MOCommand >> fileOffset: offset [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
P4MOCommand >> type [
	"
	/* Constants for the cmd field of all load commands, the type */
	LC_SEGMENT  0x1 /* segment of this file to be mapped */
	LC_SYMTAB   0x2 /* link-edit stab symbol table info */
	LC_SYMSEG   0x3 /* link-edit gdb symbol table info (obsolete) */
	LC_THREAD   0x4 /* thread */
	LC_UNIXTHREAD   0x5 /* unix thread (includes a stack) */
	LC_LOADFVMLIB   0x6 /* load a specified fixed VM shared library *
	LC_IDFVMLIB 0x7 /* fixed VM shared library identification */
	LC_IDENT    0x8 /* object identification info (obsolete) */
	LC_FVMFILE  0x9 /* fixed VM file inclusion (internal use) */
	LC_PREPAGE      0xa     /* prepage command (internal use) */
	LC_DYSYMTAB 0xb /* dynamic link-edit symbol table info */
	LC_LOAD_DYLIB   0xc /* load a dynamically linked shared library *
	LC_ID_DYLIB 0xd /* dynamically linked shared lib ident */
	LC_LOAD_DYLINKER 0xe    /* load a dynamic linker */
	LC_ID_DYLINKER  0xf /* dynamic linker identification */
	LC_PREBOUND_DYLIB 0x10  /* modules prebound for a dynamically */
	        /*  linked shared library */
	LC_ROUTINES 0x11    /* image routines */
	LC_SUB_FRAMEWORK 0x12   /* sub framework */
	LC_SUB_UMBRELLA 0x13    /* sub umbrella */
	LC_SUB_CLIENT   0x14    /* sub client */
	LC_SUB_LIBRARY  0x15    /* sub library */
	LC_TWOLEVEL_HINTS 0x16  /* two-level namespace lookup hints */
	LC_PREBIND_CKSUM  0x17  /* prebind checksum */"
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
P4MOCommand >> writeCommandOn: aStream [
	aStream wordPut: self type.
	aStream wordPut: self commandSize.
]
