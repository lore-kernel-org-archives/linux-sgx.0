Received: from mail-qt0-f194.google.com ([209.85.216.194]:37199 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbeIDUcX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 4 Sep 2018 16:32:23 -0400
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-5-jarkko.sakkinen@linux.intel.com> <CAHp75VchsQXGRrcrcB06w68PzUZb5NJLo2B_ZKf6ZLqyBbvWhA@mail.gmail.com>
 <83f5ec5f-1b31-15eb-7341-84ee9c7977e2@intel.com>
In-Reply-To: <83f5ec5f-1b31-15eb-7341-84ee9c7977e2@intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 4 Sep 2018 19:06:26 +0300
Message-ID: <CAHp75VfqFAgPbHDLBdDF_VRFRoGuBBMtA0HuOeDTZtNgFe-8yQ@mail.gmail.com>
Subject: Re: [PATCH v13 04/13] x86/sgx: Architectural structures
To: Dave Hansen <dave.hansen@intel.com>
CC: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "maintainer:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Tue, Sep 4, 2018 at 7:04 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 09/03/2018 06:16 AM, Andy Shevchenko wrote:
> >> +       EBLOCK  = 0x9,
> >> +       EPA     = 0xA,
> >> +       EWB     = 0xB,
> >> +       ETRACK  = 0xC,
> >> +       EAUG    = 0xD,
> >> +       EMODPR  = 0xE,
> >> +       EMODT   = 0xF,
> >> +};
> > Hmm... This E prefix confuses me with (system wide) error codes. Has
> > it been discussed before? If so, can you point on the conclusion why
> > the current format is good?
>
> Making them SGX_EWHATEVER isn't a horrible idea.

+1 here. Namespace will not shadow SDM naming scheme.

-- 
With Best Regards,
Andy Shevchenko
