Received: from mga12.intel.com ([192.55.52.136]:32849 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726806AbeH1L6r (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 28
 Aug 2018 07:58:47 -0400
Date: Tue, 28 Aug 2018 11:08:14 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 04/13] x86/sgx: Architectural structures
Message-ID: <20180828080814.GE15508@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-5-jarkko.sakkinen@linux.intel.com>
 <3e8cf7d4-0d84-9526-816a-a2da30d81de7@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <3e8cf7d4-0d84-9526-816a-a2da30d81de7@intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Mon, Aug 27, 2018 at 12:41:29PM -0700, Dave Hansen wrote:
> > +/**
> > + * enum sgx_encls_leaves - return codes for ENCLS, ENCLU and ENCLV
> > + * %SGX_SUCCESS:		No error.
> > + * %SGX_INVALID_SIG_STRUCT:	SIGSTRUCT contains an invalid value.
> > + * %SGX_INVALID_ATTRIBUTE:	Enclave is not attempting to access a resource
> > + *				for which it is not authorized.
> > + * %SGX_BLKSTATE:		EPC page is already blocked.
> > + * %SGX_INVALID_MEASUREMENT:	SIGSTRUCT or EINITTOKEN contains an incorrect
> > + *				measurement.
> ...
> > +enum sgx_return_codes {
> > +	SGX_SUCCESS			= 0,
> > +	SGX_INVALID_SIG_STRUCT		= 1,
> > +	SGX_INVALID_ATTRIBUTE		= 2,
> > +	SGX_BLKSTATE			= 3,
> > +	SGX_INVALID_MEASUREMENT		= 4,
> ...
> 
> I don't think I've ever seen this particular method of commenting
> before.  It's rather verbose and duplicates the names twice, which seems
> a bit silly.
> 
> Can you talk a bit about why you chose to do it this way?  I'd
> personally much rather see at least some brief comments inline with the
> definitions.

The reason that I chose this was

  https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt

It is recommended in the "kernel-doc for structs, unions, enums, and
typedefs" section.

/Jarkko
