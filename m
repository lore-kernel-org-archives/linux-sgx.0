Date: Wed, 4 Jul 2018 20:36:12 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>, <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "open list:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 07/13] x86/sgx: data structures for tracking
 available EPC pages
Message-ID: <20180704173612.GK6724@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-8-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.21.1807032110460.1816@nanos.tec.linutronix.de>
 <00ca61d5-5a1d-5c83-3b49-62c899a87041@infradead.org>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <00ca61d5-5a1d-5c83-3b49-62c899a87041@infradead.org>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Jul 03, 2018 at 01:26:11PM -0700, Randy Dunlap wrote:
> On 07/03/18 12:46, Thomas Gleixner wrote:
> > On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:
> > 
> >> SGX has a set of data structures to maintain information about the enclaves
> >> and their security properties. BIOS reserves a fixed size region of
> >> physical memory for these structures by setting Processor Reserved Memory
> >> Range Registers (PRMRR). This memory area is called Enclave Page Cache
> >> (EPC).
> >>
> >> This commit adds a database of EPC banks for kernel to easily access the
> 
> what kind of database?  How does one query it?

Have to think of a better word. Thanks!

/Jarkko
