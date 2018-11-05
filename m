Return-Path: <SRS0=4Rt9=NQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846F7C46475
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Nov 2018 14:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55DD12081D
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Nov 2018 14:11:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55DD12081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbeKEXba (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:31:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:14242 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbeKEXba (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Nov 2018 18:31:30 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2018 06:11:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,468,1534834800"; 
   d="scan'208";a="84095054"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.180])
  by fmsmga008.fm.intel.com with ESMTP; 05 Nov 2018 06:11:28 -0800
Date:   Mon, 5 Nov 2018 16:11:28 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>, davidwang@zhaoxin.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>,
        qianyue.zj@alibaba-inc.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 05/23] x86/cpu/intel: Detect SGX support and update
 caps appropriately
Message-ID: <20181105141128.GB24038@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-6-jarkko.sakkinen@linux.intel.com>
 <CAHp75VcG4FtiS9bDM_pP216kxobFxkChDu6uxvuTsMHQ=YJ3Zg@mail.gmail.com>
 <20181105140933.GA24038@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105140933.GA24038@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181105141128.nDsSnFqt_oODGvHBDAmGV--Kf9qfjaZoLpqj7av99ys@z>

On Mon, Nov 05, 2018 at 04:09:33PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 03, 2018 at 03:05:39PM +0200, Andy Shevchenko wrote:
> > > +static void detect_sgx(struct cpuinfo_x86 *c)
> > > +{
> > > +       bool unsupported = false;
> > > +       unsigned long long fc;
> > > +
> > > +       rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
> > > +       if (!(fc & FEATURE_CONTROL_LOCKED)) {
> > > +               pr_err_once("sgx: IA32_FEATURE_CONTROL MSR is not locked\n");
> > > +               unsupported = true;
> > > +       } else if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
> > > +               pr_err_once("sgx: not enabled in IA32_FEATURE_CONTROL MSR\n");
> > > +               unsupported = true;
> > > +       } else if (!cpu_has(c, X86_FEATURE_SGX1)) {
> > > +               pr_err_once("sgx: SGX1 instruction set not supported\n");
> > > +               unsupported = true;
> > > +       }
> > 
> > If you do
> > 
> > } else {
> >  /* Supported */
> >  return;
> > }
> 
> Agree. Would this be a more clean flow in the attached patch?

Actually I'll paste the whole function for clarity because it is not too
long:

static void detect_sgx(struct cpuinfo_x86 *c)
{
	unsigned long long fc;

	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
	if (!(fc & FEATURE_CONTROL_LOCKED)) {
		pr_err_once("sgx: IA32_FEATURE_CONTROL MSR is not locked\n");
		goto out_unsupported;
	}

	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
		pr_err_once("sgx: not enabled in IA32_FEATURE_CONTROL MSR\n");
		goto out_unsupported;
	}

	if (!cpu_has(c, X86_FEATURE_SGX1)) {
		pr_err_once("sgx: SGX1 instruction set not supported\n");
		goto out_unsupported;
	}

	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
		pr_info_once("sgx: launch control MSRs are not writable\n");
		goto out_msrs_rdonly;
	}

	return;
out_unsupported:
	setup_clear_cpu_cap(X86_FEATURE_SGX);
	setup_clear_cpu_cap(X86_FEATURE_SGX1);
	setup_clear_cpu_cap(X86_FEATURE_SGX2);
out_msrs_rdonly:
	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
}

/Jarkko
