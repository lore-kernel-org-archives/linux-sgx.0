Date: Mon, 5 Nov 2018 16:09:33 +0200
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
 Anvin" <hpa@zytor.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, David
 Woodhouse <dwmw@amazon.co.uk>, <davidwang@zhaoxin.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, "Levin, Alexander (Sasha Levin)"
	<alexander.levin@verizon.com>, <qianyue.zj@alibaba-inc.com>, "Linux Kernel
 Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 05/23] x86/cpu/intel: Detect SGX support and update
 caps appropriately
Message-ID: <20181105140933.GA24038@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-6-jarkko.sakkinen@linux.intel.com>
 <CAHp75VcG4FtiS9bDM_pP216kxobFxkChDu6uxvuTsMHQ=YJ3Zg@mail.gmail.com>
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
In-Reply-To: <CAHp75VcG4FtiS9bDM_pP216kxobFxkChDu6uxvuTsMHQ=YJ3Zg@mail.gmail.com>
Sender: <linux-kernel-owner@vger.kernel.org>
Return-Path: linux-kernel-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Sat, Nov 03, 2018 at 03:05:39PM +0200, Andy Shevchenko wrote:
> > +static void detect_sgx(struct cpuinfo_x86 *c)
> > +{
> > +       bool unsupported = false;
> > +       unsigned long long fc;
> > +
> > +       rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
> > +       if (!(fc & FEATURE_CONTROL_LOCKED)) {
> > +               pr_err_once("sgx: IA32_FEATURE_CONTROL MSR is not locked\n");
> > +               unsupported = true;
> > +       } else if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
> > +               pr_err_once("sgx: not enabled in IA32_FEATURE_CONTROL MSR\n");
> > +               unsupported = true;
> > +       } else if (!cpu_has(c, X86_FEATURE_SGX1)) {
> > +               pr_err_once("sgx: SGX1 instruction set not supported\n");
> > +               unsupported = true;
> > +       }
> 
> If you do
> 
> } else {
>  /* Supported */
>  return;
> }

Agree. Would this be a more clean flow in the attached patch?

/Jarkko

--qMm9M+Fa2AknHoGS
Content-Type: text/x-diff; charset="us-ascii"
Content-Disposition: attachment;
	filename="0001-x86-cpu-intel-clean-up-detect_sgx-flow.patch"


--qMm9M+Fa2AknHoGS--
