Date: Wed, 4 Jul 2018 20:34:48 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 07/13] x86/sgx: data structures for tracking
 available EPC pages
Message-ID: <20180704173448.GJ6724@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-8-jarkko.sakkinen@linux.intel.com>
 <48296e78-5979-a22f-c337-633deccf30bf@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48296e78-5979-a22f-c337-633deccf30bf@intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Jul 03, 2018 at 12:03:48PM -0700, Dave Hansen wrote:
> On 07/03/2018 11:19 AM, Jarkko Sakkinen wrote:
> > This commit adds a database of EPC banks for kernel to easily access the
> > available EPC pages. On UMA architectures there is a singe bank of EPC
> > pages. On NUMA architectures there is an EPC bank for each node.
> 
> Is this universally true?  What about Sub-NUMA-Clustering/Cluster-on-Die
> systems?

I have to say that I do not have a good answer right now but I will
study this area for the next version.

/Jarkko
