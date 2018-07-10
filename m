Date: Tue, 10 Jul 2018 13:57:27 +0200
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Platform
 Driver <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Ingo Molnar
	<mingo@redhat.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 05/13] x86/sgx: architectural structures
In-Reply-To: <CAHp75Vf-P6FhBLwWbAcU2z48+y5+uMTPKMLU6dRHBBKkbremeA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1807101356290.4356@nanos.tec.linutronix.de>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com> <20180703182118.15024-6-jarkko.sakkinen@linux.intel.com> <f9fe78ca-0ff4-814c-3681-a2366be01337@intel.com> <20180705200912.GA10701@linux.intel.com> <E666884A-3EED-426E-BAB1-FA23C57BA5B9@zytor.com>
 <CAHp75Vf-P6FhBLwWbAcU2z48+y5+uMTPKMLU6dRHBBKkbremeA@mail.gmail.com>
Content-Type: text/plain; charset="US-ASCII"
Return-Path: tglx@linutronix.de
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, 10 Jul 2018, Andy Shevchenko wrote:
> On Fri, Jul 6, 2018 at 12:50 AM,  <hpa@zytor.com> wrote:
> 
> > For things exported to user space use __u* and __s* types... the _t types would actually violate the C standard with respect to namespace pollution.
> 
> Hmm... Coding style 5(d) allows to use uintNN_t in new code (as a
> variation of uNN choice).

But not for user space exposed headers. See 5(e) for that matter.

Thanks,

	tglx
