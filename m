Subject: Re: [PATCH v13 04/13] x86/sgx: Architectural structures
To: Andy Shevchenko <andy.shevchenko@gmail.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-5-jarkko.sakkinen@linux.intel.com>
 <CAHp75VchsQXGRrcrcB06w68PzUZb5NJLo2B_ZKf6ZLqyBbvWhA@mail.gmail.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <83f5ec5f-1b31-15eb-7341-84ee9c7977e2@intel.com>
Date: Tue, 4 Sep 2018 09:04:44 -0700
In-Reply-To: <CAHp75VchsQXGRrcrcB06w68PzUZb5NJLo2B_ZKf6ZLqyBbvWhA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: <linux-kernel-owner@vger.kernel.org>
Return-Path: linux-kernel-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 09/03/2018 06:16 AM, Andy Shevchenko wrote:
>> +       EBLOCK  = 0x9,
>> +       EPA     = 0xA,
>> +       EWB     = 0xB,
>> +       ETRACK  = 0xC,
>> +       EAUG    = 0xD,
>> +       EMODPR  = 0xE,
>> +       EMODT   = 0xF,
>> +};
> Hmm... This E prefix confuses me with (system wide) error codes. Has
> it been discussed before? If so, can you point on the conclusion why
> the current format is good?

Making them SGX_EWHATEVER isn't a horrible idea.
