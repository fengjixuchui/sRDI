﻿$Source = @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Reflection;

public class sRDI
{
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_DATA_DIRECTORY
    {
        public uint VirtualAddress;
        public uint Size;
    }

    //[StructLayout(LayoutKind.Sequential, Pack = 1)]
    [StructLayout(LayoutKind.Explicit)]
    unsafe struct IMAGE_SECTION_HEADER
    {
        [FieldOffset(0)]
        public fixed byte Name[8];
        [FieldOffset(8)]
        public uint PhysicalAddress;
        [FieldOffset(8)]
        public uint VirtualSize;
        [FieldOffset(12)]
        public uint VirtualAddress;
        [FieldOffset(16)]
        public uint SizeOfRawData;
        [FieldOffset(20)]
        public uint PointerToRawData;
        [FieldOffset(24)]
        public uint PointerToRelocations;
        [FieldOffset(28)]
        public uint PointerToLinenumbers;
        [FieldOffset(32)]
        public ushort NumberOfRelocations;
        [FieldOffset(34)]
        public ushort NumberOfLinenumbers;
        [FieldOffset(36)]
        public uint Characteristics;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_FILE_HEADER
    {
        public ushort Machine;
        public ushort NumberOfSections;
        public uint TimeDateStamp;
        public uint PointerToSymbolTable;
        public uint NumberOfSymbols;
        public ushort SizeOfOptionalHeader;
        public ushort Characteristics;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_EXPORT_DIRECTORY
    {
        public uint Characteristics;
        public uint TimeDateStamp;
        public ushort MajorVersion;
        public ushort MinorVersion;
        public uint Name;
        public uint Base;
        public uint NumberOfFunctions;
        public uint NumberOfNames;
        public uint AddressOfFunctions;     // RVA from base of image
        public uint AddressOfNames;         // RVA from base of image
        public uint AddressOfNameOrdinals;  // RVA from base of image
    }

    enum IMAGE_DOS_SIGNATURE : ushort
    {
        DOS_SIGNATURE = 0x5A4D,      // MZ
        OS2_SIGNATURE = 0x454E,      // NE
        OS2_SIGNATURE_LE = 0x454C,      // LE
    }

    enum MagicType : ushort
    {
        IMAGE_NT_OPTIONAL_HDR32_MAGIC = 0x10b,
        IMAGE_NT_OPTIONAL_HDR64_MAGIC = 0x20b,
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_DOS_HEADER
    {
        public IMAGE_DOS_SIGNATURE e_magic;        // Magic number
        public ushort e_cblp;                      // public bytes on last page of file
        public ushort e_cp;                        // Pages in file
        public ushort e_crlc;                      // Relocations
        public ushort e_cparhdr;                   // Size of header in paragraphs
        public ushort e_minalloc;                  // Minimum extra paragraphs needed
        public ushort e_maxalloc;                  // Maximum extra paragraphs needed
        public ushort e_ss;                        // Initial (relative) SS value
        public ushort e_sp;                        // Initial SP value
        public ushort e_csum;                      // Checksum
        public ushort e_ip;                        // Initial IP value
        public ushort e_cs;                        // Initial (relative) CS value
        public ushort e_lfarlc;                    // File address of relocation table
        public ushort e_ovno;                      // Overlay number
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 8)]
        public string e_res;                       // May contain 'Detours!'
        public ushort e_oemid;                     // OEM identifier (for e_oeminfo)
        public ushort e_oeminfo;                   // OEM information; e_oemid specific
        [MarshalAsAttribute(UnmanagedType.ByValArray, SizeConst = 10)]
        public ushort[] e_res2;                      // Reserved public ushorts
        public Int32 e_lfanew;                    // File address of new exe header
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_OPTIONAL_HEADER
    {
        //
        // Standard fields.
        //

        public MagicType Magic;
        public byte MajorLinkerVersion;
        public byte MinorLinkerVersion;
        public uint SizeOfCode;
        public uint SizeOfInitializedData;
        public uint SizeOfUninitializedData;
        public uint AddressOfEntryPoint;
        public uint BaseOfCode;
        public uint BaseOfData;
        public uint ImageBase;
        public uint SectionAlignment;
        public uint FileAlignment;
        public ushort MajorOperatingSystemVersion;
        public ushort MinorOperatingSystemVersion;
        public ushort MajorImageVersion;
        public ushort MinorImageVersion;
        public ushort MajorSubsystemVersion;
        public ushort MinorSubsystemVersion;
        public uint Win32VersionValue;
        public uint SizeOfImage;
        public uint SizeOfHeaders;
        public uint CheckSum;
        public ushort Subsystem;
        public ushort DllCharacteristics;
        public uint SizeOfStackReserve;
        public uint SizeOfStackCommit;
        public uint SizeOfHeapReserve;
        public uint SizeOfHeapCommit;
        public uint LoaderFlags;
        public uint NumberOfRvaAndSizes;
        public IMAGE_DATA_DIRECTORY ExportTable;
        public IMAGE_DATA_DIRECTORY ImportTable;
        public IMAGE_DATA_DIRECTORY ResourceTable;
        public IMAGE_DATA_DIRECTORY ExceptionTable;
        public IMAGE_DATA_DIRECTORY CertificateTable;
        public IMAGE_DATA_DIRECTORY BaseRelocationTable;
        public IMAGE_DATA_DIRECTORY Debug;
        public IMAGE_DATA_DIRECTORY Architecture;
        public IMAGE_DATA_DIRECTORY GlobalPtr;
        public IMAGE_DATA_DIRECTORY TLSTable;
        public IMAGE_DATA_DIRECTORY LoadConfigTable;
        public IMAGE_DATA_DIRECTORY BoundImport;
        public IMAGE_DATA_DIRECTORY IAT;
        public IMAGE_DATA_DIRECTORY DelayImportDescriptor;
        public IMAGE_DATA_DIRECTORY CLRRuntimeHeader;
        public IMAGE_DATA_DIRECTORY Public;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_OPTIONAL_HEADER64
    {
        public MagicType Magic;
        public byte MajorLinkerVersion;
        public byte MinorLinkerVersion;
        public uint SizeOfCode;
        public uint SizeOfInitializedData;
        public uint SizeOfUninitializedData;
        public uint AddressOfEntryPoint;
        public uint BaseOfCode;
        public ulong ImageBase;
        public uint SectionAlignment;
        public uint FileAlignment;
        public ushort MajorOperatingSystemVersion;
        public ushort MinorOperatingSystemVersion;
        public ushort MajorImageVersion;
        public ushort MinorImageVersion;
        public ushort MajorSubsystemVersion;
        public ushort MinorSubsystemVersion;
        public uint Win32VersionValue;
        public uint SizeOfImage;
        public uint SizeOfHeaders;
        public uint CheckSum;
        public ushort Subsystem;
        public ushort DllCharacteristics;
        public ulong SizeOfStackReserve;
        public ulong SizeOfStackCommit;
        public ulong SizeOfHeapReserve;
        public ulong SizeOfHeapCommit;
        public uint LoaderFlags;
        public uint NumberOfRvaAndSizes;
        public IMAGE_DATA_DIRECTORY ExportTable;
        public IMAGE_DATA_DIRECTORY ImportTable;
        public IMAGE_DATA_DIRECTORY ResourceTable;
        public IMAGE_DATA_DIRECTORY ExceptionTable;
        public IMAGE_DATA_DIRECTORY CertificateTable;
        public IMAGE_DATA_DIRECTORY BaseRelocationTable;
        public IMAGE_DATA_DIRECTORY Debug;
        public IMAGE_DATA_DIRECTORY Architecture;
        public IMAGE_DATA_DIRECTORY GlobalPtr;
        public IMAGE_DATA_DIRECTORY TLSTable;
        public IMAGE_DATA_DIRECTORY LoadConfigTable;
        public IMAGE_DATA_DIRECTORY BoundImport;
        public IMAGE_DATA_DIRECTORY IAT;
        public IMAGE_DATA_DIRECTORY DelayImportDescriptor;
        public IMAGE_DATA_DIRECTORY CLRRuntimeHeader;
        public IMAGE_DATA_DIRECTORY Public;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_NT_HEADERS64
    {
        public uint Signature;
        public IMAGE_FILE_HEADER FileHeader;
        public IMAGE_OPTIONAL_HEADER64 OptionalHeader;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_NT_HEADERS
    {
        public uint Signature;
        public IMAGE_FILE_HEADER FileHeader;
        public IMAGE_OPTIONAL_HEADER OptionalHeader;
    }

    public static unsafe class InteropTools
    {
        private static readonly Type SafeBufferType = typeof(SafeBuffer);
        public delegate void PtrToStructureNativeDelegate(byte* ptr, TypedReference structure, uint sizeofT);
        public delegate void StructureToPtrNativeDelegate(TypedReference structure, byte* ptr, uint sizeofT);
        const BindingFlags flags = BindingFlags.NonPublic | BindingFlags.Static;
        private static readonly MethodInfo PtrToStructureNativeMethod = SafeBufferType.GetMethod("PtrToStructureNative", flags);
        private static readonly MethodInfo StructureToPtrNativeMethod = SafeBufferType.GetMethod("StructureToPtrNative", flags);
        public static readonly PtrToStructureNativeDelegate PtrToStructureNative = (PtrToStructureNativeDelegate)Delegate.CreateDelegate(typeof(PtrToStructureNativeDelegate), PtrToStructureNativeMethod);
        public static readonly StructureToPtrNativeDelegate StructureToPtrNative = (StructureToPtrNativeDelegate)Delegate.CreateDelegate(typeof(StructureToPtrNativeDelegate), StructureToPtrNativeMethod);

        private static readonly Func<Type, bool, int> SizeOfHelper_f = (Func<Type, bool, int>)Delegate.CreateDelegate(typeof(Func<Type, bool, int>), typeof(Marshal).GetMethod("SizeOfHelper", flags));

        public static void StructureToPtrDirect(TypedReference structure, IntPtr ptr, int size)
        {
            StructureToPtrNative(structure, (byte*)ptr, unchecked((uint)size));
        }

        public static void StructureToPtrDirect(TypedReference structure, IntPtr ptr)
        {
            StructureToPtrDirect(structure, ptr, SizeOf(__reftype(structure)));
        }

        public static void PtrToStructureDirect(IntPtr ptr, TypedReference structure, int size)
        {
            PtrToStructureNative((byte*)ptr, structure, unchecked((uint)size));
        }

        public static void PtrToStructureDirect(IntPtr ptr, TypedReference structure)
        {
            PtrToStructureDirect(ptr, structure, SizeOf(__reftype(structure)));
        }

        public static void StructureToPtr<T>(ref T structure, IntPtr ptr)
        {
            StructureToPtrDirect(__makeref(structure), ptr);
        }

        public static void PtrToStructure<T>(IntPtr ptr, out T structure)
        {
            structure = default(T);
            PtrToStructureDirect(ptr, __makeref(structure));
        }

        public static T PtrToStructure<T>(IntPtr ptr)
        {
            T obj;
            PtrToStructure(ptr, out obj);
            return obj;
        }

        public static int SizeOf<T>(T structure)
        {
            return SizeOf<T>();
        }

        public static int SizeOf<T>()
        {
            return SizeOf(typeof(T));
        }

        public static int SizeOf(Type t)
        {
            return SizeOfHelper_f(t, true);
        }
    }

    public static IntPtr Rva2Offset(uint dwRva, IntPtr PEPointer)
    {
        bool is64Bit = false;
        ushort wIndex = 0;
        ushort wNumberOfSections = 0;
        IntPtr imageSectionPtr;
        IMAGE_SECTION_HEADER SectionHeader;
        int sizeOfSectionHeader = Marshal.SizeOf(typeof(IMAGE_SECTION_HEADER));

        IMAGE_DOS_HEADER dosHeader = InteropTools.PtrToStructure<IMAGE_DOS_HEADER>(PEPointer);

        IntPtr NtHeadersPtr = (IntPtr)((UInt64)PEPointer + (UInt64)dosHeader.e_lfanew);

        var imageNtHeaders32 = (IMAGE_NT_HEADERS)Marshal.PtrToStructure(NtHeadersPtr, typeof(IMAGE_NT_HEADERS));
        var imageNtHeaders64 = (IMAGE_NT_HEADERS64)Marshal.PtrToStructure(NtHeadersPtr, typeof(IMAGE_NT_HEADERS64));

        if (imageNtHeaders64.OptionalHeader.Magic == MagicType.IMAGE_NT_OPTIONAL_HDR64_MAGIC) is64Bit = true;


        if (is64Bit)
        {
            imageSectionPtr = (IntPtr)(((Int64)NtHeadersPtr + (Int64)Marshal.OffsetOf(typeof(IMAGE_NT_HEADERS64), "OptionalHeader") + (Int64)imageNtHeaders64.FileHeader.SizeOfOptionalHeader));
            SectionHeader = (IMAGE_SECTION_HEADER)Marshal.PtrToStructure(imageSectionPtr, typeof(IMAGE_SECTION_HEADER));
            wNumberOfSections = imageNtHeaders64.FileHeader.NumberOfSections;
        }
        else
        {
            imageSectionPtr = (IntPtr)(((Int64)NtHeadersPtr + (Int64)Marshal.OffsetOf(typeof(IMAGE_NT_HEADERS), "OptionalHeader") + (Int64)imageNtHeaders32.FileHeader.SizeOfOptionalHeader));
            SectionHeader = (IMAGE_SECTION_HEADER)Marshal.PtrToStructure(imageSectionPtr, typeof(IMAGE_SECTION_HEADER));
            wNumberOfSections = imageNtHeaders32.FileHeader.NumberOfSections;
        }

        if (dwRva < SectionHeader.PointerToRawData)
            return (IntPtr)((UInt64)dwRva + (UInt64)PEPointer);

        for (wIndex = 0; wIndex < wNumberOfSections; wIndex++)
        {
            SectionHeader = (IMAGE_SECTION_HEADER)Marshal.PtrToStructure((IntPtr)((uint)imageSectionPtr + (uint)(sizeOfSectionHeader * (wIndex))), typeof(IMAGE_SECTION_HEADER));
            if (dwRva >= SectionHeader.VirtualAddress && dwRva < (SectionHeader.VirtualAddress + SectionHeader.SizeOfRawData))
                return (IntPtr)((UInt64)(dwRva - SectionHeader.VirtualAddress + SectionHeader.PointerToRawData) + (UInt64)PEPointer);
        }

        return IntPtr.Zero;
    }

    public static unsafe bool Is64BitDLL(byte[] dllBytes)
    {
        bool is64Bit = false;
        GCHandle scHandle = GCHandle.Alloc(dllBytes, GCHandleType.Pinned);
        IntPtr scPointer = scHandle.AddrOfPinnedObject();

        IMAGE_DOS_HEADER dosHeader = (IMAGE_DOS_HEADER)Marshal.PtrToStructure(scPointer, typeof(IMAGE_DOS_HEADER));

        IntPtr NtHeadersPtr = (IntPtr)((UInt64)scPointer + (UInt64)dosHeader.e_lfanew);

        var imageNtHeaders64 = (IMAGE_NT_HEADERS64)Marshal.PtrToStructure(NtHeadersPtr, typeof(IMAGE_NT_HEADERS64));
        var imageNtHeaders32 = (IMAGE_NT_HEADERS)Marshal.PtrToStructure(NtHeadersPtr, typeof(IMAGE_NT_HEADERS));

        if (imageNtHeaders64.Signature != 0x00004550)
            throw new ApplicationException("Invalid IMAGE_NT_HEADER signature.");

        if (imageNtHeaders64.OptionalHeader.Magic == MagicType.IMAGE_NT_OPTIONAL_HDR64_MAGIC) is64Bit = true;

        scHandle.Free();

        return is64Bit;
    }

    [UnmanagedFunctionPointer(CallingConvention.StdCall)]
    delegate IntPtr ReflectiveLoader();

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    delegate bool ExportedFunction(IntPtr userData, uint userLength);

    public static byte[] ConvertToShellcode(byte[] dllBytes, uint functionHash, byte[] userData, uint flags)
    {
            //MARKER:S
            var rdiShellcode32 = new byte[] { 0x83,0xEC,0x48,0x83,0x64,0x24,0x18,0x00,0xB9,0x4C,0x77,0x26,0x07,0x53,0x55,0x56,0x57,0x33,0xF6,0xE8,0x5C,0x04,0x00,0x00,0xB9,0x49,0xF7,0x02,0x78,0x89,0x44,0x24,0x1C,0xE8,0x4E,0x04,0x00,0x00,0xB9,0x58,0xA4,0x53,0xE5,0x89,0x44,0x24,0x20,0xE8,0x40,0x04,0x00,0x00,0xB9,0x10,0xE1,0x8A,0xC3,0x8B,0xE8,0xE8,0x34,0x04,0x00,0x00,0xB9,0xAF,0xB1,0x5C,0x94,0x89,0x44,0x24,0x2C,0xE8,0x26,0x04,0x00,0x00,0xB9,0x33,0x00,0x9E,0x95,0x89,0x44,0x24,0x30,0xE8,0x18,0x04,0x00,0x00,0x8B,0xD8,0x8B,0x44,0x24,0x5C,0x8B,0x78,0x3C,0x03,0xF8,0x89,0x7C,0x24,0x14,0x81,0x3F,0x50,0x45,0x00,0x00,0x74,0x07,0x33,0xC0,0xE9,0xF2,0x03,0x00,0x00,0xB8,0x4C,0x01,0x00,0x00,0x66,0x39,0x47,0x04,0x75,0xEE,0xF6,0x47,0x38,0x01,0x75,0xE8,0x0F,0xB7,0x57,0x06,0x0F,0xB7,0x47,0x14,0x85,0xD2,0x74,0x22,0x8D,0x4F,0x24,0x03,0xC8,0x83,0x79,0x04,0x00,0x8B,0x01,0x75,0x05,0x03,0x47,0x38,0xEB,0x03,0x03,0x41,0x04,0x3B,0xC6,0x0F,0x47,0xF0,0x83,0xC1,0x28,0x83,0xEA,0x01,0x75,0xE3,0x8D,0x44,0x24,0x34,0x50,0xFF,0xD3,0x8B,0x44,0x24,0x38,0x8B,0x5F,0x50,0x8D,0x50,0xFF,0x8D,0x48,0xFF,0xF7,0xD2,0x48,0x03,0xCE,0x03,0xC3,0x23,0xCA,0x23,0xC2,0x3B,0xC1,0x75,0x97,0x6A,0x04,0xBE,0x00,0x30,0x00,0x00,0x56,0x53,0xFF,0x77,0x34,0xFF,0xD5,0x8B,0xD8,0x89,0x5C,0x24,0x10,0x85,0xDB,0x75,0x0F,0x6A,0x04,0x56,0xFF,0x77,0x50,0x50,0xFF,0xD5,0x8B,0xD8,0x89,0x44,0x24,0x10,0x8B,0x77,0x54,0x33,0xC0,0x8B,0x6C,0x24,0x5C,0x40,0x33,0xC9,0x89,0x44,0x24,0x24,0x8B,0xD3,0x85,0xF6,0x74,0x34,0x8B,0x5C,0x24,0x6C,0x23,0xD8,0x4E,0x85,0xDB,0x74,0x19,0x8B,0xC7,0x2B,0x44,0x24,0x5C,0x3B,0xC8,0x73,0x0F,0x83,0xF9,0x3C,0x72,0x05,0x83,0xF9,0x3E,0x76,0x05,0xC6,0x02,0x00,0xEB,0x05,0x8A,0x45,0x00,0x88,0x02,0x41,0x45,0x42,0x85,0xF6,0x75,0xD6,0x8B,0x5C,0x24,0x10,0x0F,0xB7,0x47,0x06,0x0F,0xB7,0x4F,0x14,0x85,0xC0,0x74,0x38,0x83,0xC7,0x2C,0x03,0xCF,0x8B,0x7C,0x24,0x5C,0x8B,0x51,0xF8,0x48,0x8B,0x31,0x03,0xD3,0x8B,0x69,0xFC,0x03,0xF7,0x89,0x44,0x24,0x5C,0x85,0xED,0x74,0x0F,0x8A,0x06,0x88,0x02,0x42,0x46,0x83,0xED,0x01,0x75,0xF5,0x8B,0x44,0x24,0x5C,0x83,0xC1,0x28,0x85,0xC0,0x75,0xD5,0x8B,0x7C,0x24,0x14,0x8B,0xB7,0x80,0x00,0x00,0x00,0x03,0xF3,0x89,0x74,0x24,0x18,0x8B,0x46,0x0C,0x85,0xC0,0x74,0x7D,0x03,0xC3,0x50,0xFF,0x54,0x24,0x20,0x8B,0x6E,0x10,0x8B,0xF8,0x8B,0x06,0x03,0xEB,0x03,0xC3,0x89,0x44,0x24,0x5C,0x83,0x7D,0x00,0x00,0x74,0x4F,0x8B,0x74,0x24,0x20,0x8B,0x08,0x85,0xC9,0x74,0x1E,0x79,0x1C,0x8B,0x47,0x3C,0x0F,0xB7,0xC9,0x8B,0x44,0x38,0x78,0x2B,0x4C,0x38,0x10,0x8B,0x44,0x38,0x1C,0x8D,0x04,0x88,0x8B,0x04,0x38,0x03,0xC7,0xEB,0x0C,0x8B,0x45,0x00,0x83,0xC0,0x02,0x03,0xC3,0x50,0x57,0xFF,0xD6,0x89,0x45,0x00,0x83,0xC5,0x04,0x8B,0x44,0x24,0x5C,0x83,0xC0,0x04,0x89,0x44,0x24,0x5C,0x83,0x7D,0x00,0x00,0x75,0xB9,0x8B,0x74,0x24,0x18,0x8B,0x46,0x20,0x83,0xC6,0x14,0x89,0x74,0x24,0x18,0x85,0xC0,0x75,0x87,0x8B,0x7C,0x24,0x14,0x8B,0xC3,0x2B,0x47,0x34,0x89,0x44,0x24,0x1C,0x0F,0x84,0xBB,0x00,0x00,0x00,0x83,0xBF,0xA4,0x00,0x00,0x00,0x00,0x0F,0x84,0xAE,0x00,0x00,0x00,0x8B,0xB7,0xA0,0x00,0x00,0x00,0x03,0xF3,0x89,0x74,0x24,0x5C,0x8D,0x4E,0x04,0x8B,0x01,0x89,0x4C,0x24,0x18,0x85,0xC0,0x0F,0x84,0x91,0x00,0x00,0x00,0x8B,0x7C,0x24,0x1C,0x8B,0x16,0x8D,0x68,0xF8,0x03,0xD3,0x8D,0x46,0x08,0xD1,0xED,0x89,0x44,0x24,0x20,0x74,0x60,0x6A,0x02,0x8B,0xD8,0x5E,0x0F,0xB7,0x0B,0x4D,0x66,0x8B,0xC1,0x66,0xC1,0xE8,0x0C,0x66,0x83,0xF8,0x0A,0x74,0x06,0x66,0x83,0xF8,0x03,0x75,0x0B,0x81,0xE1,0xFF,0x0F,0x00,0x00,0x01,0x3C,0x11,0xEB,0x27,0x66,0x3B,0x44,0x24,0x24,0x75,0x11,0x81,0xE1,0xFF,0x0F,0x00,0x00,0x8B,0xC7,0xC1,0xE8,0x10,0x66,0x01,0x04,0x11,0xEB,0x0F,0x66,0x3B,0xC6,0x75,0x0A,0x81,0xE1,0xFF,0x0F,0x00,0x00,0x66,0x01,0x3C,0x11,0x03,0xDE,0x85,0xED,0x75,0xB1,0x8B,0x5C,0x24,0x10,0x8B,0x74,0x24,0x5C,0x8B,0x4C,0x24,0x18,0x03,0x31,0x89,0x74,0x24,0x5C,0x8D,0x4E,0x04,0x8B,0x01,0x89,0x4C,0x24,0x18,0x85,0xC0,0x0F,0x85,0x77,0xFF,0xFF,0xFF,0x8B,0x7C,0x24,0x14,0x0F,0xB7,0x47,0x06,0x0F,0xB7,0x4F,0x14,0x85,0xC0,0x0F,0x84,0xB7,0x00,0x00,0x00,0x8B,0x74,0x24,0x5C,0x8D,0x6F,0x3C,0x03,0xE9,0x48,0x83,0x7D,0xEC,0x00,0x89,0x44,0x24,0x24,0x0F,0x86,0x94,0x00,0x00,0x00,0x8B,0x4D,0x00,0x33,0xD2,0x42,0x8B,0xC1,0xC1,0xE8,0x1D,0x23,0xC2,0x8B,0xD1,0xC1,0xEA,0x1E,0x83,0xE2,0x01,0xC1,0xE9,0x1F,0x85,0xC0,0x75,0x18,0x85,0xD2,0x75,0x07,0x6A,0x08,0x5E,0x6A,0x01,0xEB,0x05,0x6A,0x04,0x5E,0x6A,0x02,0x85,0xC9,0x58,0x0F,0x44,0xF0,0xEB,0x2C,0x85,0xD2,0x75,0x17,0x85,0xC9,0x75,0x04,0x6A,0x10,0xEB,0x15,0x85,0xD2,0x75,0x0B,0x85,0xC9,0x74,0x18,0xBE,0x80,0x00,0x00,0x00,0xEB,0x11,0x85,0xC9,0x75,0x05,0x6A,0x20,0x5E,0xEB,0x08,0x6A,0x40,0x85,0xC9,0x58,0x0F,0x45,0xF0,0x8B,0x4D,0x00,0x8B,0xC6,0x0D,0x00,0x02,0x00,0x00,0x81,0xE1,0x00,0x00,0x00,0x04,0x0F,0x44,0xC6,0x8B,0xF0,0x8D,0x44,0x24,0x28,0x50,0x8B,0x45,0xE8,0x56,0xFF,0x75,0xEC,0x03,0xC3,0x50,0xFF,0x54,0x24,0x3C,0x85,0xC0,0x0F,0x84,0xD0,0xFC,0xFF,0xFF,0x8B,0x44,0x24,0x24,0x83,0xC5,0x28,0x85,0xC0,0x0F,0x85,0x52,0xFF,0xFF,0xFF,0x8B,0x77,0x28,0x6A,0x00,0x6A,0x00,0x6A,0xFF,0x03,0xF3,0xFF,0x54,0x24,0x3C,0x33,0xC0,0x40,0x50,0x50,0x53,0xFF,0xD6,0x83,0x7C,0x24,0x60,0x00,0x74,0x7C,0x83,0x7F,0x7C,0x00,0x74,0x76,0x8B,0x4F,0x78,0x03,0xCB,0x8B,0x41,0x18,0x85,0xC0,0x74,0x6A,0x83,0x79,0x14,0x00,0x74,0x64,0x8B,0x69,0x20,0x8B,0x79,0x24,0x03,0xEB,0x83,0x64,0x24,0x5C,0x00,0x03,0xFB,0x85,0xC0,0x74,0x51,0x8B,0x75,0x00,0x03,0xF3,0x33,0xD2,0x0F,0xBE,0x06,0xC1,0xCA,0x0D,0x03,0xD0,0x46,0x80,0x7E,0xFF,0x00,0x75,0xF1,0x39,0x54,0x24,0x60,0x74,0x16,0x8B,0x44,0x24,0x5C,0x83,0xC5,0x04,0x40,0x83,0xC7,0x02,0x89,0x44,0x24,0x5C,0x3B,0x41,0x18,0x72,0xD0,0xEB,0x1F,0x0F,0xB7,0x17,0x83,0xFA,0xFF,0x74,0x17,0x8B,0x41,0x1C,0xFF,0x74,0x24,0x68,0xFF,0x74,0x24,0x68,0x8D,0x04,0x90,0x8B,0x04,0x18,0x03,0xC3,0xFF,0xD0,0x59,0x59,0xF6,0x44,0x24,0x6C,0x02,0x74,0x17,0x8B,0x6C,0x24,0x1C,0x33,0xC0,0x68,0x00,0x80,0x00,0x00,0x6A,0x00,0x55,0xFF,0xD0,0x85,0xC0,0x75,0x03,0x55,0xFF,0xD0,0x8B,0xC3,0x5F,0x5E,0x5D,0x5B,0x83,0xC4,0x48,0xC3,0x83,0xEC,0x10,0x64,0xA1,0x30,0x00,0x00,0x00,0x53,0x55,0x56,0x8B,0x40,0x0C,0x57,0x89,0x4C,0x24,0x18,0x8B,0x70,0x0C,0xE9,0x8A,0x00,0x00,0x00,0x8B,0x46,0x30,0x33,0xC9,0x8B,0x5E,0x2C,0x8B,0x36,0x89,0x44,0x24,0x14,0x8B,0x42,0x3C,0x8B,0x6C,0x10,0x78,0x89,0x6C,0x24,0x10,0x85,0xED,0x74,0x6D,0xC1,0xEB,0x10,0x33,0xFF,0x85,0xDB,0x74,0x1F,0x8B,0x6C,0x24,0x14,0x8A,0x04,0x2F,0xC1,0xC9,0x0D,0x3C,0x61,0x0F,0xBE,0xC0,0x7C,0x03,0x83,0xC1,0xE0,0x03,0xC8,0x47,0x3B,0xFB,0x72,0xE9,0x8B,0x6C,0x24,0x10,0x8B,0x44,0x2A,0x20,0x33,0xDB,0x8B,0x7C,0x2A,0x18,0x03,0xC2,0x89,0x7C,0x24,0x14,0x85,0xFF,0x74,0x31,0x8B,0x28,0x33,0xFF,0x03,0xEA,0x83,0xC0,0x04,0x89,0x44,0x24,0x1C,0x0F,0xBE,0x45,0x00,0xC1,0xCF,0x0D,0x03,0xF8,0x45,0x80,0x7D,0xFF,0x00,0x75,0xF0,0x8D,0x04,0x0F,0x3B,0x44,0x24,0x18,0x74,0x20,0x8B,0x44,0x24,0x1C,0x43,0x3B,0x5C,0x24,0x14,0x72,0xCF,0x8B,0x56,0x18,0x85,0xD2,0x0F,0x85,0x6B,0xFF,0xFF,0xFF,0x33,0xC0,0x5F,0x5E,0x5D,0x5B,0x83,0xC4,0x10,0xC3,0x8B,0x74,0x24,0x10,0x8B,0x44,0x16,0x24,0x8D,0x04,0x58,0x0F,0xB7,0x0C,0x10,0x8B,0x44,0x16,0x1C,0x8D,0x04,0x88,0x8B,0x04,0x10,0x03,0xC2,0xEB,0xDB };
            var rdiShellcode64 = new byte[] { 0x44,0x89,0x4C,0x24,0x20,0x4C,0x89,0x44,0x24,0x18,0x89,0x54,0x24,0x10,0x53,0x55,0x56,0x57,0x41,0x54,0x41,0x55,0x41,0x56,0x41,0x57,0x48,0x83,0xEC,0x78,0x4C,0x8B,0xF9,0x45,0x33,0xE4,0xB9,0x4C,0x77,0x26,0x07,0x44,0x89,0x64,0x24,0x20,0x41,0x8B,0xDC,0xE8,0x4E,0x05,0x00,0x00,0xB9,0x49,0xF7,0x02,0x78,0x4C,0x8B,0xE8,0xE8,0x41,0x05,0x00,0x00,0xB9,0x58,0xA4,0x53,0xE5,0x48,0x89,0x44,0x24,0x28,0xE8,0x32,0x05,0x00,0x00,0xB9,0x10,0xE1,0x8A,0xC3,0x48,0x8B,0xE8,0xE8,0x25,0x05,0x00,0x00,0xB9,0xAF,0xB1,0x5C,0x94,0x48,0x89,0x44,0x24,0x30,0xE8,0x16,0x05,0x00,0x00,0xB9,0x33,0x00,0x9E,0x95,0x48,0x89,0x44,0x24,0x38,0xE8,0x07,0x05,0x00,0x00,0x4D,0x63,0x77,0x3C,0x4C,0x8B,0xD0,0x4B,0x8D,0x3C,0x3E,0x81,0x3F,0x50,0x45,0x00,0x00,0x0F,0x85,0xDD,0x04,0x00,0x00,0xB8,0x64,0x86,0x00,0x00,0x66,0x39,0x47,0x04,0x0F,0x85,0xCE,0x04,0x00,0x00,0x45,0x8D,0x5C,0x24,0x01,0x44,0x84,0x5F,0x38,0x0F,0x85,0xBF,0x04,0x00,0x00,0x0F,0xB7,0x4F,0x14,0x44,0x8B,0x4F,0x38,0x48,0x83,0xC1,0x24,0x66,0x44,0x3B,0x67,0x06,0x73,0x2C,0x44,0x0F,0xB7,0x47,0x06,0x48,0x03,0xCF,0x8B,0x41,0x04,0x8B,0x11,0x85,0xC0,0x75,0x06,0x49,0x8D,0x04,0x11,0xEB,0x02,0x03,0xC2,0x48,0x3B,0xC3,0x48,0x0F,0x46,0xC3,0x48,0x83,0xC1,0x28,0x48,0x8B,0xD8,0x4D,0x2B,0xC3,0x75,0xDC,0x48,0x8D,0x4C,0x24,0x40,0x41,0xFF,0xD2,0x44,0x8B,0x44,0x24,0x44,0x44,0x8B,0x4F,0x50,0x41,0x8D,0x48,0xFF,0x49,0x8D,0x50,0xFF,0x41,0x03,0xC9,0x49,0x8D,0x40,0xFF,0x48,0x03,0xD3,0x48,0xF7,0xD0,0x41,0xF7,0xD8,0x48,0x23,0xD0,0x41,0x8B,0xC0,0x48,0x23,0xC8,0x48,0x3B,0xCA,0x0F,0x85,0x45,0x04,0x00,0x00,0x48,0x8B,0x4F,0x30,0x41,0x8B,0xD1,0xBB,0x00,0x30,0x00,0x00,0x41,0xB9,0x04,0x00,0x00,0x00,0x44,0x8B,0xC3,0xFF,0xD5,0x48,0x8B,0xF0,0x48,0x85,0xC0,0x75,0x11,0x8B,0x57,0x50,0x44,0x8D,0x48,0x04,0x44,0x8B,0xC3,0x33,0xC9,0xFF,0xD5,0x48,0x8B,0xF0,0x8B,0x4F,0x54,0x49,0x8B,0xD4,0x44,0x8B,0xA4,0x24,0xE0,0x00,0x00,0x00,0x4D,0x8B,0xD7,0x44,0x89,0xA4,0x24,0xC0,0x00,0x00,0x00,0x4C,0x8B,0xDE,0xBB,0x01,0x00,0x00,0x00,0x48,0x85,0xC9,0x74,0x41,0x45,0x8B,0xCC,0x44,0x8D,0x63,0x01,0x44,0x23,0xCB,0x48,0x2B,0xCB,0x45,0x85,0xC9,0x74,0x13,0x49,0x3B,0xD6,0x73,0x0E,0x48,0x8D,0x42,0xC4,0x49,0x3B,0xC4,0x76,0x05,0x45,0x32,0xC0,0xEB,0x03,0x45,0x8A,0x02,0x45,0x88,0x03,0x49,0xFF,0xC2,0x49,0xFF,0xC3,0x48,0x03,0xD3,0x48,0x85,0xC9,0x75,0xD1,0x44,0x8B,0xA4,0x24,0xC0,0x00,0x00,0x00,0x0F,0xB7,0x4F,0x14,0x45,0x33,0xDB,0x44,0x0F,0xB7,0x57,0x06,0x48,0x03,0xCF,0x4D,0x85,0xD2,0x74,0x35,0x48,0x83,0xC1,0x2C,0x8B,0x51,0xF8,0x4C,0x2B,0xD3,0x44,0x8B,0x01,0x48,0x03,0xD6,0x44,0x8B,0x49,0xFC,0x4D,0x03,0xC7,0x4D,0x85,0xC9,0x74,0x10,0x41,0x8A,0x00,0x4C,0x03,0xC3,0x88,0x02,0x48,0x03,0xD3,0x4C,0x2B,0xCB,0x75,0xF0,0x48,0x83,0xC1,0x28,0x4D,0x85,0xD2,0x75,0xCF,0x8B,0x9F,0x90,0x00,0x00,0x00,0x48,0x03,0xDE,0x8B,0x43,0x0C,0x85,0xC0,0x0F,0x84,0x85,0x00,0x00,0x00,0x48,0x8B,0x6C,0x24,0x28,0x8B,0xC8,0x48,0x03,0xCE,0x41,0xFF,0xD5,0x44,0x8B,0x3B,0x4C,0x8B,0xE0,0x44,0x8B,0x73,0x10,0x4C,0x03,0xFE,0x4C,0x03,0xF6,0x45,0x33,0xDB,0xEB,0x4B,0x4D,0x39,0x1F,0x7D,0x29,0x49,0x63,0x44,0x24,0x3C,0x41,0x0F,0xB7,0x17,0x42,0x8B,0x8C,0x20,0x88,0x00,0x00,0x00,0x42,0x8B,0x44,0x21,0x10,0x42,0x8B,0x4C,0x21,0x1C,0x48,0x2B,0xD0,0x49,0x03,0xCC,0x8B,0x04,0x91,0x49,0x03,0xC4,0xEB,0x12,0x49,0x8B,0x16,0x49,0x8B,0xCC,0x48,0x83,0xC2,0x02,0x48,0x03,0xD6,0xFF,0xD5,0x45,0x33,0xDB,0x49,0x89,0x06,0x49,0x83,0xC6,0x08,0x49,0x83,0xC7,0x08,0x4D,0x39,0x1E,0x75,0xB0,0x8B,0x43,0x20,0x48,0x83,0xC3,0x14,0x85,0xC0,0x75,0x88,0x44,0x8B,0xA4,0x24,0xC0,0x00,0x00,0x00,0x4C,0x8B,0xFE,0x4C,0x2B,0x7F,0x30,0x0F,0x84,0xC5,0x00,0x00,0x00,0x44,0x39,0x9F,0xB4,0x00,0x00,0x00,0x0F,0x84,0xB8,0x00,0x00,0x00,0x8B,0x97,0xB0,0x00,0x00,0x00,0x48,0x03,0xD6,0x8B,0x42,0x04,0x85,0xC0,0x0F,0x84,0xA4,0x00,0x00,0x00,0xBD,0x01,0x00,0x00,0x00,0xBB,0xFF,0x0F,0x00,0x00,0x44,0x8D,0x65,0x01,0x44,0x8B,0x02,0x4C,0x8D,0x5A,0x08,0x44,0x8B,0xD0,0x4C,0x03,0xC6,0x49,0x83,0xEA,0x08,0x49,0xD1,0xEA,0x74,0x67,0x45,0x0F,0xB7,0x0B,0x4C,0x2B,0xD5,0x41,0x0F,0xB7,0xC1,0x41,0x0F,0xB7,0xC9,0x66,0xC1,0xE8,0x0C,0x66,0x83,0xF8,0x0A,0x75,0x10,0x4C,0x23,0xCB,0x4B,0x8B,0x0C,0x01,0x49,0x03,0xCF,0x4B,0x89,0x0C,0x01,0xEB,0x33,0x66,0x83,0xF8,0x03,0x75,0x09,0x48,0x23,0xCB,0x46,0x01,0x3C,0x01,0xEB,0x24,0x66,0x3B,0xC5,0x75,0x11,0x48,0x23,0xCB,0x49,0x8B,0xC7,0x48,0xC1,0xE8,0x10,0x66,0x42,0x01,0x04,0x01,0xEB,0x0E,0x66,0x41,0x3B,0xC4,0x75,0x08,0x48,0x23,0xCB,0x66,0x46,0x01,0x3C,0x01,0x4D,0x03,0xDC,0x4D,0x85,0xD2,0x75,0x9C,0x8B,0x42,0x04,0x48,0x03,0xD0,0x45,0x33,0xDB,0x8B,0x42,0x04,0x85,0xC0,0x0F,0x85,0x72,0xFF,0xFF,0xFF,0x44,0x8B,0xA4,0x24,0xC0,0x00,0x00,0x00,0x0F,0xB7,0x47,0x14,0x0F,0xB7,0x6F,0x06,0x48,0x83,0xC0,0x28,0x48,0x85,0xED,0x0F,0x84,0x06,0x01,0x00,0x00,0x8B,0x9C,0x24,0xC0,0x00,0x00,0x00,0x4C,0x8D,0x34,0x38,0x4C,0x8B,0x6C,0x24,0x30,0xBA,0x00,0x00,0x00,0x40,0x41,0xB8,0x01,0x00,0x00,0x00,0x49,0x2B,0xE8,0x45,0x39,0x1E,0x0F,0x86,0xD2,0x00,0x00,0x00,0x41,0x8B,0x4E,0x14,0x8B,0xC1,0x25,0x00,0x00,0x00,0x20,0x75,0x0D,0x85,0xCA,0x75,0x09,0x85,0xC9,0x78,0x05,0x41,0x8B,0xD8,0xEB,0x7E,0x85,0xC0,0x75,0x33,0x85,0xCA,0x75,0x09,0x85,0xC9,0x79,0x05,0x8D,0x58,0x08,0xEB,0x6D,0x85,0xC0,0x75,0x22,0x85,0xCA,0x74,0x09,0x85,0xC9,0x78,0x05,0x8D,0x58,0x02,0xEB,0x5C,0x85,0xC0,0x75,0x11,0x85,0xCA,0x74,0x09,0x85,0xC9,0x79,0x05,0x8D,0x58,0x04,0xEB,0x4B,0x85,0xC0,0x74,0x47,0x85,0xCA,0x75,0x0B,0x85,0xC9,0x78,0x07,0xBB,0x10,0x00,0x00,0x00,0xEB,0x38,0x85,0xC0,0x74,0x34,0x85,0xCA,0x75,0x0B,0x85,0xC9,0x79,0x07,0xBB,0x80,0x00,0x00,0x00,0xEB,0x25,0x85,0xC0,0x74,0x21,0x85,0xCA,0x74,0x0B,0x85,0xC9,0x78,0x07,0xBB,0x20,0x00,0x00,0x00,0xEB,0x12,0x85,0xC0,0x74,0x0E,0x85,0xCA,0x74,0x0A,0x85,0xC9,0xB8,0x40,0x00,0x00,0x00,0x0F,0x48,0xD8,0x41,0x8B,0x16,0x4C,0x8D,0x4C,0x24,0x20,0x8B,0xC3,0x0F,0xBA,0xE8,0x09,0x81,0xE1,0x00,0x00,0x00,0x04,0x41,0x8B,0x4E,0xFC,0x0F,0x44,0xC3,0x48,0x03,0xCE,0x44,0x8B,0xC0,0x8B,0xD8,0x41,0xFF,0xD5,0x45,0x33,0xDB,0x85,0xC0,0x0F,0x84,0xF5,0x00,0x00,0x00,0xBA,0x00,0x00,0x00,0x40,0x45,0x8D,0x43,0x01,0x49,0x83,0xC6,0x28,0x48,0x85,0xED,0x0F,0x85,0x15,0xFF,0xFF,0xFF,0x8B,0x5F,0x28,0x45,0x33,0xC0,0x33,0xD2,0x48,0x83,0xC9,0xFF,0x48,0x03,0xDE,0xFF,0x54,0x24,0x38,0x41,0xBD,0x01,0x00,0x00,0x00,0x48,0x8B,0xCE,0x45,0x8B,0xC5,0x41,0x8B,0xD5,0xFF,0xD3,0x8B,0xAC,0x24,0xC8,0x00,0x00,0x00,0x45,0x33,0xF6,0x85,0xED,0x0F,0x84,0x86,0x00,0x00,0x00,0x44,0x39,0xB7,0x8C,0x00,0x00,0x00,0x74,0x7D,0x44,0x8B,0x87,0x88,0x00,0x00,0x00,0x4C,0x03,0xC6,0x41,0x8B,0x58,0x18,0x85,0xDB,0x74,0x6B,0x45,0x39,0x70,0x14,0x74,0x65,0x45,0x8B,0x50,0x20,0x41,0x8B,0xFE,0x45,0x8B,0x48,0x24,0x4C,0x03,0xD6,0x4C,0x03,0xCE,0x85,0xDB,0x74,0x50,0x45,0x8B,0x1A,0x41,0x8B,0xD6,0x4C,0x03,0xDE,0x41,0x0F,0xBE,0x0B,0x4D,0x03,0xDD,0xC1,0xCA,0x0D,0x03,0xD1,0x84,0xC9,0x75,0xF0,0x3B,0xEA,0x74,0x11,0x41,0x03,0xFD,0x49,0x83,0xC2,0x04,0x49,0x83,0xC1,0x02,0x3B,0xFB,0x72,0xD4,0xEB,0x22,0x41,0x0F,0xB7,0x11,0x41,0x8B,0x48,0x1C,0x48,0x03,0xCE,0x8B,0x04,0x91,0x8B,0x94,0x24,0xD8,0x00,0x00,0x00,0x48,0x03,0xC6,0x48,0x8B,0x8C,0x24,0xD0,0x00,0x00,0x00,0xFF,0xD0,0x41,0xF6,0xC4,0x02,0x74,0x18,0x33,0xD2,0x41,0xB8,0x00,0x80,0x00,0x00,0x49,0x8B,0xCF,0x41,0xFF,0xD6,0x85,0xC0,0x75,0x06,0x49,0x8B,0xCF,0x41,0xFF,0xD6,0x48,0x8B,0xC6,0xEB,0x02,0x33,0xC0,0x48,0x83,0xC4,0x78,0x41,0x5F,0x41,0x5E,0x41,0x5D,0x41,0x5C,0x5F,0x5E,0x5D,0x5B,0xC3,0x48,0x8B,0xC4,0x48,0x89,0x58,0x08,0x48,0x89,0x68,0x10,0x48,0x89,0x70,0x18,0x48,0x89,0x78,0x20,0x41,0x56,0x48,0x83,0xEC,0x10,0x65,0x48,0x8B,0x04,0x25,0x60,0x00,0x00,0x00,0x8B,0xE9,0x45,0x33,0xF6,0x48,0x8B,0x50,0x18,0x4C,0x8B,0x4A,0x10,0x4D,0x8B,0x41,0x30,0x4D,0x85,0xC0,0x0F,0x84,0xB3,0x00,0x00,0x00,0x41,0x0F,0x10,0x41,0x58,0x49,0x63,0x40,0x3C,0x41,0x8B,0xD6,0x4D,0x8B,0x09,0xF3,0x0F,0x7F,0x04,0x24,0x46,0x8B,0x9C,0x00,0x88,0x00,0x00,0x00,0x45,0x85,0xDB,0x74,0xD2,0x48,0x8B,0x04,0x24,0x48,0xC1,0xE8,0x10,0x66,0x44,0x3B,0xF0,0x73,0x22,0x48,0x8B,0x4C,0x24,0x08,0x44,0x0F,0xB7,0xD0,0x0F,0xBE,0x01,0xC1,0xCA,0x0D,0x80,0x39,0x61,0x7C,0x03,0x83,0xC2,0xE0,0x03,0xD0,0x48,0xFF,0xC1,0x49,0x83,0xEA,0x01,0x75,0xE7,0x4F,0x8D,0x14,0x18,0x45,0x8B,0xDE,0x41,0x8B,0x7A,0x20,0x49,0x03,0xF8,0x45,0x39,0x72,0x18,0x76,0x8E,0x8B,0x37,0x41,0x8B,0xDE,0x49,0x03,0xF0,0x48,0x8D,0x7F,0x04,0x0F,0xBE,0x0E,0x48,0xFF,0xC6,0xC1,0xCB,0x0D,0x03,0xD9,0x84,0xC9,0x75,0xF1,0x8D,0x04,0x13,0x3B,0xC5,0x74,0x0E,0x41,0xFF,0xC3,0x45,0x3B,0x5A,0x18,0x72,0xD5,0xE9,0x5E,0xFF,0xFF,0xFF,0x41,0x8B,0x42,0x24,0x43,0x8D,0x0C,0x1B,0x49,0x03,0xC0,0x0F,0xB7,0x14,0x01,0x41,0x8B,0x4A,0x1C,0x49,0x03,0xC8,0x8B,0x04,0x91,0x49,0x03,0xC0,0xEB,0x02,0x33,0xC0,0x48,0x8B,0x5C,0x24,0x20,0x48,0x8B,0x6C,0x24,0x28,0x48,0x8B,0x74,0x24,0x30,0x48,0x8B,0x7C,0x24,0x38,0x48,0x83,0xC4,0x10,0x41,0x5E,0xC3 };
            //MARKER:E
        
        var newShellcode = new List<byte>();

        uint dllOffset = 0;

        if (Is64BitDLL(dllBytes))
        {
            var rdiShellcode = rdiShellcode64;
            int bootstrapSize = 64;

            // call next instruction (Pushes next instruction address to stack)
            newShellcode.Add(0xe8);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);

            // Set the offset to our DLL from pop result
            dllOffset = (uint)(bootstrapSize - newShellcode.Count + rdiShellcode.Length);

            // pop rcx - Capture our current location in memory
            newShellcode.Add(0x59);

            // mov r8, rcx - copy our location in memory to r8 before we start modifying RCX
            newShellcode.Add(0x49);
            newShellcode.Add(0x89);
            newShellcode.Add(0xc8);

            // Setup the location of the DLL into RCX
            // add rcx, <Offset of the DLL>
            newShellcode.Add(0x48);
            newShellcode.Add(0x81);
            newShellcode.Add(0xc1);
            foreach (byte b in BitConverter.GetBytes(dllOffset))
                newShellcode.Add(b);

            // mov edx, <hash of function>
            newShellcode.Add(0xba);
            foreach (byte b in BitConverter.GetBytes(functionHash))
                newShellcode.Add(b);

            // Put the location of our user data in 
            // add r8, <Offset of the DLL> + <Length of DLL>
            newShellcode.Add(0x49);
            newShellcode.Add(0x81);
            newShellcode.Add(0xc0);
            foreach (byte b in BitConverter.GetBytes((uint)(dllOffset + dllBytes.Length)))
                newShellcode.Add(b);

            // mov r9d, <Length of User Data>
            newShellcode.Add(0x41);
            newShellcode.Add(0xb9);
            foreach (byte b in BitConverter.GetBytes((uint)userData.Length))
                newShellcode.Add(b);

            // push rsi - save original value
            newShellcode.Add(0x56);

            // mov rsi, rsp - store our current stack pointer for later
            newShellcode.Add(0x48);
            newShellcode.Add(0x89);
            newShellcode.Add(0xe6);

            // and rsp, 0x0FFFFFFFFFFFFFFF0 - Align the stack to 16 bytes
            newShellcode.Add(0x48);
            newShellcode.Add(0x83);
            newShellcode.Add(0xe4);
            newShellcode.Add(0xf0);

            // sub rsp, 0x30 - Create some breathing room on the stack 
            newShellcode.Add(0x48);
            newShellcode.Add(0x83);
            newShellcode.Add(0xec);
            newShellcode.Add(6 * 8); // 32 bytes for shadow space + 8 bytes for last arg + 8 bytes for stack alignment

            // mov dword ptr [rsp + 0x20], <Flags> - Push arg 5 just above shadow space
            newShellcode.Add(0xc7);
            newShellcode.Add(0x44);
            newShellcode.Add(0x24);
            newShellcode.Add(4 * 8);
            foreach (byte b in BitConverter.GetBytes((uint)flags))
                newShellcode.Add(b);

            // call - Transfer execution to the RDI
            newShellcode.Add(0xe8);
            newShellcode.Add((byte)(bootstrapSize - newShellcode.Count - 4)); // Skip over the remainder of instructions
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);

            // mov rsp, rsi - Reset our original stack pointer
            newShellcode.Add(0x48);
            newShellcode.Add(0x89);
            newShellcode.Add(0xf4);

            // pop rsi - Put things back where we left them
            newShellcode.Add(0x5e);

            // ret - return to caller
            newShellcode.Add(0xc3);

            // Write the rest of RDI
            foreach (byte b in rdiShellcode)
                newShellcode.Add(b);

        }
        else // 32 Bit
        {
            var rdiShellcode = rdiShellcode32;
            int bootstrapSize = 46;

            // call next instruction (Pushes next instruction address to stack)
            newShellcode.Add(0xe8);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);

            // Set the offset to our DLL from pop result
            dllOffset = (uint)(bootstrapSize - newShellcode.Count + rdiShellcode.Length);

            // pop eax - Capture our current location in memory
            newShellcode.Add(0x58);

            // push ebp
            newShellcode.Add(0x55);

            // mov ebp, esp
            newShellcode.Add(0x89);                
            newShellcode.Add(0xe5);

            // mov ebx, eax - copy our location in memory to ebx before we start modifying eax
            newShellcode.Add(0x89);
            newShellcode.Add(0xc3);

            // add eax, <Offset to the DLL>
            newShellcode.Add(0x05);
            foreach (byte b in BitConverter.GetBytes(dllOffset))
                newShellcode.Add(b);

            // add ebx, <Offset to the DLL> + <Size of DLL>
            newShellcode.Add(0x81);
            newShellcode.Add(0xc3);
            foreach (byte b in BitConverter.GetBytes((uint)(dllOffset + dllBytes.Length)))
                newShellcode.Add(b);

            //push <Flags>
            newShellcode.Add(0x68);
            foreach (byte b in BitConverter.GetBytes(flags))
                newShellcode.Add(b);

            //push <Length of User Data>
            newShellcode.Add(0x68);
            foreach (byte b in BitConverter.GetBytes((uint)userData.Length))
                newShellcode.Add(b);

            // push ebx
            newShellcode.Add(0x53);

            // push <hash of function>
            newShellcode.Add(0x68);
            foreach (byte b in BitConverter.GetBytes(functionHash))
                newShellcode.Add(b);

            // push eax
            newShellcode.Add(0x50);

            // call - Transfer execution to the RDI
            newShellcode.Add(0xe8);
            newShellcode.Add((byte)(bootstrapSize - newShellcode.Count - 4)); // Skip over the remainder of instructions
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);

            // leave
            newShellcode.Add(0xc9);

            // ret - return to caller
            newShellcode.Add(0xc3);

            //Write the rest of RDI
            foreach (byte b in rdiShellcode)
                newShellcode.Add(b);
        }
        
        byte[] finalBytes = newShellcode.ToArray();
        Array.Resize(ref finalBytes, finalBytes.Length + dllBytes.Length + userData.Length);

        //Write our DLL
        dllBytes[0] = 0x00;
        dllBytes[1] = 0x00;
        Buffer.BlockCopy(dllBytes, 0, finalBytes, newShellcode.Count, dllBytes.Length);

        //Write our userdata
        Buffer.BlockCopy(userData, 0, finalBytes, newShellcode.Count + dllBytes.Length, userData.Length);

        return finalBytes;
    }
}
"@

Function ConvertTo-Shellcode{
    <#
    .SYNOPSIS
    Convert DLL file to position independent shellcode

    Author: Nick Landers (@monoxgas)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: Invoke-Shellcode.ps1

    .DESCRIPTION
    Uses ShellcodeRDI to bootstrap and shellcode PE loader to an existing file. When
    execution is passed to the converted shellcode, the DLL file is unpacked and loaded
    in memory.

    .EXAMPLE
    C:\PS> ConvertTo-Shellcode -File TestDLL_x86.dll

    .EXAMPLE
    C:\PS> import-module .\Invoke-Shellcode.ps1
    C:\PS> Invoke-Shellcode -Shellcode (ConvertTo-Shellcode TestDLL_x64.dll -ClearHeader)

    .PARAMETER File
    The target DLL file to convert

    .PARAMETER FunctionHash
    Hashed name of the function to call after DLLMain

    .PARAMETER UserData
    Data to pass to the target function

    .PARAMETER DeleteHeader
    Clear the PE header on load
    #>
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory=$True,Position=1)]
      [string] $File,

      [Parameter(Position=2)]
      [int] $FunctionHash = 0x30627745,

      [Parameter(Position=3)]
      [string] $UserData = "dave",

      [switch] $ClearHeader      
    )

    $Parameters = New-Object System.CodeDom.Compiler.CompilerParameters
    $Parameters.CompilerOptions += "/unsafe"
    Add-Type -TypeDefinition $Source -Language CSharp -CompilerParameters $Parameters

    $FileData = [System.IO.File]::ReadAllBytes($File)

    $UserDataBytes =  [system.Text.Encoding]::Default.GetBytes($UserData)

    # https://github.com/PowerShell/PowerShell/issues/3313
    $UintHash = [System.Uint32][System.Convert]::ToUint32($FunctionHash.ToString("X8"), 16)
    
    $Flags = 0

    if($ClearHeader){
        $Flags = ($Flags -bor 0x1)
    }

    [sRDI]::ConvertToShellcode($FileData, $UintHash, $UserDataBytes, $Flags)
    
}
