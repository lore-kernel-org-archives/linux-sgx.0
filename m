Received: from mga03.intel.com ([134.134.136.65]:52484 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726826AbeH0X33 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Mon, 27
 Aug 2018 19:29:29 -0400
Subject: Re: [PATCH v13 04/13] x86/sgx: Architectural structures
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-5-jarkko.sakkinen@linux.intel.com>
CC: <sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <3e8cf7d4-0d84-9526-816a-a2da30d81de7@intel.com>
Date: Mon, 27 Aug 2018 12:41:29 -0700
In-Reply-To: <20180827185507.17087-5-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

> +/**
> + * enum sgx_encls_leaves - return codes for ENCLS, ENCLU and ENCLV
> + * %SGX_SUCCESS:		No error.
> + * %SGX_INVALID_SIG_STRUCT:	SIGSTRUCT contains an invalid value.
> + * %SGX_INVALID_ATTRIBUTE:	Enclave is not attempting to access a resource
> + *				for which it is not authorized.
> + * %SGX_BLKSTATE:		EPC page is already blocked.
> + * %SGX_INVALID_MEASUREMENT:	SIGSTRUCT or EINITTOKEN contains an incorrect
> + *				measurement.
...
> +enum sgx_return_codes {
> +	SGX_SUCCESS			= 0,
> +	SGX_INVALID_SIG_STRUCT		= 1,
> +	SGX_INVALID_ATTRIBUTE		= 2,
> +	SGX_BLKSTATE			= 3,
> +	SGX_INVALID_MEASUREMENT		= 4,
...

I don't think I've ever seen this particular method of commenting
before.  It's rather verbose and duplicates the names twice, which seems
a bit silly.

Can you talk a bit about why you chose to do it this way?  I'd
personally much rather see at least some brief comments inline with the
definitions.
