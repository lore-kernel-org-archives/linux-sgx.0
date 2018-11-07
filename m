Date: Wed, 7 Nov 2018 10:00:57 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, <dave.hansen@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<andriy.shevchenko@linux.intel.com>, <tglx@linutronix.de>,
	<kai.svahn@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko
	<andy@infradead.org>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 18/22] platform/x86: Intel SGX driver
Message-ID: <20181107180057.GB24807@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
 <20181106134758.10572-19-jarkko.sakkinen@linux.intel.com>
 <1541522400.7839.48.camel@intel.com>
 <20181107163757.GB11509@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <20181107163757.GB11509@linux.intel.com>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Wed, Nov 07, 2018 at 06:37:57PM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 06, 2018 at 08:40:00AM -0800, Sean Christopherson wrote:
> > On Tue, 2018-11-06 at 15:45 +0200, Jarkko Sakkinen wrote:
> > > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > > can be used by applications to set aside private regions of code and
> > > data. The code outside the enclave is disallowed to access the memory
> > > inside the enclave by the CPU access control.
> > > 
> > > SGX driver provides a ioctl API for loading and initializing enclaves.
> > > Address range for enclaves is reserved with mmap() and they are
> > > destroyed with munmap(). Enclave construction, measurement and
> > > initialization is done with the provided the ioctl API.
> > 
> > ...
> > 
> > > +struct sgx_encl {
> > > +	unsigned int flags;
> > > +	uint64_t attributes;
> > > +	uint64_t xfrm;
> > > +	unsigned int page_cnt;
> > > +	unsigned int secs_child_cnt;
> > > +	struct mutex lock;
> > > +	struct mm_struct *mm;
> > > +	struct file *backing;
> > 
> > Is there any particular reason why the kernel manages the backing for
> > the enclave and the PCMDs?  Could we have userspace provide the backing
> > either through the ECREATE ioctl() or maybe a completely new ioctl(),
> > e.g. to give userspace the option to back the enclave with a NVDIMM
> > instead of RAM?  A separate ioctl() with control flags might give us
> > some flexibility in the future, e.g. maybe there are use cases where
> > userspace would prefer to kill enclaves rather than swap EPC.
> 
> Not really except that no one has complained. The very first swapping
> code that I implemented used a VMA as backing storage. I could take
> pieces of that code to replace shmem specifics. The difference was that
> the driver did vm_mmap(). Now that you suggested the above I wonder how
> it did not came to mind back then to provide the VMA as parameter.
> 
> A single buffer that can hold both PCMD entries and swapped pages in its
> address space would probably be the  best way to do it. I would add that
> as a field to struct sgx_enclave_create. If we want the kill-behavior,
> you could signal that with a NULL value.

What do we gain by a single buffer vs. separate buffers?  The ioctl()
would be slightly smaller but it seems like the actual code would be
more complex.

The enclave build process also utilizes the backing as temp storage
to avoid having to alloc kernel memory when queueing pages to be added
by the worker thread (which reminds me that I wanted to document why a
worker thread is used).  Keeping this behavior would effectively make
providing backing mandatory.

Are there any potential complications with ENCLS consuming userspace
pointers?  We'd have to wrap them with user_access_{begin,end}() and
probably tweak the fixup, but I assume having the fixup handler means
we're generally ok?
