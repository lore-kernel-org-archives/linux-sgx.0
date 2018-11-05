Received: from mga17.intel.com ([192.55.52.151]:47376 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726255AbeKEX6A (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Mon, 5
 Nov 2018 18:58:00 -0500
Date: Mon, 5 Nov 2018 16:37:49 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	"David Woodhouse" <dwmw@amazon.co.uk>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, <davidwang@zhaoxin.com>, "Levin,
 Alexander (Sasha Levin)" <alexander.levin@verizon.com>,
	<qianyue.zj@alibaba-inc.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 14/23] x86/cpu/intel: Clear SGX_LC capability if not
 enabled in FEATURE_CONTROL
Message-ID: <20181105143749.GB2798@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-15-jarkko.sakkinen@linux.intel.com>
 <CAHp75VctUJRTecG4rVHXm0uO18ZndMgqJgtNyG25HtSzJF5uzg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHp75VctUJRTecG4rVHXm0uO18ZndMgqJgtNyG25HtSzJF5uzg@mail.gmail.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Sat, Nov 03, 2018 at 03:15:15PM +0200, Andy Shevchenko wrote:
> > @@ -618,6 +618,8 @@ static void detect_sgx(struct cpuinfo_x86 *c)
> >                 setup_clear_cpu_cap(X86_FEATURE_SGX1);
> >                 setup_clear_cpu_cap(X86_FEATURE_SGX2);
> >         }
> > +       if (unsupported || !(fc & FEATURE_CONTROL_SGX_LE_WR))
> > +               setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> >  }
> 
> A-ha, I see how you use this variable here (though it's still possible
> to get rid of it, choose what is better for readability /
> maintenance).

I would propose to squash this one to the earlier commit and refactor
it in a way that I proposed. Having this part as a separate commit in
my opinion is a bit confusing.

/Jarkko
