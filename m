Date: Wed, 4 Jul 2018 21:07:02 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 05/13] x86/sgx: architectural structures
Message-ID: <20180704180702.GM6724@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-6-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.21.1807032056460.1816@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.21.1807032056460.1816@nanos.tec.linutronix.de>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Jul 03, 2018 at 09:04:01PM +0200, Thomas Gleixner wrote:
> On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:
> 
> > This commit adds arch/x86/include/asm/sgx_arch.h that contains definitions
> 
> This is not a commit. Simply: Add .....
> 
> > for data structures used by the SGX.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> Documentaiton:
> 
>   A Co-Developed-by: states that the patch was also created by another developer
>   along with the original author.  This is useful at times when multiple people
>   work on a single patch.  Note, this person also needs to have a Signed-off-by:
>   line in the patch as well.
> 
> Please fix all over the place.

I used this tag for the first time and thought that it was undocumented
because checkpatch.pl complained about it. I will fix this.

> > +#define SGX_MISC_RESERVED_MASK 0xFFFFFFFFFFFFFFFEL
> 
> L ? ULL I'd say...

Yes, should be ULL.

> > +#define SGX_ATTR_RESERVED_MASK 0xFFFFFFFFFFFFFFC9L
> 
> Ditto
> 
> > +#define SGX_SECS_RESERVED1_SIZE 24
> > +#define SGX_SECS_RESERVED2_SIZE 32
> > +#define SGX_SECS_RESERVED3_SIZE 96
> > +#define SGX_SECS_RESERVED4_SIZE 3836
> > +
> > +struct sgx_secs {
> > +	uint64_t size;
> > +	uint64_t base;
> > +	uint32_t ssaframesize;
> > +	uint32_t miscselect;
> > +	uint8_t reserved1[SGX_SECS_RESERVED1_SIZE];
> > +	uint64_t attributes;
> 
> Please make these tabular aligned for readility sake

Ok, so it is now +2 for this. I can do that if you really want that.

> > +	uint32_t	miscselect;
> > +	uint8_t		reserved1[SGX_SECS_RESERVED1_SIZE];
> > +	uint64_t	attributes;
> 
> Hmm? All over the place...
> 
> > +enum sgx_tcs_flags {
> > +	SGX_TCS_DBGOPTIN	= 0x01, /* cleared on EADD */
> 
> Please do not use tail comments. Either put the comment above the define or
> use kernel doc.
> 
> > +};
> > +
> > +#define SGX_TCS_RESERVED_MASK 0xFFFFFFFFFFFFFFFEL
> 
> See above.
> 
> > +#define SGX_SECINFO_PERMISSION_MASK	0x0000000000000007L
> > +#define SGX_SECINFO_PAGE_TYPE_MASK	0x000000000000FF00L
> > +#define SGX_SECINFO_RESERVED_MASK	0xFFFFFFFFFFFF00F8L
> 
> Ditto
> 
> Thanks,
> 
> 	tglx

Thank you.

/Jarkko
