Date: Sat, 28 Jul 2018 16:23:23 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jethro Beekman <jethro@fortanix.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Darren Hart <dvhart@infradead.org>, "Andy
 Shevchenko" <andy@infradead.org>, "open list:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 11/13] platform/x86: Intel SGX driver
Message-ID: <20180728132323.GC7697@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-12-jarkko.sakkinen@linux.intel.com>
 <2cd5def0-61f0-3d57-efa4-7d835d7bdb86@fortanix.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <2cd5def0-61f0-3d57-efa4-7d835d7bdb86@fortanix.com>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Wed, Jul 25, 2018 at 08:52:27AM -0700, Jethro Beekman wrote:
> On 2018-07-03 11:19, Jarkko Sakkinen wrote:
> > +/* IOCTL return values */
> > +#define SGX_POWER_LOST_ENCLAVE		0x40000000
> > +#define SGX_LE_ROLLBACK			0x40000001
> 
> I don't think SGX_LE_ROLLBACK is used anymore.
> 
> Jethro Beekman | Fortanix

Correct. Thaks for spotting that out.

I've on a leave for soon past three weeks and one week is remaining but
have been slowly preparing v13 like one day a week so after next week it
shouldn't take much time to get it out.

/Jarkko
