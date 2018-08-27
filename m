Subject: Re: [PATCH v13 09/13] x86/sgx: Enclave Page Cache (EPC) memory
 manager
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
CC: <sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>, Serge Ayoun
	<serge.ayoun@intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <40632d90-8222-e31a-4729-22b89ed52a8d@intel.com>
Date: Mon, 27 Aug 2018 14:14:24 -0700
In-Reply-To: <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 08/27/2018 11:53 AM, Jarkko Sakkinen wrote:
> +enum sgx_alloc_flags {
> +	SGX_ALLOC_ATOMIC	= BIT(0),
> +};

Doing this with enums is unprecedented IMNHO.  Why are you doing it this
way for simple, one-off constants?
