Date: Fri, 5 Oct 2018 14:32:44 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <nhorman@redhat.com>, <npmccallum@redhat.com>,
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>,
	<linux-sgx@vger.kernel.org>, <andriy.shevchenko@linux.intel.com>, "Suresh
 Siddha" <suresh.b.siddha@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko
	<andy@infradead.org>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 15/19] platform/x86: Intel SGX driver
Message-ID: <20181005113244.GB25985@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-16-jarkko.sakkinen@linux.intel.com>
 <1538676077.2562.6.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <1538676077.2562.6.camel@intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Thu, Oct 04, 2018 at 11:01:17AM -0700, Sean Christopherson wrote:
> On Tue, 2018-09-25 at 16:06 +0300, Jarkko Sakkinen wrote:
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the enclave is disallowed to access the memory
> > inside the enclave by the CPU access control.
> > 
> > SGX driver provides a ioctl API for loading and initializing enclaves.
> > Address range for enclaves is reserved with mmap() and they are
> > destroyed with munmap(). Enclave construction, measurement and
> > initialization is done with the provided the ioctl API.
> 
> ...
> 
> > +/**
> > + * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
> > + *
> > + * @filep:	open file to /dev/sgx
> > + * @cmd:	the command value
> > + * @arg:	pointer to an &sgx_enclave_init instance
> > + *
> > + * Flushes the remaining enqueued EADD operations and performs EINIT. Does not
> > + * allow the EINITTOKENKEY attribute for an enclave.
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   SGX error code on EINIT failure,
> > + *   -errno otherwise
> > + */
> > +static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
> > +				 unsigned long arg)
> > +{
> > +	struct sgx_enclave_init *initp = (struct sgx_enclave_init *)arg;
> > +	struct sgx_sigstruct *sigstruct;
> > +	struct sgx_einittoken *einittoken;
> > +	struct sgx_encl *encl;
> > +	struct page *initp_page;
> > +	int ret;
> > +
> > +	initp_page = alloc_page(GFP_HIGHUSER);
> > +	if (!initp_page)
> > +		return -ENOMEM;
> > +
> > +	sigstruct = kmap(initp_page);
> > +	einittoken = (struct sgx_einittoken *)
> > +		((unsigned long)sigstruct + PAGE_SIZE / 2);
> > +	memset(einittoken, 0, sizeof(*einittoken));
> > +
> > +	ret = copy_from_user(sigstruct, (void __user *)initp->sigstruct,
> > +			     sizeof(*sigstruct));
> > +	if (ret)
> > +		goto out;
> > +	if (sigstruct->attributes & SGX_ATTR_EINITTOKENKEY) {
> > +		ret = EINVAL;
> 
> This should be "ret = -EINVAL".

Ouch :-( Thank you for spotting this out.

/Jarkko
